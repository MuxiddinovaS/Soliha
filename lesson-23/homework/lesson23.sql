--In this puzzle you have to extract the month from the dt column and then append zero single digit month if any. Please check out sample input and expected output.
SELECT 
    Id,
    Dt,
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR), 2) AS MonthPrefixedWithZero
FROM Dates;


--In this puzzle you have to find out the unique Ids present in the table. You also have to find out the SUM of Max values of vals columns for each Id and RId. For more details please see the sample input and expected output.
SELECT 
    (SELECT COUNT(DISTINCT Id) FROM MyTabel) AS Distinct_Ids,
    rID,
    SUM(MaxVal) AS TotalOfMaxVals
FROM (
    SELECT 
        Id,
        rID,
        MAX(Vals) AS MaxVal
    FROM MyTabel
    GROUP BY Id, rID
) AS MaxValsPerGroup
GROUP BY rID;


--In this puzzle you have to get records with at least 6 characters and maximum 10 characters. Please see the sample input and expected output.
SELECT *
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;

--In this puzzle you have to find the maximum value for each Id and then get the Item for that Id and Maximum value. Please check out sample input and expected output.
SELECT t.ID, t.Item, t.Vals
FROM TestMaximum t
JOIN (
    SELECT ID, MAX(Vals) AS MaxVal
    FROM TestMaximum
    GROUP BY ID
) AS maxVals
ON t.ID = maxVals.ID AND t.Vals = maxVals.MaxVal;


--In this puzzle you have to first find the maximum value for each Id and DetailedNumber, and then Sum the data using Id only. Please check out sample input and expected output.

SELECT Id, SUM(MaxVal) AS SumofMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVal
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS MaxValsPerGroup
GROUP BY Id;

--In this puzzle you have to find difference between a and b column between each row and if the difference is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.Please check the sample input and the expected output.
SELECT 
    Id, 
    a, 
    b, 
    CASE 
        WHEN a - b = 0 THEN '' 
        ELSE CAST(a - b AS VARCHAR)
    END AS OUTPUT
FROM TheZeroPuzzle;

--What is the total revenue generated from all sales?
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

--What is the average unit price of products?
select avg(UnitPrice) as avg_unitprice
from Sales
--How many sales transactions were recorded?
select count(*) as total_transactions
from Sales
--What is the highest number of units sold in a single transaction?
select max(QuantitySold) as quant_sold
from Sales
--How many products were sold in each category?
select Category , sum(QuantitySold) as prod_sold_by_category from Sales 
group by Category
--What is the total revenue for each region?
select Region, sum(QuantitySold * UnitPrice) as total_revenue
from Sales
group by Region

--Which product generated the highest total revenue?
SELECT TOP 1 
    Product, 
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

--Compute the running total of revenue ordered by sale date.
SELECT 
    SaleID,
    SaleDate,
    Product,
    QuantitySold,
    UnitPrice,
    QuantitySold * UnitPrice AS Revenue,
    SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales
ORDER BY SaleDate;

--How much does each category contribute to total sales revenue?
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue,
    ROUND(
        100.0 * SUM(QuantitySold * UnitPrice) / 
        (SELECT SUM(QuantitySold * UnitPrice) FROM Sales), 2
    ) AS PercentageOfTotal
FROM Sales
GROUP BY Category;

--Show all sales along with the corresponding customer names
SELECT *
FROM Customers
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID FROM Sales
);

--List customers who have not made any purchases
SELECT *
FROM Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Sales
);

--Compute total revenue generated from each customer
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

--Find the customer who has contributed the most revenue
SELECT TOP 1 
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

--Calculate the total sales per customer
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

--List all products that have been sold at least once
SELECT DISTINCT p.ProductID, p.ProductName, p.Category, p.CostPrice, p.SellingPrice
FROM Products p
JOIN Sales s ON p.ProductName = s.Product;

--Find the most expensive product in the Products table
SELECT TOP 1 ProductID, ProductName, Category, CostPrice, SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

--Find all products where the selling price is higher than the average selling price in their category
SELECT p.ProductID, p.ProductName, p.Category, p.CostPrice, p.SellingPrice
FROM Products p
JOIN (
    SELECT Category, AVG(SellingPrice) AS AvgSellingPrice
    FROM Products
    GROUP BY Category
) avg_cat ON p.Category = avg_cat.Category
WHERE p.SellingPrice > avg_cat.AvgSellingPrice;
