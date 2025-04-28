--Return: OrderID, CustomerName, OrderDate
--Task: Show all orders placed after 2022 along with the names of the customers who placed them.
--Tables Used: Orders, Customers
select O.OrderID, C.FirstName, O.OrderDate from Orders as O
inner join Customers as C
on C.CustomerID = O.CustomerID
where YEAR(O.OrderDate) > 2022
--Return: EmployeeName, DepartmentName
--Task: Display the names of employees who work in either the Sales or Marketing department.
--Tables Used: Employees, Departments
select E.Name, D.DepartmentName from Employees as E
inner join Departments as D
on D.DepartmentID = E.DepartmentID
where D.DepartmentName in ('Sales', 'Marketing')
--Return: DepartmentName, TopEmployeeName, MaxSalary
--Task: For each department, show the name of the employee who earns the highest salary.
--Tables Used: Departments, Employees (as a derived table)
SELECT 
    d.DepartmentName,
    e.Name,
    e.Salary
FROM 
    Departments d
JOIN (
    SELECT 
        DepartmentID,
        Name,
        Salary
    FROM 
        Employees e1
    WHERE 
        Salary = (
            SELECT MAX(e2.Salary)
            FROM Employees e2
            WHERE e2.DepartmentID= e1.DepartmentID
        )
) e ON d.DepartmentID = e.DepartmentID;

--Return: CustomerName, OrderID, OrderDate
--Task: List all customers from the USA who placed orders in the year 2023.
--Tables Used: Customers, Orders
select C.FirstName, O.OrderID, O.OrderDate from Customers as C
inner join Orders as O
on C.CustomerID = O.CustomerID
where YEAR(O.OrderDate) = 2023 and C.Country = 'USA'
--Return: CustomerName, TotalOrders
--Task: Show how many orders each customer has placed.
--Tables Used: Orders (as a derived table), Customers
select C.FirstName, O.OrderCount from Customers as C
left join( select CustomerID, count (*) as OrderCount from Orders group by CustomerID) O on C.CustomerID = O.CustomerID
--Return: ProductName, SupplierName
--Task: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.
--Tables Used: Products, Suppliers
select P.ProductName, S.SupplierName from Products as P
inner join Suppliers as S
on P.ProductID = S.SupplierID
where S.SupplierName in ('Gadget Supplies', 'Clothing Mart')
--Return: CustomerName, MostRecentOrderDate, OrderID
--Task: For each customer, show their most recent order. Include customers who haven't placed any orders.
--Tables Used: Customers, Orders (as a derived table)
SELECT 
    c.FirstName,
    o.most_recent_order_date,
    o.OrderID
FROM 
    Customers c
LEFT JOIN (
    SELECT 
        o1.CustomerID,
        o1.OrderID,
        o1.OrderDate AS most_recent_order_date
    FROM 
        Orders o1
    WHERE 
        o1.OrderDate = (
            SELECT MAX(o2.OrderDate)
            FROM Orders o2
            WHERE o2.CustomerID= o1.CustomerID
        )
) o ON c.CustomerID = o.CustomerID;

--Return: CustomerName, OrderID, OrderTotal
--Task: Show the customers who have placed an order where the total amount is greater than 500.
--Tables Used: Orders, Customers
select C.FirstName, O.OrderID, O.TotalAmount from Customers as C
inner join Orders as O
on C.CustomerID = O.CustomerID
where O.TotalAmount > 500
--Return: ProductName, SaleDate, SaleAmount
--Task: List product sales where the sale was made in 2022 or the sale amount exceeded 400.
--Tables Used: Products, Sales
 select P.ProductName, S.SaleDate, S.SaleAmount from Products as P
 inner join Sales as S
 on P.ProductID = S.ProductID
 where YEAR (S.SaleDate) = 2022 or S.SaleAmount > 400
--Return: ProductName, TotalSalesAmount
--Task: Display each product along with the total amount it has been sold for.
--Tables Used: Sales (as a derived table), Products
SELECT 
    p.ProductName,
    COALESCE(s.total_sales_amount, 0) AS total_sales_amount
