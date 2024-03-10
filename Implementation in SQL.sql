
DROP DATABASE `financial_portfolio_management_system`;

-- Creation of database

CREATE DATABASE financial_portfolio_management_system;
USE financial_portfolio_management_system;

-- Creation of Tables

-- Creating Table Company
CREATE TABLE Company(
ISIN INT PRIMARY KEY,
Ticker VARCHAR(10) NOT NULL,
Name VARCHAR(100) NOT NULL,
Sector VARCHAR(20) NOT NULL,
Market_Cap FLOAT NOT NULL);

-- Creating Table Price
CREATE TABLE Price(
Ticker VARCHAR(10) PRIMARY KEY,
price FLOAT,
DATE TIMESTAMP,
ISIN INT NOT NULL,
FOREIGN KEY (ISIN) REFERENCES Company (ISIN));

-- Creating Table Return_Analytics
CREATE TABLE Return_Analytics(
Return_ID INT PRIMARY KEY,
Benchmark_Return FLOAT,
Portfolio_Return FLOAT,
DATE TIMESTAMP NOT NULL);

-- Creating Table Sector_Wise_Return
CREATE TABLE Sector_Wise_Return(
Return_ID INT PRIMARY KEY,
Sector varchar(50) unique,
Benchmark_Return FLOAT NOT NULL,
Portfolio_Return FLOAT NOT NULL,
FOREIGN KEY(Return_ID) REFERENCES Return_Analytics(Return_ID));

-- Creating Table MarketCAP_Wise_Return
CREATE TABLE MarketCAP_Wise_Return(
Return_ID INT PRIMARY KEY,
Marketcap varchar(20) unique,
Benchmark_Return FLOAT NOT NULL,
Portfolio_Return FLOAT NOT NULL,
FOREIGN KEY(Return_ID) REFERENCES Return_Analytics(Return_ID));

-- Creating Table Client_Wise_Allocation
CREATE TABLE Client_Wise_Allocation(
Client_ID INT PRIMARY KEY,
Client_Name VARCHAR(20),
Investment_Amount INT,
Current_Value FLOAT,
Percentage_Gain_or_Loss FLOAT,
DATE TIMESTAMP);

-- Creating Table Client_Transaction
CREATE TABLE Client_Transaction(
Client_Transaction_ID INT PRIMARY KEY,
DATE TIMESTAMP NOT NULL,
Amount INT NOT NULL);

-- Creating Table Client_Profile
CREATE TABLE Client_Profile(
Client_ID INT NOT NULL,
Client_Name VARCHAR(20) NOT NULL,
Expected_Return FLOAT NOT NULL,
Investment_Amount INT NOT NULL,
Investment_Duration INT NOT NULL,
Risk_appetite FLOAT NOT NULL,
Client_Transaction_ID INT,
FOREIGN KEY(Client_ID) REFERENCES Client_Wise_Allocation(Client_ID),
FOREIGN KEY (Client_Transaction_ID) REFERENCES Client_Transaction(Client_Transaction_ID));

-- Creating Table Portfolio_Creation
CREATE TABLE Portfolio_Creation(
Ticker VARCHAR(10) PRIMARY KEY,
DATE TIMESTAMP NOT NULL,
Name VARCHAR(100) NOT NULL,
Sector VARCHAR(20) NOT NULL,
Quantity INT NOT NULL,
Market_Cap FLOAT NOT NULL,
Return_ID INT,
FOREIGN KEY(Return_ID) REFERENCES Return_Analytics(Return_ID));

-- Creating Table Generates
CREATE TABLE Generates(
Client_ID INT NOT NULL,
Ticker VARCHAR(10) NOT NULL,
FOREIGN KEY(Client_ID) REFERENCES Client_Profile(Client_ID),
FOREIGN KEY(Ticker) REFERENCES Portfolio_Creation(Ticker));

-- Creating Table Technical_Strategy
CREATE TABLE Technical_Strategy(
ISIN INT PRIMARY KEY,
Volatility FLOAT,
Volume INT,
SMA FLOAT,
EMA FLOAT,
MACD varchar(20),
RSI FLOAT,
Sharpe_Ratio FLOAT,
price FLOAT,
Ticker VARCHAR(10),
FOREIGN KEY (Ticker) REFERENCES Price(Ticker),
FOREIGN KEY (Ticker) REFERENCES Portfolio_Creation(Ticker));

