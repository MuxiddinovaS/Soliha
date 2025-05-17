--Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
--Return: ProductID, TotalQuantity, TotalRevenue
create table #MonthlySales( ProductID int, TotalQuantity int, TotalRevenue decimal(10,2));
insert into #MonthlySales( ProductID, TotalQuantity,TotalRevenue) select s.ProductID, sum(s.Quantity) as TotalQuantity, 
sum(s.Quantity * p.Price ) as TotalRevenue from Sales as s
join Products as p
on s.ProductID=p.ProductID
where MONTH(s.SaleDate) = MONTH(Getdate()) and YEAR(s.SaleDate) = YEAR(Getdate())
group by s.ProductID;
select * from #MonthlySales


--Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
--Return: ProductID, ProductName, Category, TotalQuantitySold
create view vw_ProductSalesSummary as 
select p.ProductID, p.ProductName, p.Category, sum(s.Quantity) as TotalQuantitySold from Products as p
join Sales as s
on s.ProductID=p.ProductID
group by p.ProductID, p.ProductName, p.Category
select * from vw_ProductSalesSummary


--Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
--Return: total revenue for the given product ID
create function fn_GetTotalrevenueForProduct (@ProductID int) 
returns decimal (18,2)
as begin
declare @TotalRevenue decimal (18,2)
select @TotalRevenue = sum(s.Quantity * p.Price)
from Sales as s
join Products as p
on p.ProductID = s.ProductID
where s.ProductID = @ProductID
return isnull (@TotalRevenue, 0)
end;


--Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
--Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.

create function fn_GetSalesByCategory (@Category varchar(50))
returns table
as return
(select p.ProductName, sum(s.Quantity) as TotalQuantity,
sum(s.Quantity * p.Price) as TotalRevenue
from Products as p
join Sales as s
on p.ProductID = s.ProductID
where p.Category = @Category
group by p.ProductName);
select* from fn_GetSalesByCategory


--You have to create a function that get one argument as input from user and the function should return 'Yes' if the input number is a prime number and 'No' otherwise. You can start it like this: Create function dbo.fn\_IsPrime (@Number INT)
--Returns ... This is for those who has no idea about prime numbers: A prime number is a number greater than 1 that has only two divisors: 1 and itself(2, 3, 5, 7 and so on).


CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime BIT = 1;

    -- Prime numbers must be greater than 1
    IF @Number <= 1
        RETURN 'No';

    -- Only need to check divisors up to the square root of the number
    WHILE @i * @i <= @Number
    BEGIN
        IF @Number % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END

    IF @IsPrime = 1
        RETURN 'Yes';
    ELSE
        RETURN 'No';
END;

SELECT dbo.fn_IsPrime(7);  -- Output: Yes
SELECT dbo.fn_IsPrime(10); -- Output: No


-- Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:
--@Start INT
--@End INT
--The function should return a table with a single column:

--| Number |
--|--------|
--| @Start |
--...
--...
--...
--|   @end |
--It should include all integer values from @Start to @End, inclusive.

CREATE FUNCTION dbo.fn_GetNumbersBetween
(
    @Start INT,
    @End INT
)
RETURNS @Result TABLE
(
    Number INT
)
AS
BEGIN
    DECLARE @Current INT = @Start;

    WHILE @Current <= @End
    BEGIN
        INSERT INTO @Result (Number)
        VALUES (@Current);

        SET @Current = @Current + 1;
    END

    RETURN;
END;
SELECT * FROM dbo.fn_GetNumbersBetween(5, 10);


--Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct salaries, return NULL.
SELECT
    (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        OFFSET @N - 1 ROWS FETCH NEXT 1 ROWS ONLY
    ) AS getNthHighestSalary


--	Write a SQL query to find the person who has the most friends.
--Return: Their id, The total number of friends they have

--Friendship is mutual. For example, if user A sends a request to user B and it's accepted, both A and B are considered friends with each other. The test case is guaranteed to have only one user with the most friends.

	SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY num DESC;



--Create a View for Customer Order Summary.

CREATE VIEW vw_CustomerOrderSummary AS
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM
    Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name;


	--Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.
	select RowNumber,(select max(testCase) from gaps as g2 where g2.RowNumber <= g1.RowNumber) as result from gaps as g1 
