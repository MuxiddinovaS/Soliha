--Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.
--🔁 Expected Output: EmployeeName, Salary, DepartmentName
select E.FirstName, E.Salary, D.DepartmentName from Employees as E
inner join Departments as D
on D.DepartmentName = E.DepartmentName
where E.Salary > 50000
--Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
--🔁 Expected Output: FirstName, LastName, OrderDate
select * from Customers
select * from Orders
select C.FirstName, C.LastName, O.OrderDate from Customers as C
inner join Orders as O
on C.CustomerID = O.CustomerID
where YEAR(O.OrderDate) = 2023
--Using the Employees and Departments tables, write a query to show all employees along with their department names. Include employees who do not belong to any department.
--🔁 Expected Output: EmployeeName, DepartmentName
--(Hint: Use a LEFT OUTER JOIN)
select * from Employees
select * from Departments
select E.FirstName, E.DepartmentName from Employees as E
left join Departments as D
on D.DepartmentName = E.DepartmentName;
--Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.
--🔁 Expected Output: SupplierName, ProductName
select * from Products
select * from Suppliers
select S.SupplierName, P.ProductName from Suppliers as S
full join Products as P
on P.ProductID = S.SupplierID;
--Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.
--🔁 Expected Output: OrderID, OrderDate, PaymentDate, Amount
select * from Orders
select * from payments
select O.OrderID, O.OrderDate, P.payment_date, P.payment_amount from Orders as O
full join payments as P
on P.payerid = O.CustomerID;
--Using the Employees table, write a query to show each employee's name along with the name of their manager.
--🔁 Expected Output: EmployeeName, ManagerName
SELECT 
    E.Name AS EmployeeName,
    M.Name AS Managername
FROM 
    Employees E
left JOIN 
    Employees M ON E.ManagerID = M.EmployeeID;
--Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
--🔁 Expected Output: StudentName, CourseName
select S.Name from Students as S
join Enrollments as E
on S.StudentID = E.StudentID
join Courses as C
on C.CourseID = E.CourseID
where C.CourseName = 'Math101';
--Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
--🔁 Expected Output: FirstName, LastName, Quantity
select C.FirstName, C.LastName, O.Quantity from Customers as C
inner join Orders as O
on C.CustomerID = O.CustomerID
where O.Quantity > 3;
--Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
--🔁 Expected Output: EmployeeName, DepartmentName
select E.Name, D.DepartmentName from Employees as E
inner join Departments as D
on D.DepartmentID = E.DepartmentID
where D.DepartmentName = 'Human Resources';



--Using the Employees and Departments tables, write a query to return department names that have more than 10 employees.
--🔁 Expected Output: DepartmentName, EmployeeCount
SELECT 
    Departments.DepartmentName,
    COUNT(Employees.EmployeeID) AS EmployeeCount
FROM 
    Departments
JOIN 
    Employees ON Departments.DepartmentID = Employees.DepartmentID
GROUP BY 
    Departments.DepartmentName

--Using the Products and Sales tables, write a query to find products that have never been sold.
--🔁 Expected Output: ProductID, ProductName
select S.ProductID, P.ProductName from Products as P
left join Sales as S
on P.ProductID = S.ProductID
where S.ProductID is null;

--Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
--🔁 Expected Output: FirstName, LastName, TotalOrders
select C.FirstName, C.LastName, O.Quantity from Customers as C
left join Orders as O
on C.CustomerID = O.CustomerID
where O.OrderID > 1
--Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
--🔁 Expected Output: EmployeeName, DepartmentName
SELECT 
    Employees.Name,
    Departments.DepartmentName
FROM 
    Employees
INNER JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID;
--Using the Employees table, write a query to find pairs of employees who report to the same manager.
--🔁 Expected Output: Employee1, Employee2, ManagerID
SELECT 
    E1.Name AS Employee1,
    E2.Name AS Employee2,
    E1.ManagerID
FROM 
    Employees E1
JOIN 
    Employees E2 ON E1.ManagerID = E2.ManagerID
WHERE 
    E1.EmployeeID < E2.EmployeeID;

--Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
--🔁 Expected Output: OrderID, OrderDate, FirstName, LastName
select O.OrderID, O.OrderDate, C.FirstName, C.LastName from Orders as O
inner join Customers as C
on O.CustomerID = C.CustomerID
where YEAR(O.OrderDate) = 2022
--Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
--🔁 Expected Output: EmployeeName, Salary, DepartmentName
select E.Name, E.Salary, D.DepartmentName from Employees as E
left join Departments as D
on E.DepartmentID = D.DepartmentID
where D.DepartmentName = 'Sales' and E.Salary > 60000;

--Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
--🔁 Expected Output: OrderID, OrderDate, PaymentDate, Amount
select O.OrderID, O.OrderDate, P.payment_date, P.payment_amount from Orders as O
inner join payments as P
on O.CustomerID = P.payerid;

--Using the Products and Orders tables, write a query to find products that were never ordered.
--🔁 Expected Output: ProductID, ProductName
select P.ProductID, P.ProductName from Products as P
left join Orders as O
on P.ProductID = O.ProductID
where O.OrderID is null


--Using the Employees table, write a query to find employees whose salary is greater than the average salary of all employees.
--🔁 Expected Output: EmployeeName, Salary
SELECT 
    Name,
    Salary
FROM 
    Employees
WHERE 
    Salary > (SELECT AVG(Salary) FROM Employees);

--Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
--🔁 Expected Output: OrderID, OrderDate
select O.OrderID, O.OrderDate from  Orders as O
left join payments as P
on O.OrderID = P.payerid
where O.OrderDate < 2020-01-01 and P.payerid is null
--Using the Products and Categories tables, write a query to return products that do not have a matching category.
--🔁 Expected Output: ProductID, ProductName
SELECT 
    Products.ProductID,
    Products.ProductName
FROM 
    Products
LEFT JOIN 
    Categories ON Products.ProductID= Categories.CategoryID
WHERE 
    Categories.CategoryID IS NULL;

--Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
--🔁 Expected Output: Employee1, Employee2, ManagerID, Salary
select E1.Name as Employee1,
E2.Name as Employee2 ,
E1.Salary,
E2.ManagerID 
from Employees E1
inner join Employees E2
on E1.ManagerID = E2.ManagerID
where E1.EmployeeID <> E2.EmployeeID
and E1.Salary > 60000
and E2.Salary > 60000
--Using the Employees and Departments tables, write a query to return employees who work in departments whose name starts with the letter 'M'.
--🔁 Expected Output: EmployeeName, DepartmentName
select E.Name, D.DepartmentName from Employees as E
left join Departments as D
on E.DepartmentID = D.DepartmentID
where D.DepartmentName like 'M%';
--Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
--🔁 Expected Output: SaleID, ProductName, SaleAmount
select S.SaleID, P.ProductID, P.ProductName, S.SaleAmount from Products as P
inner join Sales as S
on S.ProductID = P.ProductID
where S.SaleAmount > 500;
--Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
--🔁 Expected Output: StudentID, StudentName
SELECT S.StudentID, S.Name FROM Students as S
LEFT JOIN Enrollments as E
ON S.StudentID = E.StudentID
LEFT JOIN Courses as C
ON E.CourseID = C.CourseID
WHERE 
    C.CourseName = 'Math 101' OR C.CourseName IS NULL;

--Using the Orders and Payments tables, write a query to return orders that are missing payment details.
--🔁 Expected Output: OrderID, OrderDate, PaymentID
SELECT 
    Orders.OrderID,
    Orders.OrderDate
	Payment.PaymentID
FROM 
    Orders
LEFT JOIN 
    Payments ON Orders.OrderID = Payments.OrderID
WHERE 
    Payments.OrderID IS NULL;

--Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
--🔁 Expected Output: ProductID, ProductName, CategoryName
SELECT 
    Products.ProductID,
    Products.ProductName,
    Categories.CategoryName
FROM 
    Products
JOIN 
    Categories ON Products.Category = Categories.CategoryName
WHERE 
    Categories.CategoryName IN ('Electronics', 'Furniture');