FROM 
    Products p
LEFT JOIN (
    SELECT 
        ProductID,
        SUM(SaleAmount * SaleID) AS total_sales_amount
    FROM  
        Sales
    GROUP BY 
        ProductID
) s ON p.ProductID = s.ProductID;

--Return: EmployeeName, DepartmentName, Salary
--Task: Show the employees who work in the HR department and earn a salary greater than 50000.
--Tables Used: Employees, Departments
select E.Name, D.DepartmentName, E.Salary  from Employees as E
join Departments as D
on E.DepartmentID = D.DepartmentID
where D.DepartmentName = 'Human Resources' and E.Salary > 50000
--Return: ProductName, SaleDate, StockQuantity
--Task: List the products that were sold in 2023 and had more than 50 units in stock at the time.
--Tables Used: Products, Sales
select P.ProductName,S.SaleDate, P.StockQuantity from Products as P
inner join Sales as S
on P.ProductID = S.ProductID
where YEAR(S.SaleDate) = 2023 and P.StockQuantity > 50
--Return: EmployeeName, DepartmentName, HireDate
--Task: Show employees who either work in the Sales department or were hired after 2020.
--Tables Used: Employees, Departments
select E.Name, D.DepartmentName, E.HireDate from Employees as E
inner join Departments as D
on E.DepartmentID = D.DepartmentID
where D.DepartmentName = 'Sales' or E.HireDate > '2020-12-31';



--Return: CustomerName, OrderID, Address, OrderDate
--Task: List all orders made by customers in the USA whose address starts with 4 digits.
--Tables Used: Customers, Orders
select C.FirstName, O.OrderID, C.Address, O.OrderDate from Customers as C
inner join Orders as O
on C.CustomerID = O.CustomerID
where C.Country = 'USA' and C.Address like '____%';
--Return: ProductName, Category, SaleAmount
--Task: Display product sales for items in the Electronics category or where the sale amount exceeded 350.
--Tables Used: Products, Sales
select P.ProductName, P.Category, S.SaleAmount from Products as P
inner join Sales as S
on P.ProductID = S.ProductID
where P.Category = 'Electronics' or S.SaleAmount > 350
--Return: CategoryName, ProductCount
--Task: Show the number of products available in each category.
--Tables Used: Products (as a derived table), Categories
SELECT C.CategoryName, P.ProductCount
FROM Categories C
JOIN (               
    SELECT CategoryID , COUNT(*) AS ProductCount
    FROM Products
    GROUP BY CategoryID
) P ON C.CategoryID = P.CategoryID;

--Return: CustomerName, City, OrderID, Amount
--Task: List orders where the customer is from Los Angeles and the order amount is greater than 300.
--Tables Used: Customers, Orders
select C.FirstName, C.City, O.OrderID, O.TotalAmount from Customers as C
inner join Orders as O
on O.CustomerID = C.CustomerID
where C.City = 'Los Angeles' and O.TotalAmount > 300
--Return: EmployeeName, DepartmentName
--Task: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
--Tables Used: Employees, Departments
SELECT E.Name, D.DepartmentName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('HR', 'Finance')
   OR LEN(E.Name) - LEN(TRANSLATE(LOWER(E.Name), 'aeiou', '')) >= 4;

--Return: ProductName, QuantitySold, Price
--Task: List products that had a sales quantity above 100 and a price above 500.
--Tables Used: Sales, Products
select P.ProductName, S.SaleAmount, P.Price from Products as P
inner join Sales as S
on P.ProductID = S.ProductID
where S.SaleAmount > 100 and P.Price > 500
--Return: EmployeeName, DepartmentName, Salary
--Task: Show employees who are in the Sales or Marketing department and have a salary above 60000.
--Tables Used: Employees, Departments
select E.Name, D.DepartmentName, E.Salary from Employees as E
inner join Departments as D
on E.DepartmentID = D.DepartmentID
where D.DepartmentName in ('Sales', 'Marketing') and E.Salary > 60000