-- Creating Table Fundamental_Report
CREATE TABLE Fundamental_Report(
ISIN INT PRIMARY KEY,
DATE TIMESTAMP NOT NULL,
P_E_Ratio FLOAT NOT NULL,
Debt FLOAT NOT NULL,
Dividend FLOAT NOT NULL,
EPS FLOAT NOT NULL,
Ticker VARCHAR(10),
FOREIGN KEY (ISIN) REFERENCES Company(ISIN),
FOREIGN KEY (Ticker) REFERENCES Portfolio_Creation(Ticker));

-- Inserting data into Tables we just Created

-- Inserting data into Company table
INSERT INTO Company (ISIN, Ticker, Name, Sector, Market_Cap)
VALUES 
(1, 'AAPL', 'Apple Inc', 'Technology', 2000000000000),
(2, 'GOOGL', 'Alphabet', 'Technology', 1500000000000),
(3, 'MSFT', 'Microsoft', 'Technology', 1800000000000),
(4, 'AMZN', 'Amazon.com Inc.', 'Technology', 1600000000000),
(5, 'TSLA', 'Tesla Inc.', 'Automotive', 800000000000),
(6, 'V', 'Visa Inc.', 'Finance', 450000000000),
(7, 'JPM', 'JPMorgan Chase & Co.', 'Finance', 350000000000),
(8, 'DIS', 'The Walt Disney Company', 'Entertainment', 250000000000),
(9, 'IBM', 'IBM Corporation', 'Technology', 120000000000),
(10, 'GE', 'General Electric Company', 'Industrial', 100000000000),
(11, 'NFLX', 'Netflix Inc.', 'Entertainment', 200000000000),
(12, 'FB', 'Meta Platforms Inc.', 'Technology', 700000000000),
(13, 'KO', 'The Coca-Cola Company', 'Beverages', 180000000000),
(14, 'PEP', 'PepsiCo Inc.', 'Beverages', 160000000000),
(15, 'GS', 'The Goldman Sachs Group', 'Finance', 300000000000),
(16, 'WMT', 'Walmart Inc.', 'Retail', 400000000000),
(17, 'MS', 'Morgan Stanley', 'Finance', 280000000000),
(18, 'AAP', 'Advance Auto Parts Inc.', 'Automotive', 50000000000),
(19, 'MCD', 'McDonald\'s Corporation', 'Food', 200000000000),
(20, 'GOOG', 'Alphabet Inc.', 'Technology', 1700000000000);


-- Inserting data into Price table
INSERT INTO Price (Ticker, price, DATE, ISIN)
VALUES
('AAPL', 150.0, '2023-01-01', 1),
('AMZN', 3200.0, '2023-01-01', 4),
('TSLA', 900.0, '2023-01-01', 5),
('V', 220.0, '2023-01-01', 6),
('JPM', 150.0, '2023-01-01', 7),
('DIS', 170.0, '2023-01-01', 8),
('IBM', 120.0, '2023-01-01', 9),
('GE', 10.0, '2023-01-01', 10),
('NFLX', 600.0, '2023-01-01', 11),
('FB', 340.0, '2023-01-01', 12),
('KO', 50.0, '2023-01-01', 13),
('PEP', 150.0, '2023-01-01', 14),
('GS', 200.0, '2023-01-01', 15),
('WMT', 140.0, '2023-01-01', 16),
('MS', 90.0, '2023-01-01', 17),
('AAP', 120.0, '2023-01-01', 18),
('MCD', 200.0, '2023-01-01', 19),
('GOOG', 2500.0, '2023-01-01', 20);

