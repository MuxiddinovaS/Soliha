--Find customers who purchased at least one item in March 2024 using EXISTS
select * from #Sales as s
where exists(select 1 from #Sales as sl where s.CustomerName = sl.CustomerName 
and sl.SaleDate>= '2024-03-01'
and s.SaleDate < '2024-04-01')


--Find the product with the highest total sales revenue using a subquery.
SELECT Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) AS RevenueSubquery
);



--Find the second highest sale amount using a subquery
SELECT MAX(Quantity * Price) AS SecondHighestSale
FROM #Sales
WHERE Quantity * Price < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);




--Find the total quantity of products sold per month using a subquery
SELECT DISTINCT
    FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
    (
        SELECT SUM(Quantity)
        FROM #Sales AS s2
        WHERE FORMAT(s2.SaleDate, 'yyyy-MM') = FORMAT(s1.SaleDate, 'yyyy-MM')
    ) AS TotalQuantity
FROM #Sales AS s1
ORDER BY SaleMonth;


--Find customers who bought same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.Product = s2.Product
      AND s1.CustomerName <> s2.CustomerName
);



--Return how many fruits does each person have in individual fruit level
SELECT Name, 
       ISNULL([Apple], 0) AS Apple,
       ISNULL([Orange], 0) AS Orange,
       ISNULL([Banana], 0) AS Banana
FROM (
    SELECT Name, Fruit
    FROM Fruits
) AS SourceTable
PIVOT (
    COUNT(Fruit)
    FOR Fruit IN ([Apple], [Orange], [Banana])
) AS PivotTable;



--Return older people in the family with younger ones
WITH Ancestor AS (
    SELECT ParentId, ChildID
    FROM Family
    UNION ALL
    SELECT a.ParentId, f.ChildID
    FROM Ancestor a
    JOIN Family f ON a.ChildID = f.ParentId
)
SELECT *
FROM Ancestor
ORDER BY ParentId, ChildID;



--Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas

SELECT *
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND o.CustomerID IN (
      SELECT DISTINCT CustomerID
      FROM #Orders
      WHERE DeliveryState = 'CA'
  );




  --Insert the names of residents if they are missing
  UPDATE #residents
SET address = address + ' name=' + fullname
WHERE address NOT LIKE '%name=%';
select * from #residents;


--Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
with bekat1 as(
select * from #Routes 
where DepartureCity = 'Tashkent'),
destination as(
select concat(bekat1.DepartureCity,'-',bekat1.ArrivalCity,'-',bekat2.ArrivalCity,'-',bekat3.ArrivalCity,'-',bekat4.ArrivalCity) as route,
    bekat1.cost + bekat2.Cost + isnull(bekat3.Cost,0) + isnull(bekat4.Cost,0) as cost from bekat1
  
join #Routes as bekat2 on bekat1.ArrivalCity = bekat2.DepartureCity
left join #Routes as bekat3 on bekat2.ArrivalCity = bekat3.DepartureCity
left join #Routes as bekat4 on bekat3.ArrivalCity = bekat4.DepartureCity )

select * from destination
where cost in (select min(cost) from destination) or cost in (select max(cost) from destination)


--Rank products based on their order of insertion.
WITH ProductRanks AS (
    SELECT *,
           SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
               OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS grp
    FROM #RankingPuzzle
)
SELECT ID, Vals,
       CASE 
           WHEN Vals = 'Product' THEN NULL
           ELSE grp
       END AS ProductRank
FROM ProductRanks
ORDER BY ID;



--Find employees whose sales were higher than the average sales in their department
SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    SalesAmount,
    SalesMonth,
    SalesYear
FROM (
    SELECT *,
           AVG(SalesAmount) OVER (PARTITION BY Department) AS DeptAvg
    FROM #EmployeeSales
) AS Ranked
WHERE SalesAmount > DeptAvg
ORDER BY Department, SalesAmount DESC;








--Find employees who had the highest sales in any given month using EXISTS
SELECT e1.EmployeeID, e1.EmployeeName, e1.Department, e1.SalesAmount, e1.SalesMonth, e1.SalesYear
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE 
        e2.SalesMonth = e1.SalesMonth
        AND e2.SalesYear = e1.SalesYear
        AND e2.SalesAmount > e1.SalesAmount
)
ORDER BY e1.SalesYear, e1.SalesMonth;




--Find employees who made sales in every month using NOT EXISTS
SELECT DISTINCT e1.EmployeeID, e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e2
        WHERE 
            e2.EmployeeID = e1.EmployeeID
            AND e2.SalesMonth = m.SalesMonth
            AND e2.SalesYear = m.SalesYear
    )
)




--Retrieve the names of products that are more expensive than the average price of all products.
SELECT Name
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);




--Find the products that have a stock count lower than the highest stock count.
SELECT Name, Stock
FROM Products
WHERE Stock < (
    SELECT MAX(Stock)
    FROM Products
);



--Get the names of products that belong to the same category as 'Laptop'.
select Name,Category from Products
where Category = (select Category from Products where Name ='Laptop')


--Retrieve products whose price is greater than the lowest price in the Electronics category.
select Name, Price, Category from Products
where Price > (select min(Price), Category from Products where Category = 'Electronics')


--Find the products that have a higher price than the average price of their respective category.
select Name, Price, Category from Products as p
where Price > (select avg(Price), Category from Products where p.Category = Category)



--Find the products that have been ordered at least once.
SELECT ProductID, Name
FROM Products P
WHERE EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.ProductID = P.ProductID
);



--Retrieve the names of products that have been ordered more than the average quantity ordered.
SELECT P.Name, SUM(O.Quantity) AS TotalQuantity
FROM Orders O
JOIN Products P ON O.ProductID = P.ProductID
GROUP BY P.ProductID, P.Name
HAVING SUM(O.Quantity) > (
    SELECT AVG(TotalQty)
    FROM (
        SELECT SUM(Quantity) AS TotalQty
        FROM Orders
        GROUP BY ProductID
    ) AS Sub
);


--Find the products that have never been ordered.
SELECT ProductID, Name
FROM Products P
WHERE not EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.ProductID = P.ProductID
);


--Retrieve the product with the highest total quantity ordered.
SELECT TOP 1
    P.Name,
    SUM(O.Quantity) AS TotalQuantity
FROM Orders O
JOIN Products P ON O.ProductID = P.ProductID
GROUP BY P.ProductID, P.Name
ORDER BY TotalQuantity DESC;
