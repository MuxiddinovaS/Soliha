--Write a query to assign a row number to each sale based on the SaleDate.
select *, ROW_NUMBER() over(order by SaleDate) as row_number from ProductSales
--Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.
select *, sum(Quantity) as TotalQuantitySold, DENSE_RANK() over (order by sum(Quantity) desc) as SalesRank
from ProductSales
group by ProductName;
--Write a query to identify the top sale for each customer based on the SaleAmount.
SELECT *
FROM (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        Quantity,
        CustomerID,
        RANK() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS SaleRank
    FROM ProductSales
) AS RankedSales
WHERE SaleRank = 1;

--Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.
SELECT *, 
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

--Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.
select *, LAG(SaleAmount) over (order by SaleDate) as previoussaleamount from ProductSales;
--Write a query to identify sales amounts that are greater than the previous sale's amount
select *, lag(SaleAmount) over (order by SaleDate) as previous from ProductSales  where SaleAmount > lag(SaleAmount) over (order by SaleDate) ; 

--Write a query to calculate the difference in sale amount from the previous sale for every product
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount,
    SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS AmountDifference
FROM ProductSales;

--Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
SELECT 
    SaleID,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount,
    ROUND(
        (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount,
        2
    ) AS PercentageChange
FROM ProductSales;

--Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select *, lag(SaleAmount) over (order by SaleDate) as previoussaleamount,
round(SaleAmount * 1.0  / (lag(SaleAmount) over (order by SaleDate) - SaleAmount), 2) as RatioChange from ProductSales
--Write a query to calculate the difference in sale amount from the very first sale of that product.
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS FirstSaleAmount,
    SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DifferenceFromFirst
FROM ProductSales;

--Write a query to find sales that have been increasing continuously for a product (i.e., each sale amount is greater than the previous sale amount for that product).
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales
WHERE SaleAmount > LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate);

--Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (ORDER BY SaleDate) AS ClosingBalance
FROM ProductSales;

--Write a query to calculate the moving average of sales amounts over the last 3 sales.
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (
        ORDER BY SaleDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverage_Last3
FROM ProductSales;

--Write a query to show the difference between each sale amount and the average sale amount.
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - AVG(SaleAmount) OVER () AS DifferenceFromAverage
FROM ProductSales;



--Find Employees Who Have the Same Salary Rank
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

--Identify the Top 2 Highest Salaries in Each Department
SELECT *
FROM (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
) ranked
WHERE SalaryRank <= 2
ORDER BY Department, SalaryRank, Salary DESC;

--Find the Lowest-Paid Employee in Each Department
SELECT *
FROM (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS RowNum
    FROM Employees1
) AS ranked
WHERE RowNum = 1;

--Calculate the Running Total of Salaries in Each Department
select * from (select EmployeeID, Name, Department, Salary,
sum(Salary) over (partition by Department order by Salary desc) as running_total
from Employees1) as ranked
--Find the Total Salary of Each Department Without GROUP BY
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalDepartmentSalary
FROM Employees1;

--Calculate the Average Salary in Each Department Without GROUP BY
select EmployeeID, Name, Department, Salary,
avg(Salary) over (partition by Department) as AverageSalary
from Employees1
--Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgDepartmentSalary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS SalaryDifference
FROM Employees1;

--Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (
        ORDER BY EmployeeID
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS MovingAvgSalary_3Employees
FROM Employees1;

--Find the Sum of Salaries for the Last 3 Hired Employees
SELECT
    EmployeeID,
    Name,
    Department,
    HireDate,
    Salary,
    SUM(Salary) OVER (
        ORDER BY HireDate DESC
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS SumLast3HiredSalaries
FROM Employees1
ORDER BY HireDate DESC;