-- Inserting data into Technical_Strategy table
INSERT INTO Technical_Strategy (ISIN, Volatility, Volume, SMA, EMA, MACD, RSI, Sharpe_Ratio, price)
VALUES
(1, 0.1, 1000000, 145.0, 143.5, 'bull', 70.0, 1.2, 155.0),
(2, 0.08, 500000, 2480.0, 2475.5, 'bull', 65.0, 1.1, 2550.0),
(3, 0.12, 800000, 305.0, 303.5, 'bull', 72.0, 1.3, 310.0),
(4, 0.15, 1200000, 3220.0, 3215.5, 'bear', 60.0, 0.9, 3250.0),
(5, 0.18, 900000, 930.0, 925.5, 'bull', 75.0, 1.5, 950.0),
(6, 0.09, 200000, 225.0, 220.5, 'bear', 68.0, 1.0, 225.0),
(7, 0.11, 300000, 155.0, 152.5, 'bear', 55.0, 0.8, 155.0),
(8, 0.14, 400000, 175.0, 172.5, 'bear', 62.0, 1.1, 175.0),
(9, 0.13, 600000, 125.0, 123.5, 'bear', 58.0, 0.7, 125.0),
(10, 0.17, 150000, 11.0, 10.5, 'bear', 50.0, 0.6, 11.0),
(11, 0.16, 700000, 620.0, 615.5, 'bull', 78.0, 1.8, 620.0),
(12, 0.2, 800000, 350.0, 345.5, 'bull', 68.0, 1.0, 350.0),
(13, 0.1, 100000, 52.0, 50.5, 'bear', 45.0, 0.5, 52.0),
(14, 0.08, 120000, 155.0, 152.5, 'bull', 60.0, 0.9, 155.0),
(15, 0.12, 200000, 205.0, 202.5, 'bear', 55.0, 0.8, 205.0),
(16, 0.15, 250000, 145.0, 142.5, 'bull', 65.0, 1.1, 145.0),
(17, 0.18, 300000, 95.0, 92.5, 'bear', 58.0, 0.7, 95.0),
(18, 0.14, 180000, 125.0, 122.5, 'bull', 53.0, 0.6, 125.0),
(19, 0.09, 220000, 205.0, 202.5, 'bear', 68.0, 1.0, 205.0),
(20, 0.11, 260000, 2550.0, 2545.5, 'bull', 62.0, 1.1, 2550.0);

-- Inserting data into Fundamental_Report table without Ticker
INSERT INTO Fundamental_Report (ISIN, DATE, P_E_Ratio, Debt, Dividend, EPS)
VALUES
(1, '2023-01-01', 20.0, 5000000000.0, 2.0, 5.0),
(2, '2023-01-02', 25.0, 8000000000.0, 1.5, 4.0),
(3, '2023-01-03', 18.0, 3000000000.0, 3.0, 6.0),
(4, '2023-01-04', 30.0, 12000000000.0, 1.0, 8.0),
(5, '2023-01-05', 40.0, 6000000000.0, 0.5, 10.0),
(6, '2023-01-06', 15.0, 2000000000.0, 2.5, 3.0),
(7, '2023-01-07', 22.0, 4000000000.0, 1.2, 6.5),
(8, '2023-01-08', 28.0, 4500000000.0, 1.8, 5.5),
(9, '2023-01-09', 35.0, 7000000000.0, 0.8, 7.0),
(10, '2023-01-10', 14.0, 1500000000.0, 2.2, 4.5),
(11, '2023-01-11', 32.0, 10000000000.0, 1.5, 9.0),
(12, '2023-01-12', 27.0, 6000000000.0, 2.0, 6.0),
(13, '2023-01-13', 18.0, 300000000.0, 2.8, 4.0),
(14, '2023-01-14', 24.0, 2000000000.0, 1.0, 6.5),
(15, '2023-01-15', 30.0, 5000000000.0, 0.5, 8.0),
(16, '2023-01-16', 16.0, 800000000.0, 1.2, 3.5),
(17, '2023-01-17', 22.0, 1200000000.0, 1.0, 5.5),
(18, '2023-01-18', 19.0, 700000000.0, 2.5, 4.0),
(19, '2023-01-19', 26.0, 1500000000.0, 1.8, 7.0),
(20, '2023-01-20', 33.0, 20000000000.0, 0.5, 10.0);

-- Inserting data into Return_Analytics table
INSERT INTO Return_Analytics (Return_ID, Benchmark_Return, Portfolio_Return, DATE)
VALUES
(101, 5.0, 7.2, '2023-01-01'),
(102, 4.8, 6.5, '2023-01-02'),
(103, 6.2, 8.0, '2023-01-03'),
(104, 5.5, 7.8, '2023-01-04'),
(105, 7.0, 9.5, '2023-01-05'),
(106, 6.5, 8.2, '2023-01-06'),
(107, 4.0, 6.0, '2023-01-07'),
(108, 5.8, 7.5, '2023-01-08'),
(109, 6.5, 8.2, '2023-01-09'),
(110, 3.5, 5.0, '2023-01-10');

-- Inserting data into Sector_Wise_Return table
INSERT INTO Sector_Wise_Return (Return_ID, Sector, Benchmark_Return, Portfolio_Return)
VALUES
(101, 'Technology', 0.07, 3.0),
(102, 'Healthcare', 0.05, 2.2),
(103, 'Financial Services', 0.08, 2.8),
(104, 'Consumer Discretionary', 0.06, 2.5),
(105, 'Consumer Staples', 0.04, 1.8),
(106, 'Energy', 0.03, 1.5),
(107, 'Industrials', 0.06, 2.7),
(108, 'Utilities', 0.04, 1.9),
(109, 'Materials', 0.05, 2.0),
(110, 'Real Estate', 0.07, 3.2);

