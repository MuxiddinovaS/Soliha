--Create a stored procedure that:

--Creates a temp table #EmployeeBonus
--Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
--(BonusAmount = Salary * BonusPercentage / 100)
--Then, selects all data from the temp table.

create table #EmployeeBonus( EmployeeID int,
FullName varchar(200),
 Department varchar(100),
 Salary decimal (10,2),
BonusAmount decimal( 10, 2))
INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Department,
        e.Salary,
        e.Salary * b.BonusPercentage / 100.0 AS BonusAmount
    FROM 
        Employees e
    INNER JOIN 
        DepartmentBonus b ON e.Department = b.Department;

		select * from #EmployeeBonus



--Create a stored procedure that:

--Accepts a department name and an increase percentage as parameters
--Update salary of all employees in the given department by the given percentage
--Returns updated employees from that department.


create procedure UpdateDepartmentSalaries
@DeptName nvarchar(50),
@IncreasePercent decimal (10, 2)
as begin 
update Employees
set Salary= Salary +(Salary * @IncreasePercent /100.0)
where Department = @DeptName;
select EmployeeID, FirstName, LastName, Department, Salary from Employees 
where Department = @DeptName end;
EXEC UpdateDepartmentSalaries @DeptName = 'IT', @IncreasePercent = 10;


--Perform a MERGE operation that:

--Updates ProductName and Price if ProductID matches
--Inserts new products if ProductID does not exist
--Deletes products from Products_Current if they are missing in Products_New
--Return the final state of Products_Current after the MERGE.

merge into Products_Current as target
using Products_new as source
on target.ProductID =source.ProductID
when matched then 
update set 
target.ProductName= source.ProductName,
target.Price = source.Price

when not matched then
insert (ProductID, ProductName, Price)
values (source.ProductID, source.ProductName, source.Price)

when not matched by source then 
delete;
select * from Products_Current;


--Tree Node

--Each node in the tree can be one of three types:

--"Leaf": if the node is a leaf node.
--"Root": if the node is the root of the tree.
--"Inner": If the node is neither a leaf node nor a root node.
--Write a solution to report the type of each node in the tree.


select t1.id,
  case 
  when t1.p_id is null then 'Root'  
    when t1.id in ( select distinct p_id from tree where p_id is not null) then  'inner'
  else 'leaf' 
  end as type
  from Tree t1
  order by t1.id



--  Confirmation Rate

--Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.

SELECT 
    s.user_id,
    ROUND(
        COALESCE(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END), 0) * 1.0 /
        NULLIF(COUNT(c.action), 0), 2
    ) AS confirmation_rate
FROM 
    Signups s
LEFT JOIN 
    Confirmations c ON s.user_id = c.user_id
GROUP BY 
    s.user_id;


--Find employees with the lowest salary
--Find all employees who have the lowest salary using subqueries.
select * from employees
where salary = (select min(salary) from employees)





--Get Product Sales Summary
--Create a stored procedure called GetProductSalesSummary that:

--Accepts a @ProductID input
--Returns:
--ProductName
--Total Quantity Sold
--Total Sales Amount (Quantity × Price)
--First Sale Date
--Last Sale Date
--If the product has no sales, return NULL for quantity, total amount, first date, and last date, but still return the product name.

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantitySold,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM 
        Products p
    LEFT JOIN 
        Sales s ON p.ProductID = s.ProductID
    WHERE 
        p.ProductID = @ProductID
    GROUP BY 
        p.ProductName;
END;
EXEC GetProductSalesSummary @ProductID = 1;
