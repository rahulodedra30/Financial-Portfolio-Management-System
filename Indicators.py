import pandas as pd
import numpy as np

# data_df = pd.read_csv('LastPriceData.csv')
data_df1 = pivoted_data.LastPriceData
data_df1['Date'] = pd.to_datetime(data_df1['Date'])

data_df2 = pd.read_csv("LowPriceData.csv")
data_df2['Date'] = pd.to_datetime(data_df2['Date'])

data_df3 = pd.read_csv("HighPriceData.csv")
data_df3['Date'] = pd.to_datetime(data_df3['Date'])

data_df4 = pivoted_data.VolumeData
data_df4['Date'] = pd.to_datetime(data_df4['Date'])

def fetch_data(security_list, date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date']<date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    data1 = pd.DataFrame(data1)
    
    last_date = data_df2[data_df2['Date'] < date]['Date'].iloc[-1]
    data2 = data_df2.set_index('Date')
    data2 = data2.loc[first_date:last_date, security_list]
    data2.name = 'Low'
    data2.index.name = 'ID'
    data2 = pd.DataFrame(data2)
    
    last_date = data_df3[data_df3['Date'] < date]['Date'].iloc[-1]
    data3 = data_df3.set_index('Date')
    data3 = data3.loc[first_date:last_date, security_list]
    data3.name = 'High'
    data3.index.name = 'ID'
    data3 = pd.DataFrame(data3)
    
    tp=(data1+data2+data3)/3
    tp=tp.dropna(axis=1)
    return(tp)   

def Bollinger_avg(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date']<date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    data1 = pd.DataFrame(data1)

    Avg = data1.mean().dropna()
    StdDev = data1.std().dropna()
    #upper = Sma + 2*StdDev
    #lower = Sma - 2*StdDev
    z_score = ((data1 - Avg)/StdDev).dropna(axis=1).iloc[-1,:]
    return z_score

def RSI(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    data1 = pd.DataFrame(data1).dropna(axis=1)

    CloseDelta = data1.diff()
    
    up = CloseDelta.clip(lower=0)
    down = -1 * CloseDelta.clip(upper=0)
    #if ema==True:
        #ma_up = up.ewm(com=period-1,adjust =True,min_periods=period).mean()
        #ma_down = down.ewm(com=period-1,adjust =True,min_periods=period).mean()
    ma_up = up.mean().dropna()
    ma_down = down.mean().dropna()
   
    RSI = ma_up / ma_down     
    RSI = 100 - (100/(1+RSI))
    return RSI

def OBV(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
    
    last_date = data_df4[data_df4['Date'] < date]['Date'].iloc[-1]
    data4 = data_df4.set_index('Date')
    data4 = data4.loc[first_date:last_date, security_list]
    data4.name = 'Volume'
    data4.index.name = 'ID'
    volume = pd.DataFrame(data4).dropna(axis=1)
    
    OBV = pd.Series(np.zeros((volume.shape[1])))
    OBV.index = volume.columns
        
    for j in range(0,close.shape[1]):
        
        pos_vol_flow = 0
        neg_vol_flow = 0
        
        for i in range(1,(len(close))):
            if close.iloc[i,j] > close.iloc[i-1,j]:
                pos_vol_flow += volume.iloc[i,j]
            else:
                neg_vol_flow += volume.iloc[i,j]
        print(pos_vol_flow,neg_vol_flow,pos_vol_flow-neg_vol_flow)
    
        OBV[volume.columns[j]] = pos_vol_flow - neg_vol_flow
    return OBV
        
def CCI(security_list,date,period):
    tp=fetch_data(security_list, date,period)
    Avg = tp.mean()
    Mad = tp.mad()
    tp=tp.iloc[-1,:]
    Cci = (tp - Avg)/(0.015 * Mad)
    Cci=pd.DataFrame(Cci)
    Cci = Cci.rename(columns={Cci.columns[0]:'Commodity_Channel_Index'})
    #tp = tp.squeeze()
    
    return Cci

def MACD(security_list,date,period,fast_period,slow_period):
    factor_data = fetch_data(security_list, date,period,fast_period,slow_period)
   
    fast_period = factor_data.ewm(span=fast_period,adjust=False).mean().iloc[-1,:].dropna()
    slow_period  = factor_data.ewm(span=slow_period,adjust=False).mean().iloc[-1,:].dropna()
    Macd = fast_period - slow_period 
    signal_line = Macd.ewm(span=period,adjust=False).mean()
    histogram = Macd - signal_line
    MACD = -histogram
    return MACD
    
def APO(security_list,date,fast_period,slow_period):
    #factor_data = fetch_data(security_list, date,fast_period,slow_period)
    apo = EMA(security_list, date, fast_period) - EMA(security_list, date, slow_period)
    return apo

def PPO(security_list,date,fast_period,slow_period):
    fast_avg = EMA(security_list, date, fast_period)
    slow_avg = EMA(security_list, date, slow_period)
    
    ppo = ((fast_avg - slow_avg)/slow_avg)*100
    return ppo

def high_px(security_list,date,period):
    first_date = date - relativedelta(days=period)

    last_date = data_df2[data_df2['Date'] < date]['Date'].iloc[-1]
    data2 = data_df2.set_index('Date')
    data2 = data2.loc[first_date:last_date, security_list]
    data2.name = 'Low'
    data2.index.name = 'ID'
    low = pd.DataFrame(data2).dropna(axis=1)
    
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
   
    high = 2147483647 
    
    high = max(close,high)
    return high

def low_px(security_list,date,period):
    first_date = date - relativedelta(days=period)

    last_date = data_df3[data_df3['Date'] < date]['Date'].iloc[-1]
    data3 = data_df3.set_index('Date')
    data3 = data3.loc[first_date:last_date, security_list]
    data3.name = 'High'
    data3.index.name = 'ID'
    high = pd.DataFrame(data3).dropna(axis=1)
    
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
   
    low = -2147483647
    
    low = min(close,low)
    return low

def typical_price(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)

    hpx1 = high_px(security_list, date, period)
    lpx1 = low_px(security_list, date, period)
    
    typical_price = (hpx1 + lpx1 + close)/3
    return typical_price

def WILLR(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    data1 = pd.DataFrame(data1).dropna(axis=1)
    
    highhigh = high_px(security_list, date, period)
    lowlow = low_px(security_list, date, period)
    
    WILLR = -100 * (( highhigh - data1) / (highhigh - lowlow))
    return WILLR

def BP_Sum(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
    
    last_date = data_df2[data_df2['Date'] < date]['Date'].iloc[-1]
    data2 = data_df2.set_index('Date')
    data2 = data2.loc[first_date:last_date, security_list]
    data2.name = 'Low'
    data2.index.name = 'ID'
    low = pd.DataFrame(data2).dropna(axis=1)
    
    bp_sum = pd.Series(np.zeros((close.shape[1])))
    bp_sum.index = close.columns
    for j in range(0,low.shape[1]):
        
        for i in range(1,(len(low))):
            if low.iloc[i,j] < close.iloc[i-1,j]:
                min = low.iloc[i,j]
            else:
                min = close.iloc[i-1,j]
        
        bp_sum[close.columns[j]] += (close.iloc[i,j] - min)
            
    return bp_sum
            

def TR_Sum(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
    
    last_date = data_df2[data_df2['Date'] < date]['Date'].iloc[-1]
    data2 = data_df2.set_index('Date')
    data2 = data2.loc[first_date:last_date, security_list]
    data2.name = 'Low'
    data2.index.name = 'ID'
    low = pd.DataFrame(data2).dropna(axis=1)
    
    last_date = data_df3[data_df3['Date'] < date]['Date'].iloc[-1]
    data3 = data_df3.set_index('Date')
    data3 = data3.loc[first_date:last_date, security_list]
    data3.name = 'High'
    data3.index.name = 'ID'
    high = pd.DataFrame(data3).dropna(axis=1)
    
    tr_sum = pd.Series(np.zeros((close.shape[1])))
    tr_sum.index = close.columns
    
    for j in range(0,high.shape[1]):
        
        for i in range(1,len(high)):
            if high.iloc[i,j] > close.iloc[i-1,j]:
                max = high.iloc[i,j]
            else:
                max = close.iloc[i-1,j]
            
            if low.iloc[i,j] < close.iloc[i-1,j]:
                min = low.iloc[i,j]
            else:
                min = close.iloc[i-1,j]
                
        tr_sum[close.columns[j]] += max - min
        
    return tr_sum 
            
def ULTOSC(security_list,date,period):
    
    Avg7 = BP_Sum(security_list, date, 7) / TR_Sum(security_list, date, 7)
    Avg14 = BP_Sum(security_list, date, 14) / TR_Sum(security_list, date, 14)
    Avg28 = BP_Sum(security_list, date, 28) / TR_Sum(security_list, date, 28)
    
    ultosc = (100 * (4*Avg7 + 2*Avg14 + 1*Avg28) / 7).dropna()
    return ultosc

def TR(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
    
    last_date = data_df2[data_df2['Date'] < date]['Date'].iloc[-1]
    data2 = data_df2.set_index('Date')
    data2 = data2.loc[first_date:last_date, security_list]
    data2.name = 'Low'
    data2.index.name = 'ID'
    low = pd.DataFrame(data2).dropna(axis=1)
    
    last_date = data_df3[data_df3['Date'] < date]['Date'].iloc[-1]
    data3 = data_df3.set_index('Date')
    data3 = data3.loc[first_date:last_date, security_list]
    data3.name = 'High'
    data3.index.name = 'ID'
    high = pd.DataFrame(data3).dropna(axis=1)
    
    arr1 = (high - close).iloc[-1,:]
    arr2 = (close - low).iloc[-1,:] 
    arr3 = (high - low).iloc[-1,:] 
    
    #tr = np.max(arr1, arr2)
    for i in range(0,len(arr1)):
        if (arr1[i] > arr2[i]) and (arr1[i] > arr3[i]):
            tr = arr1
        elif (arr2[i] > arr1[i]) and (arr2[i] > arr3[i]):
            tr = arr2
        else:
            tr = arr3
        
    return tr

def CMO(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
    
    last_date = data_df2[data_df2['Date'] < date]['Date'].iloc[-1]
    data2 = data_df2.set_index('Date')
    data2 = data2.loc[first_date:last_date, security_list]
    data2.name = 'Low'
    data2.index.name = 'ID'
    low = pd.DataFrame(data2).dropna(axis=1)
    
    last_date = data_df3[data_df3['Date'] < date]['Date'].iloc[-1]
    data3 = data_df3.set_index('Date')
    data3 = data3.loc[first_date:last_date, security_list]
    data3.name = 'High'
    data3.index.name = 'ID'
    high = pd.DataFrame(data3).dropna(axis=1)
    
    cmo = pd.Series(np.zeros((high.shape[1])))
    cmo.index = high.columns
    
    for j in range(0,high.shape[1]):
        
        pos_mon_flow = 0
        neg_mon_flow = 0
        
        for i in range(1,(len(high))):
            if high.iloc[i,j] > high.iloc[i-1,j]:
                pos_mon_flow += (high.iloc[i,j] - high.iloc[i-1,j])
            else:
                neg_mon_flow += (high.iloc[i-1,j] - high.iloc[i,j])
                
        cmo[high.columns[j]] = 100*(pos_mon_flow-neg_mon_flow)/(pos_mon_flow+neg_mon_flow)
        
    return cmo

def MFI(security_list,date,period):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
    
    last_date = data_df2[data_df2['Date'] < date]['Date'].iloc[-1]
    data2 = data_df2.set_index('Date')
    data2 = data2.loc[first_date:last_date, security_list]
    data2.name = 'Low'
    data2.index.name = 'ID'
    low = pd.DataFrame(data2).dropna(axis=1)
    
    last_date = data_df3[data_df3['Date'] < date]['Date'].iloc[-1]
    data3 = data_df3.set_index('Date')
    data3 = data3.loc[first_date:last_date, security_list]
    data3.name = 'High'
    data3.index.name = 'ID'
    high = pd.DataFrame(data3).dropna(axis=1)
    
    mfi = pd.Series(np.zeros((close.shape[1])))
    mfi.index = close.columns
    
    for j in range(0,close.shape[1]):
        pos_mon_flow = 0
        neg_mon_flow = 0
        
        for i in range(1,len(high)):
            if close.iloc[i,j] > close.iloc[i-1,j]:
                hpx1 = high_px(security_list, date, period)
                lpx1 = low_px(security_list, date, period)
                pivot = (lpx1 + hpx1 + close.iloc[i,j])/3
                money_flow = pivot * volume.iloc[i,j]
                pos_mon_flow += money_flow
            else:
                hpx1 = high_px(security_list, date, period)
                lpx1 = low_px(security_list, date, period)
                pivot = (lpx1 + hpx1 + close.iloc[i,j])/3
                money_flow = pivot * volume.iloc[i,j]
                neg_mon_flow += money_flow 
            
        mfi[close.columns[j]] = 100 - 100*neg_mon_flow/(pos_mon_flow+neg_mon_flow)
        mfi = 100 - mfi
    return mfi
    
def MinMax(security_list,date,period=20):
    first_date = date - relativedelta(days=period)
    #end_date = date - relativedelta(days=1)
    last_date = data_df1[data_df1['Date'] <date]['Date'].iloc[-1]

    data1 = data_df1.set_index('Date')
    data1 = data1.loc[first_date:last_date, security_list]
    data1.name = 'Close'
    data1.index.name = 'ID'
    close = pd.DataFrame(data1).dropna(axis=1)
    
    max = high_px(security_list, date, period)
    min = low_px(security_list, date, period)
    minmax = (max - close)/(max-min)
    return minmax
    
def Midpt(security_list,date,period=14):
    hpx1 = high_px(security_list, date, period)
    lpx1 = low_px(security_list, date, period)
    midpt = (hpx1+lpx1)/2
    midpt = -(close - midpt)
    return midpt
    
    
    
    
    
    