-- Inserting data into MarketCAP_Wise_Return table
INSERT INTO MarketCAP_Wise_Return (Return_ID, Marketcap, Benchmark_Return, Portfolio_Return)
VALUES
(101, 'Large Cap', 0.09,0.11),
(102, 'Mid Cap', 0.14, 0.19),
(103, 'Small Cap', 0.12, 0.16);


-- Inserting data into Client_Wise_Allocation table
INSERT INTO Client_Wise_Allocation (Client_ID, Client_Name, Investment_Amount, Current_Value, Percentage_Gain_or_Loss, DATE)
VALUES
(201, 'John Doe', 5000000, 5250000, 0.05, '2023-02-01'),
(202, 'Jane Smith', 75000, 80000, 6.7, '2023-01-02'),
(203, 'Mike Johnson', 100000, 110000, 10.0, '2023-01-03'),
(204, 'Emily Davis', 30000, 32000, 6.7, '2023-01-04'),
(205, 'Robert Brown', 120000, 130000, 8.3, '2023-01-05'),
(206, 'Sara Wilson', 60000, 65000, 8.3, '2023-01-06'),
(207, 'Chris Lee', 80000, 84000, 5.0, '2023-01-07'),
(208, 'Anna White', 45000, 48000, 6.7, '2023-01-08'),
(209, 'Daniel Taylor', 70000, 75000, 7.1, '2023-01-09'),
(210, 'Olivia Moore', 55000, 58000, 5.5, '2023-01-10'),
(211, 'Matthew Clark', 90000, 95000, 5.6, '2023-01-11'),
(212, 'Ella Harris', 110000, 115000, 4.5, '2023-01-12'),
(213, 'William Anderson', 40000, 42000, 5.0, '2023-01-13'),
(214, 'Sophia Martin', 85000, 90000, 5.9, '2023-01-14'),
(215, 'James Thompson', 95000, 100000, 5.3, '2023-01-15'),
(216, 'Ava Garcia', 60000, 64000, 6.7, '2023-01-16'),
(217, 'Joseph Rodriguez', 70000, 75000, 7.1, '2023-01-17'),
(218, 'Emma Hernandez', 48000, 50000, 4.6, '2023-01-18'),
(219, 'Michael Smith', 55000, 58000, 5.5, '2023-01-19'),
(220, 'Isabella Davis', 78000, 82000, 5.1, '2023-01-20');

-- Inserting data into Client_Transaction table
INSERT INTO Client_Transaction (Client_Transaction_ID, DATE, Amount)
VALUES
(1001, '2023-01-01', 5000000),
(1002, '2023-01-02', 7000),
(1003, '2023-01-03', 10000),
(1004, '2023-01-04', 3000),
(1005, '2023-01-05', 12000),
(1006, '2023-01-06', 6000),
(1007, '2023-01-07', 8000),
(1008, '2023-01-08', 4500),
(1009, '2023-01-09', 7000),
(1010, '2023-01-10', 5500),
(1011, '2023-01-11', 9000),
(1012, '2023-01-12', 11000),
(1013, '2023-01-13', 4000),
(1014, '2023-01-14', 8500),
(1015, '2023-01-15', 9500),
(1016, '2023-01-16', 6000),
(1017, '2023-01-17', 7000),
(1018, '2023-01-18', 4800),
(1019, '2023-01-19', 5500),
(1020, '2023-01-20', 7800);


