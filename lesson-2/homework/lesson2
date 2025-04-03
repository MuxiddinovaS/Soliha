--Create a table Employees with columns:
--EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).
create table Employees(
EmpID int,
Name varchar(50),
Salary decimal(10, 2)
)
--Insert three records into the Employees table using different INSERT INTO approaches 
--(single-row insert and multiple-row insert).
Insert into Employees (EmpID, Name, Salary) values
(2, 'Soliha', 1000000),
(1, 'Xanifa', 100000), 
(3, 'Kamilla', 100000),
(4, 'Iman', 100000)
select * from Employees;
--Update the Salary of an employee where EmpID = 1.
update Employees set Name= 'Soliha' where EmpID = 1
--Delete a record from the Employees table where EmpID = 2.
delete from Employees where EmpId = 2; 
--Demonstrate the difference between DELETE, TRUNCATE, and DROP commands on a test table.
drop table employees;
truncate table employees;
--Demonstrate the difference between DELETE, TRUNCATE, and DROP commands on a test table.
alter table Employees
alter column Name varchar(100);
--Add a new column Department (VARCHAR(50)) to the Employees table.
alter table Employees
add Department varchar(50);
--Change the data type of the Salary column to FLOAT.
alter table Employees
alter column Salary float;
--Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
create table Departments(
DepartmentID int,
DepartmentName varchar(50)
)
select* from Departments
--Remove all records from the Employees table without deleting its structure.
delete from Employees;
--Insert five records into the Departments table using INSERT INTO SELECT from an existing table.
INSERT INTO Departments (DepartmentID, DepartmentName)
 select EmpID, Name 
FROM Employees
where EmpID>2;
--Update the Department of all employees where Salary > 5000 to 'Management'.
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;
select * from Employees
--Write a query that removes all employees but keeps the table structure intact.
truncate table Employees
--Drop the Department column from the Employees table.
alter table Employees drop column Department;
select * from Employees;
--Rename the Employees table to StaffMembers using SQL commands.
EXEC sp_rename 'Employees', 'StaffMembers';
select * from StaffMembers;
--Write a query to completely remove the Departments table from the database.
Drop table Departments;
--Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
create table Products(
ProductID int,
ProductName varchar(50),
Category varchar(50),
Price decimal(10, 2) not null,
StockQuantity INT NOT NULL DEFAULT 0,
--Add a CHECK constraint to ensure Price is always greater than 0.
    CONSTRAINT CHK_Price CHECK (Price > 0)
)
select * from Products;
--Modify the table to add a StockQuantity column with a DEFAULT value of 50.
ALTER TABLE Products 
ADD StockQuantity INT NOT NULL DEFAULT 50;
--Rename Category to ProductCategory
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';
--Insert 5 records into the Products table using standard INSERT INTO queries.
INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES
(1, 'Laptop', 'Electronics', 899.99, 50),
(2, 'Smartphone', 'Electronics', 499.99, 100),
(3, 'Desk Chair', 'Furniture', 129.99, 30),
(4, 'Coffee Maker', 'Appliances', 79.99, 20),
(5, 'Headphones', 'Electronics', 59.99, 150);
--Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
SELECT * INTO Products_Backup
FROM Products;
--Rename the Products table to Inventory.
exec sp_rename 'Products', 'Inventory';
--Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;
--Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5.
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);
select * from Inventory;
