--Create a numbers table using a recursive query from 1 to 1000.
with Numbers as (select 1 as number
union all
select number + 1 from Numbers
where number < 1000 )
select * from Numbers
option (maxrecursion 1000)

--Write a query to find the total sales per employee using a derived table.(Sales, Employees)
SELECT e.EmployeeID, e.EmployeeName, s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SaleAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) s ON e.EmployeeID = s.EmployeeID;

--Create a CTE to find the average salary of employees.(Employees)
with CTE_avg as (select avg(Salary) as avgsalary from Employees)
select avgsalary from CTE_avg
--Write a query using a derived table to find the highest sales for each product.(Sales, Products)
SELECT p.ProductID, p.ProductName, s.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) s ON p.ProductID = s.ProductID;

--Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.
WITH Doubles AS (
    SELECT 1 AS value
    UNION ALL
    SELECT value * 2
    FROM Doubles
    WHERE value * 2 < 1000000
)
SELECT * FROM Doubles
OPTION (MAXRECURSION 20); 


--Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS SaleCount
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT e.EmployeeID, e.FirstName
FROM Employees e
JOIN SalesCount sc ON e.EmployeeID = sc.EmployeeID;

--Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)
WITH ProductSales AS (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.ProductID, p.ProductName, ps.TotalSales
FROM Products p
JOIN ProductSales ps ON p.ProductID = ps.ProductID
WHERE ps.TotalSales > 500;

--Create a CTE to find employees with salaries above the average salary.(Employees)
WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT e.EmployeeID, e.FirstName, e.Salary
FROM Employees e
JOIN AvgSalaryCTE a ON e.Salary > a.AvgSalary;



--Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
SELECT e.EmployeeID, e.FirstName, s.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
    ORDER BY OrderCount 
) s ON e.EmployeeID = s.EmployeeID;

--Write a query using a derived table to find the sales per product category.(Sales, Products)
SELECT* from Sales 
    p.CategoryName,
    SUM(sales_data.TotalSales) AS TotalSales
FROM
    (SELECT 
         ProductID, 
         SalesAmount * UnitPrice AS TotalSales
     FROM 
         Sales) AS sales_data
JOIN 
    Products p ON sales_data.ProductID = p.ProductID
GROUP BY 
    p.CategoryName;

--Write a script to return the factorial of each value next to it.(Numbers1)
WITH FactorialCTE AS (
    SELECT * from Numbers1
        Number,
        1 AS Factorial,
        1 AS n
    FROM Numbers1

    UNION ALL

    SELECT 
        f.Number,
        f.Factorial * (n + 1),
        n + 1
    FROM FactorialCTE f
    WHERE n + 1 <= f.Number
)
SELECT 
    Number,
    MAX(Factorial) AS Factorial
FROM 
    FactorialCTE
GROUP BY 
    Number
ORDER BY 
    Number;

--This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
-- Recursive CTE to split strings character by character
WITH SplitCTE AS (
    SELECT 
        Id,
        CAST(SUBSTRING(String, 1, 1) AS VARCHAR(1)) AS Character,
        1 AS Position,
        String
    FROM Example

    UNION ALL

    SELECT 
        Id,
        CAST(SUBSTRING(String, Position + 1, 1) AS VARCHAR(1)),
        Position + 1,
        String
    FROM SplitCTE
    WHERE Position + 1 <= LEN(String)
)

SELECT 
    Id,
    Position,
    Character
FROM 
    SplitCTE
ORDER BY 
    Id, Position;

--Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
WITH MonthlySales AS (
    SELECT 
        FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
        SUM(SalesAmount) AS MonthlyTotal
    FROM Sales
    GROUP BY FORMAT(SaleDate, 'yyyy-MM')
),

MonthlyDiff AS (
    SELECT 
        SaleMonth,
        MonthlyTotal,
        LAG(MonthlyTotal) OVER (ORDER BY SaleMonth) AS PreviousMonthTotal
    FROM MonthlySales
)

SELECT 
    SaleMonth,
    MonthlyTotal,
    PreviousMonthTotal,
    MonthlyTotal - ISNULL(PreviousMonthTotal, 0) AS SalesDifference
FROM MonthlyDiff
ORDER BY SaleMonth;

--Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    sq.Year,
    sq.Quarter,
    sq.TotalSales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        DATEPART(YEAR, SaleDate) AS Year,
        DATEPART(QUARTER, SaleDate) AS Quarter,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(YEAR, SaleDate), DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) sq ON e.EmployeeID = sq.EmployeeID
ORDER BY e.EmployeeID, sq.Year, sq.Quarter;



--This script uses recursion to calculate Fibonacci numbers
WITH FibonacciCTE (n, FibValue) AS (
    SELECT 1 AS n, 0 AS FibValue
    UNION ALL
    SELECT 2, 1
    UNION ALL
    SELECT n + 1,
           (SELECT FibValue FROM FibonacciCTE f WHERE f.n = FibonacciCTE.n - 1) +
           (SELECT FibValue FROM FibonacciCTE f WHERE f.n = FibonacciCTE.n - 2)
    FROM FibonacciCTE
    WHERE n < 20 -- Change 20 to however many Fibonacci numbers you want
)
SELECT * FROM FibonacciCTE
ORDER BY n;

--Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)
SELECT *
FROM FindSameCharacters
WHERE LEN(Id) > 1
  AND Id NOT LIKE '%[^' + LEFT(Id, 1) + ']%';

 
--Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)
DECLARE @n INT = 5;

WITH NumbersCTE (num, str) AS (
    SELECT 1, CAST('1' AS VARCHAR(MAX))
    UNION ALL
    SELECT num + 1, str + CAST(num + 1 AS VARCHAR)
    FROM NumbersCTE
    WHERE num + 1 <= @n
)
SELECT str AS Number
FROM NumbersCTE;

--Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)
SELECT e.EmployeeID, e.FirstName, s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE()) 
    GROUP BY EmployeeID
) s ON e.EmployeeID = s.EmployeeID
WHERE s.TotalSales = (
    SELECT MAX(TotalSales)
    FROM (
        SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
        FROM Sales
        WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID
    ) AS SalesTotals
);

--Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)
WITH Extracted AS (
    SELECT 
        PawanName,
        Pawan_slug_name,
        TRY_CAST(RIGHT(Pawan_slug_name, CHARINDEX('-', REVERSE(Pawan_slug_name)) - 1) AS INT) AS Num
    FROM RemoveDuplicateIntsFromNames
),
Filtered AS (
    SELECT DISTINCT PawanName, Num
    FROM Extracted
    WHERE Num IS NOT NULL AND LEN(Num) > 1
)
SELECT 
    f.PawanName,
    CONCAT(LEFT(e.Pawan_slug_name, CHARINDEX('-', e.Pawan_slug_name)), f.Num) AS Cleaned_slug_name
FROM Filtered f
JOIN RemoveDuplicateIntsFromNames e ON f.PawanName = e.PawanName;

