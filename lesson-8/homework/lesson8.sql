--Using Products table, find the total number of products available in each category.
select Category , count (*) as Totalproducts
from Products
group by Category;
--Using Products table, get the average price of products in the 'Electronics' category.
select avg(Price) as AveragePrice
from Products
where Category= 'Electronics';
--Using Customers table, list all customers from cities that start with 'L'.
select * from Customers
where City like 'L%';
--Using Products table, get all product names that end with 'er'.
select * from Products
where ProductName like '%er';
--Using Customers table, list all customers from countries ending in 'A'.
select * from Customers
where Country like '%A';
--Using Products table, show the highest price among all products.
select max(Price) as HighestPrice
from Products;

--Using Products table, use IIF to label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.
select* from Products
select ProductName, StockQuantity,
iif (StockQuantity>30, 'Low Stock', 'Sufficient') as stockstatus
from Products;
--Using Customers table, find the total number of customers in each country.
select Country, sum(CustomerID) as TotalCustomers
from Customers
group by Country;
--Using Orders table, find the minimum and maximum quantity ordered.
select
min(Quantity) as Min_quantity,
max(Quantity) as Max_quantity
from Orders;


--Using Orders and Invoices tables, list customer IDs who placed orders in 2023 (using EXCEPT) to find those who did not have invoices.
select distinct CustomerID 
from Orders 
where YEAR(OrderDate) = 2023
except
select distinct CustomerID
from Invoices
--Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted including duplicates.
select ProductName from Products
union all
select ProductName from Products_Discounted;
--Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted without duplicates.
select ProductName from Products
union
select ProductName from Products_Discounted;
--Using Orders table, find the average order amount by year.
select YEAR(OrderDate) as year_ordered, avg(TotalAmount) as averageamount
from Orders
group by Year(OrderDate);

--Using Products table, use CASE to group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return productname and pricegroup.
select ProductName,
case 
when Price < 100 then 'Low'
when Price between 100 and 500 then 'Mid'
when Price > 500 then 'High'
else 'Uknown'
end as PriceGroup
from Products;
--Using Customers table, list all unique cities where customers live, sorted alphabetically.
select distinct City
from Customers
order by City;
--Using Sales table, find total sales per product Id.
select ProductID, sum(SaleAmount) as total_sales 
from Sales
group by ProductID
--Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.
select ProductName
from Products
where ProductName like '%oo%';
--Using Products and Products_Discounted tables, compare product IDs using INTERSECT.
select ProductID from Products
intersect
select ProductID from Products_Discounted;


--Using Invoices table, show top 3 customers with the highest total invoice amount. Return CustomerID and Totalspent.
select * from Invoices
select CustomerID, sum(TotalAmount) as TotalSpent
from Invoices
group by CustomerID
order by CustomerID desc;

--Find product ID and productname that are present in Products but not in Products_Discounted.
SELECT ProductID, ProductName
FROM Products
WHERE ProductID NOT IN (SELECT ProductID FROM Products_Discounted);

--Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)
SELECT p.ProductName, COUNT(s.SaleID) AS TimesSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName
ORDER BY TimesSold DESC;
--Using Orders table, find top 5 products (by ProductID) with the highest order quantities.
SELECT ProductID, SUM(Quantity) AS TotalQuantity
FROM Orders
GROUP BY ProductID
ORDER BY TotalQuantity DESC;

