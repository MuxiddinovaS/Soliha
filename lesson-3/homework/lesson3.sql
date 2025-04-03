--1.Define and explain the purpose of BULK INSERT in SQL Server.
It is a command which imports large volumes of data from a file into a table or view.
--2.List four file formats that can be imported into SQL Server.
CSV, TXT, XLSX, JSON
--3.Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
create table Products(
ProductID int,
ProductName varchar(50),
Price decimal (10, 2)
)
--4.Insert three records into the Products table using INSERT INTO.
insert into Products(ProductID, ProductName, Price) values
(1, 'KIXSI', 100),
(2, 'LIVSI', 700),
(3, 'HadaLabo', 120);
--5.Explain the difference between NULL and NOT NULL with examples.
In SQL Server, NULL represents a missing or unknown value, while NOT NULL ensures that a column must always have a value.
CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,  -- Name must have a value
    Email VARCHAR(100) NULL  -- Email can be NULL (optional)
);
INSERT INTO Employees (ID, Name, Email) VALUES (1, 'John Doe', NULL); 
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,  -- Cannot be NULL
    OrderDate DATE NOT NULL  -- Cannot be NULL
);
INSERT INTO Orders (OrderID, CustomerName, OrderDate) VALUES (1, 'Alice', NULL); 
--6.Add a UNIQUE constraint to the ProductName column in the Products table.
alter table Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);
select * from Products
--7.Write a comment in a SQL query explaining its purpose.
--The purpose of writing comments in an SQL query is to improve readability and maintainability by explaining the query’s function. This is especially useful for developers, database administrators, and analysts who need to understand or modify the query later
--8.Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
create table Categories(
CategoryID int primary key,
CategoryName varchar(50) unique
)
--9.Explain the purpose of the IDENTITY column in SQL Server.
The IDENTITY column in SQL Server is used to generate unique, auto-incrementing values for a table column, typically used for primary keys. This helps in automatically assigning a unique value to each new record without manually specifying it.
--10.Use BULK INSERT to import data from a text file into the Products table.
bulk insert [lesson3]. [dbo]. [Products]
from 'C:\Users\user\Downloads\Telegram Desktop\Customers.csv'
--11.Create a FOREIGN KEY in the Products table that references the Categories table.
ALTER TABLE Products
FOREIGN KEY (CategoryID)  
REFERENCES Categories(CategoryID); 
--12.Explain the differences between PRIMARY KEY and UNIQUE KEY with examples.
PRIMARY KEY is used to uniquely identify rows and cannot accept NULL values, while the UNIQUE KEY ensures uniqueness but allows for NULL values and can be applied to multiple columns in a table. Each table can only have one PRIMARY KEY, but it can have multiple UNIQUE KEY constraints.
--13.Add a CHECK constraint to the Products table ensuring Price > 0.
ALTER TABLE Products
ADD CONSTRAINT CK_Price_Positive
CHECK (Price > 0);
select * from Products
--14.Modify the Products table to add a column Stock (INT, NOT NULL).
ALTER TABLE Products
ADD Stock INT NOT NULL;
--15.Use the ISNULL function to replace NULL values in a column with a default value.
SELECT ISNULL(ProductName, Price) AS NewColumnName
FROM Products;
--16.Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
A FOREIGN KEY constraint is used to establish and enforce a link between two tables. It ensures that the values in one table correspond to values in another table, promoting referential integrity. This helps maintain consistency and accuracy across related data in a relational database
--17.Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
Alter table Customers
Add Age int
Add CONSTRAINT CK_Age_Positive,
CHECK (Age >= 18);
select * from Customers
--18.Create a table with an IDENTITY column starting at 100 and incrementing by 10.
CREATE TABLE MyTable (
    ID INT IDENTITY(100, 10) PRIMARY KEY,
    Name VARCHAR(100),
    Age INT
);
select * from MyTable
--19.Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    PRIMARY KEY (OrderID, ProductID)
);
--20.Explain with examples the use of COALESCE and ISNULL functions for handling NULL values.
COALESCE is more flexible, allowing multiple expressions to be evaluated, whereas ISNULL is straightforward and designed for replacing a single NULL value with a specified default. Both functions are essential for ensuring data consistency and handling NULL values effectively in SQL Server queries.
--21.Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
create table Employees(
EmpID int primary key,
Email varchar(50) unique
)
select * from Employees
--22.Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME,
    CustomerID INT
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
