--Write a query to find the minimum (MIN) price of a product in the Products table.
select min(Price) from Products;
--Write a query to find the maximum (MAX) Salary from the Employees table.
select max(Salary) from Employees;
--Write a query to count the number of rows in the Customers table using COUNT(*).
select  COUNT(*) from Customers
--Write a query to count the number of unique product categories (COUNT(DISTINCT Category)) from the Products table.
select (COUNT(DISTINCT Category)) from Products
--Write a query to find the total (SUM) sales amount for the product with id 7 in the Sales table.
select sum(SaleID) from Sales
--Write a query to calculate the average (AVG) age of employees in the Employees table.
select avg(Age) from Employees
--Write a query that uses GROUP BY to count the number of employees in each department.
select count(*) EmployeeID from Employees
group by DepartmentName
--Write a query to show the minimum and maximum Price of products grouped by Category. Use products table.
select Category, 
min(Price) as min_price ,
max (Price) as max_price
from Products
group by Category;
--Write a query to calculate the total (SUM) sales per Customer in the Sales table.
select CustomerID, sum(SaleAmount) from Sales 
group by CustomerID
--Write a query to use HAVING to filter departments having more than 5 employees from the Employees table.(DeptID is enough, if you don't have DeptName).
SELECT DepartmentName, 
       COUNT(*) AS employee_count
FROM Employees
GROUP BY DepartmentName
HAVING COUNT(*) > 5;


--Write a query to calculate the total sales and average sales for each product category from the Sales table.
select ProductID,
sum(SaleAmount) as sum_amount,
avg(SaleAmount) as avg_amount 
from Sales
group by ProductID
--Write a query that uses COUNT(columnname) to count the number of employees from the Department HR.
select count (EmployeeID) from Employees
where DepartmentName = 'HR'
--Write a query that finds the highest (MAX) and lowest (MIN) Salary by department in the Employees table.(DeptID is enough, if you don't have DeptName).
select DepartmentName,
min(Salary) as min_salary,
max(Salary) as max_salary
from Employees
group by DepartmentName;
--Write a query that uses GROUP BY to calculate the average salary per Department.(DeptID is enough, if you don't have DeptName).
select DepartmentName,
avg(Salary) as avg_salary
from Employees 
group by DepartmentName
--Write a query to show the AVG salary and COUNT(*) of employees working in each department.(DeptID is enough, if you don't have DeptName).
SELECT DepartmentName, 
       AVG(Salary) AS average_salary, 
       COUNT(*) AS employee_count
FROM Employees
GROUP BY DepartmentName;

--Write a query that uses HAVING to filter product categories with an average price greater than 400.
SELECT category, 
       AVG(price) AS average_price
FROM products
GROUP BY category
HAVING AVG(price) > 400;

--Write a query that calculates the total sales for each year in the Sales table, and use GROUP BY to group them.
SELECT YEAR(sale_date) AS sale_year, 
       SUM(sale_amount) AS total_sales
FROM Sales
GROUP BY YEAR(sale_date);

--Write a query that uses COUNT to show the number of customers who placed at least 3 orders.
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) >= 3
) AS frequent_customers;

--Write a query that applies the HAVING clause to filter out Departments with total salary expenses greater than 500,000.(DeptID is enough, if you don't have DeptName)
SELECT DeptID, 
       SUM(Salary) AS total_salary_expense
FROM Employees
GROUP BY DeptID
HAVING SUM(Salary) > 500000;


--Write a query that shows the average (AVG) sales for each product category, and then uses HAVING to filter categories with an average sales amount greater than 200.
SELECT category, 
       AVG(sale_amount) AS average_sales
FROM Sales
GROUP BY category
HAVING AVG(sale_amount) > 200;

--Write a query to calculate the total (SUM) sales for each Customer, then filter the results using HAVING to include only Customers with total sales over 1500.
SELECT customer_id, 
       SUM(sale_amount) AS total_sales
FROM Sales
GROUP BY customer_id
HAVING SUM(sale_amount) > 1500;

--Write a query to find the total (SUM) and average (AVG) salary of employees grouped by department, and use HAVING to include only departments with an average salary greater than 65000.
SELECT DeptID, 
       SUM(Salary) AS total_salary, 
       AVG(Salary) AS average_salary
FROM Employees
GROUP BY DeptID
HAVING AVG(Salary) > 65000;

--Write a query that finds the maximum (MAX) and minimum (MIN) order value for each customer, and then applies HAVING to exclude customers with an order value less than 50.
SELECT customer_id, 
       MAX(order_value) AS max_order_value, 
       MIN(order_value) AS min_order_value
FROM Orders
GROUP BY customer_id
HAVING MIN(order_value) >= 50;

--Write a query that calculates the total sales (SUM) and counts distinct products sold in each month, and then applies HAVING to filter the months with more than 8 products sold.
SELECT MONTH(sale_date) AS sale_month, 
       SUM(sale_amount) AS total_sales, 
       COUNT(DISTINCT product_id) AS distinct_products_sold
FROM Sales
GROUP BY MONTH(sale_date)
HAVING COUNT(DISTINCT product_id) > 8;

--Write a query to find the MIN and MAX order quantity per Year. From orders table. (Do some research)
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       MIN(order_quantity) AS min_order_quantity,
       MAX(order_quantity) AS max_order_quantity
FROM Orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;
