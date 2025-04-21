--Using Products, Suppliers table List all combinations of product names and supplier names.
SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
CROSS JOIN Suppliers;
--Using Departments, Employees table Get all combinations of departments and employees.
select Departments.Departmentname, Employees.FirstName
from Departments
cross join Employees
--Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. Return supplier name and product name
select Suppliers.SupplierName, Products.ProductName
from Products
inner join Suppliers
on Products.ProductID = Suppliers.SupplierID
--Using Orders, Customers table List customer names and their orders ID.
select Orders.CustomerID , Customers.FirstName
from Orders
inner join Customers
on Orders.CustomerID = Customers.CustomerID
--Using Courses, Students table Get all combinations of students and courses.
select Courses.CourseName, Students.Name
from Students
cross join Courses
--Using Products, Orders table Get product names and orders where product IDs match.
select Products.ProductName, Orders.OrderID
from Products
inner join Orders
on Products.ProductID=Orders.OrderID
--Using Departments, Employees table List employees whose DepartmentID matches the department.
select Departments.DepartmentName, Employees.FirstName
from Employees
inner join Departments
on Departments.DepartmentName = Employees.DepartmentName
--Using Students, Enrollments table List student names and their enrolled course IDs.
select Students.Name , Enrollments.CourseID
from Students
inner join Enrollments
on Students.StudentID=Enrollments.StudentID
--Using Payments, Orders table List all orders that have matching payments.
SELECT Orders.OrderID, Payments.PaymentID, Payments.Amount
FROM Orders
INNER JOIN Payments ON Orders.OrderID = Payments.OrderID;
--Using Orders, Products table Show orders where product price is more than 100.
select Orders.ProductID, Products.ProductName,Products.Price
from Orders
inner join Products
on Orders.ProductID = Products.ProductID
where Products.Price > 100 


--Using Employees, Departments table List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.
SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
JOIN Departments ON Employees.DepartmentID <> Departments.DepartmentID;
--Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.
select Orders.Quantity, Products.StockQuantity
from Orders
inner join Products
on Orders.Quantity > Products.StockQuantity
--Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.
Select Customers.FirstName, Sales.ProductID, Sales.SaleAmount
from Sales
inner join Customers
on Customers.CustomerID = Sales.CustomerID
where Sales.SaleAmount >=500
--Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.
SELECT Students.Name, Courses.CourseName
FROM Enrollments
INNER JOIN Students
ON Enrollments.StudentID = Students.StudentID
INNER JOIN Courses 
ON Enrollments.CourseID = Courses.CourseID;

--Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.
select Products.ProductName, Suppliers.SupplierName
from  Products
inner join Suppliers
on Products.ProductID = Suppliers.SupplierID
where Suppliers.SupplierName like '%Tech%';
--Using Orders, Payments table Show orders where payment amount is less than total amount.
select Orders.TotalAmount, payments.payment_amount
from Orders
inner join payments
on Orders.CustomerID = payments.payerid
where Orders.TotalAmount > payments.payment_amount;
--Using Employees table List employee names with salaries greater than their manager’s salary.
SELECT E.FirstName, E.Salary, M.FirstName AS ManagerName, M.Salary AS ManagerSalary
FROM Employees E
INNER JOIN Employees M ON E.EmployeeID = M.EmployeeID
WHERE E.Salary > M.Salary;
--Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.
select Products.Category , Categories.CategoryName
from Products
inner join Categories
on Products.ProductID = Categories.CategoryID
where Categories.CategoryName in ('Electronics', 'Furniture');
--Using Sales, Customers table Show all sales from customers who are from 'USA'.
select Sales.SaleAmount, Customers.Country
from Sales
inner join Customers
on Sales.CustomerID = Customers.CustomerID
where Customers.Country = 'USA'
--Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.
select Orders.TotalAmount, Customers.Country, Orders.OrderID,Customers.CustomerID
from Orders
inner join Customers
on Orders.CustomerID = Customers.CustomerID
where Customers.Country = 'Germany' and Orders.TotalAmount > 100

 


-- Using Employees table List all pairs of employees from different departments.
SELECT E1.EmployeeName AS Employee1, E2.EmployeeName AS Employee2,
       E1.DepartmentID AS Dept1, E2.DepartmentID AS Dept2
FROM Employees E1
JOIN Employees E2 ON E1.EmployeeID < E2.EmployeeID
WHERE E1.DepartmentID <> E2.DepartmentID;

--Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).
SELECT Payments.PaymentID, Orders.OrderID, Products.ProductName, 
       Orders.Quantity, Products.Price, Payments.Amount AS PaidAmount,
       (Orders.Quantity * Products.Price) AS ExpectedAmount
FROM Payments
INNER JOIN Orders ON Payments.OrderID = Orders.OrderID
INNER JOIN Products ON Orders.ProductID = Products.ProductID
WHERE Payments.Amount <> (Orders.Quantity * Products.Price);

--Using Students, Enrollments, Courses table Find students who are not enrolled in any course.
SELECT Students.Name
FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
WHERE Enrollments.CourseID IS NULL;

--Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.
SELECT M.EmployeeName AS ManagerName, M.Salary AS ManagerSalary,
       E.EmployeeName AS EmployeeName, E.Salary AS EmployeeSalary
FROM Employees E
INNER JOIN Employees M ON E.ManagerID = M.EmployeeID
WHERE M.Salary <= E.Salary;

--Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.
SELECT DISTINCT Customers.CustomerID, Customers.CustomerName, Orders.OrderID
FROM Orders
LEFT JOIN Payments ON Orders.OrderID = Payments.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Payments.PaymentID IS NULL;