-- Inserting data into Client_Profile table
INSERT INTO Client_Profile (Client_ID, Client_Name, Expected_Return, Investment_Amount, Investment_Duration, Risk_appetite, Client_Transaction_ID)
VALUES
(201, 'John Doe', 0.08, 5000000, 5, 0.2, 1001),
(202, 'Jane Smith', 7.5, 75000, 5, 0.4, 1002),
(203, 'Mike Johnson', 9.0, 100000, 7, 0.6, 1003),
(204, 'Emily Davis', 6.5, 30000, 2, 0.3, 1004),
(205, 'Robert Brown', 8.5, 120000, 4, 0.7, 1005),
(206, 'Sara Wilson', 7.2, 60000, 6, 0.5, 1006),
(207, 'Chris Lee', 6.0, 80000, 8, 0.4, 1007),
(208, 'Anna White', 7.8, 45000, 3, 0.6, 1008),
(209, 'Daniel Taylor', 8.2, 70000, 5, 0.5, 1009),
(210, 'Olivia Moore', 5.5, 55000, 7, 0.3, 1010),
(211, 'Matthew Clark', 9.5, 90000, 2, 0.8, 1011),
(212, 'Ella Harris', 7.8, 110000, 4, 0.6, 1012),
(213, 'William Anderson', 6.5, 40000, 6, 0.4, 1013),
(214, 'Sophia Martin', 7.0, 85000, 8, 0.5, 1014),
(215, 'James Thompson', 9.0, 95000, 3, 0.7, 1015),
(216, 'Ava Garcia', 8.5, 60000, 5, 0.6, 1016),
(217, 'Joseph Rodriguez', 7.2, 70000, 7, 0.5, 1017),
(218, 'Emma Hernandez', 6.7, 48000, 2, 0.4, 1018),
(219, 'Michael Smith', 8.0, 55000, 4, 0.6, 1019),
(220, 'Isabella Davis', 9.8, 78000, 6, 0.8, 1020);

-- Inserting data into Portfolio_Creation table
INSERT INTO Portfolio_Creation (Ticker, DATE, Name, Sector, Quantity, Market_Cap)
VALUES
('AAPL', '2023-01-01', 'Apple Inc.', 'Technology', 100, 1500000.0),
('GOOGL', '2023-01-02', 'Alphabet Inc.', 'Technology', 50, 3000000.0),
('MSFT', '2023-01-03', 'Microsoft', 'Technology', 75, 1200000.0),
('AMZN', '2023-01-04', 'Amazon.com Inc.', 'Retail', 30, 9000000.0),
('TSLA', '2023-01-05', 'Tesla Inc.', 'Automotive', 20, 1800000.0),
('V', '2023-01-06', 'Visa Inc.', 'Finance', 40, 2000000.0),
('JPM', '2023-01-07', 'JPMorgan Chase & Co.', 'Finance', 25, 1000000.0),
('DIS', '2023-01-08', 'The Walt Disney Company', 'Entertainment', 35, 1400000.0),
('IBM', '2023-01-09', 'International Business Machines Corporation', 'Technology', 50, 1250000.0),
('GE', '2023-01-10', 'General Electric Company', 'Industrial', 15, 150000.0),
('NFLX', '2023-01-11', 'Netflix Inc.', 'Entertainment', 10, 600000.0),
('FB', '2023-01-12', 'Meta Platforms Inc.', 'Technology', 30, 900000.0),
('KO', '2023-01-13', 'The Coca-Cola Company', 'Beverages', 40, 200000.0),
('PEP', '2023-01-14', 'PepsiCo Inc.', 'Beverages', 20, 800000.0),
('GS', '2023-01-15', 'The Goldman Sachs Group Inc.', 'Finance', 25, 1250000.0),
('WMT', '2023-01-16', 'Walmart Inc.', 'Retail', 30, 1450000.0),
('MS', '2023-01-17', 'Morgan Stanley', 'Finance', 15, 450000.0),
('AAP', '2023-01-18', 'Advance Auto Parts Inc.', 'Automotive', 20, 600000.0),
('MCD', '2023-01-19', 'McDonald\'s Corporation', 'Food', 25, 1250000.0),
('GOOG', '2023-01-20', 'Alphabet Inc.', 'Technology', 30, 2550000.0);


-- Inserting data into Generates table
INSERT INTO Generates (Client_ID, Ticker)
VALUES
(201, 'AAPL'),
(201, 'GOOGL'),
(201, 'IBM'),
(202, 'GOOGL'),
(203, 'MSFT'),
(203, 'GE'),
(203, 'WMT'),
(204, 'AMZN'),
(205, 'TSLA'),
(206, 'GOOG'),
(206, 'IBM'),
(206, 'NFLX'),
(207, 'JPM'),
(208, 'DIS'),
(208, 'MS'),
(209, 'IBM'),
(210, 'GE'),
(211, 'NFLX'),
(212, 'FB'),
(213, 'KO'),
(213, 'WMT'),
(214, 'PEP'),
(215, 'GS'),
(215, 'FB'),
(216, 'WMT'),
(217, 'MS'),
(218, 'AAP'),
(219, 'GOOG'),
(219, 'MCD'),
(219, 'AAPL'),
(220, 'GOOG');

SET SQL_SAFE_UPDATES = 0;
-- Add column Mkt_cap in Company
ALTER TABLE Company
ADD COLUMN Mkt_cap varchar(30);
 
-- Update column Mkt_cap of Company
UPDATE Company
SET Mkt_cap =  
    CASE
        WHEN Market_Cap < 100000000000 THEN 'Small cap'
        WHEN Market_Cap >= 100000000000 and Market_Cap < 1500000000000 THEN 'Mid cap'
        WHEN Market_Cap >= 1500000000000 THEN 'Large cap'
    END;
SELECT * FROM Company;

-- Add column Risk_level in Client_Profile
ALTER TABLE Client_Profile
ADD COLUMN Risk_level varchar(30);
SELECT * FROM Client_Profile;

-- Update column Risk_level in Client_Profile
UPDATE Client_Profile
SET Risk_level = 
    CASE
        WHEN Risk_appetite > 0.6 THEN 'high'
        WHEN Risk_appetite > 0.4 and Risk_appetite <= 0.6  THEN 'Moderate'
        WHEN Risk_appetite <= 0.4  THEN 'Low'
    END;


-- MySQL Queries Demo

-- Simple Query
-- Query 1: Find ISIN, P_E_Ratio, Debt and Dividend of Companies from Fundamental Table where P/E Ratio less than 30?
SELECT ISIN, P_E_Ratio, Debt, Dividend FROM Fundamental_Report
WHERE P_E_Ratio < 30;

-- Aggregate Query
-- Query 2: Find the Average Market Capital of Each Sector?
SELECT Sector, AVG(Market_Cap) AS Avg_Market_Cap
FROM Portfolio_Creation
GROUP BY Sector;

-- Inner Join/ Outer Join
-- Query 3. Find the Total buy amount in Portfolio table ?
SELECT pc.Ticker, (pc.Quantity * p.price) AS total_buy_amount
FROM Portfolio_Creation pc
INNER JOIN Price p ON pc.Ticker = p.Ticker;

-- Nested Query
-- Query 4: Find the Clients who have invested in all the stocks of Portfolio Creation ?
SELECT cp.Client_Name FROM Client_Profile cp
JOIN Generates g
JOIN Portfolio_Creation p
WHERE cp.Client_ID = g.Client_ID AND g.Ticker = p.Ticker
GROUP BY cp.Client_Name
HAVING COUNT(distinct g.Ticker) = 
	(SELECT COUNT(DISTINCT p1.Ticker) 
	FROM Portfolio_Creation p1);
-- Note : There is no Client who has invested in all the stocks.

-- Correlated Query
/*  Ques 8. Retreive client name if there exists investment amount greater than 10000 and 
current value of investment is greater than investment amount and risk level is adjusted to low */           
SELECT cp.Client_Name
FROM Client_Profile cp
WHERE cp.Risk_level = 'Low'
AND EXISTS
	(
	 SELECT 1 FROM Client_Wise_Allocation ca
     WHERE ca.CLient_ID = cp.CLient_ID AND
		   ca.Current_Value > ca.Investment_Amount AND
           ca.Investment_Amount>7500
     );

-- Exist Query
-- Query 6. Find the list of Customers who made transactions in Companies belonging to the ‘Technology’ Sector.
SELECT DISTINCT cw.Client_ID, cw.Client_Name 
FROM Client_Wise_Allocation cw
WHERE EXISTS (SELECT * FROM Generates g
JOIN Portfolio_Creation pc ON g.Ticker = pc.Ticker
JOIN Company c ON pc.ticker = c.ticker
WHERE c.Sector = 'Technology' AND g.Client_ID = cw.Client_ID);

-- Set Operations (Union)
-- Ques 7. Find the list of  Companies with stable fundamental and technical reports.
(SELECT f.ISIN, c.Name FROM Fundamental_Report f, Company c
WHERE f.ISIN = c.ISIN AND
	  Debt < 3000000000)
UNION
(SELECT t.ISIN,c.Name FROM Technical_Strategy t, Company c
WHERE t.ISIN = c.ISIN AND t.Volatility < 0.10 AND
      t.MACD = 'bull' AND t.Sharpe_ratio > 1.8);

-- Subquery in Select and From
-- Ques 8. Find the Ticker, Name, and Risk_level for each client from the Generates table along with their associated risk level.
SELECT
    g.Ticker,
    c.Name,
    (
        SELECT Risk_level
        FROM Client_Profile cp
        WHERE cp.Client_ID = g.Client_ID
        LIMIT 1
    ) AS Risk_level
FROM
    Generates g
JOIN
    Company c ON g.Ticker = c.Ticker;





