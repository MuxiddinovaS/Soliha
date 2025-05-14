--You must provide a report of all distributors and their sales by region. If a distributor did not have any sales for a region, rovide a zero-dollar value for that day. Assume there is at least one sale for each region

WITH Regions AS (
    SELECT DISTINCT Region FROM #RegionSales
),
Distributors AS (
    SELECT DISTINCT Distributor FROM #RegionSales
),
AllCombinations AS (
    SELECT 
        r.Region,
        d.Distributor
    FROM 
        Regions r
    CROSS JOIN 
        Distributors d
)

-- Step 2: Left join to actual sales and handle missing entries
SELECT 
    ac.Region,
    ac.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM 
    AllCombinations ac
LEFT JOIN 
    #RegionSales rs
    ON ac.Region = rs.Region AND ac.Distributor = rs.Distributor
ORDER BY 
    ac.Distributor, ac.Region;


--Find managers with at least five direct reports

SELECT 
    e.managerId AS ManagerID,
    m.name AS ManagerName,
    COUNT(*) AS DirectReports
FROM 
    Employee e
JOIN 
    Employee m ON e.managerId = m.id
GROUP BY 
    e.managerId, m.name
HAVING 
    COUNT(*) >= 5;


--Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
	SELECT 
    p.product_name,
    SUM(o.unit) AS total_units
FROM 
    Orders o
JOIN 
    Products p ON o.product_id = p.product_id
WHERE 
    o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY 
    p.product_name
HAVING 
    SUM(o.unit) >= 100;


--Write an SQL statement that returns the vendor from which each customer has placed the most orders
WITH VendorOrderCounts AS (
  SELECT 
    CustomerID,
    Vendor,
    COUNT(*) AS OrderCount,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) AS rn
  FROM Orders
  GROUP BY CustomerID, Vendor
)
SELECT 
  CustomerID,
  Vendor,
  OrderCount
FROM 
  VendorOrderCounts
WHERE 
  rn = 1;

    --You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else eturn 'This number is not prime'
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @isPrime BIT = 1;

IF @Check_Prime <= 1
BEGIN
    SET @isPrime = 0;
END
ELSE
BEGIN
    WHILE @i * @i <= @Check_Prime
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @isPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END
END

IF @isPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';


--Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.
WITH SignalCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS SignalCount
    FROM 
        Device
    GROUP BY 
        Device_id, Locations
),
RankedSignals AS (
    SELECT 
        Device_id,
        Locations,
        SignalCount,
        RANK() OVER (PARTITION BY Device_id ORDER BY SignalCount DESC) AS rk
    FROM 
        SignalCounts
),
LocationCounts AS (
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS NumberOfLocations,
        SUM(SignalCount) AS TotalSignals
    FROM 
        SignalCounts
    GROUP BY 
        Device_id
)

SELECT 
    l.Device_id,
    l.NumberOfLocations,
    r.Locations AS MostSignalsLocation,
    l.TotalSignals
FROM 
    LocationCounts l
JOIN 
    RankedSignals r ON l.Device_id = r.Device_id AND r.rk = 1
ORDER BY 
    l.Device_id;

		

		--You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.
WITH MatchedNumbers AS (
    SELECT 
        t.TicketID,
        COUNT(*) AS MatchCount
    FROM Tickets t
    INNER JOIN WinningNumbers w ON t.Number = w.Number
    GROUP BY t.TicketID
),
TicketCounts AS (
    SELECT 
        TicketID,
        COUNT(*) AS TotalNumbers
    FROM Tickets
    GROUP BY TicketID
),
Winnings AS (
    SELECT 
        tc.TicketID,
        CASE 
            WHEN mn.MatchCount = tc.TotalNumbers THEN 100
            WHEN mn.MatchCount >= 1 THEN 10
            ELSE 0
        END AS Prize
    FROM TicketCounts tc
    LEFT JOIN MatchedNumbers mn ON tc.TicketID = mn.TicketID
)
SELECT SUM(Prize) AS TotalWinnings
FROM Winnings;


--Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.
WITH UserPlatformSpend AS (
  SELECT 
    User_id,
    Spend_date,
    SUM(CASE WHEN Platform = 'Mobile' THEN Amount ELSE 0 END) AS Mobile_Amount,
    SUM(CASE WHEN Platform = 'Desktop' THEN Amount ELSE 0 END) AS Desktop_Amount
  FROM Spending
  GROUP BY User_id, Spend_date
),
UserCategories AS (
  SELECT 
    Spend_date,
    CASE 
      WHEN Mobile_Amount > 0 AND Desktop_Amount = 0 THEN 'Mobile Only'
      WHEN Desktop_Amount > 0 AND Mobile_Amount = 0 THEN 'Desktop Only'
      WHEN Desktop_Amount > 0 AND Mobile_Amount > 0 THEN 'Both'
    END AS Category,
    User_id,
    (Mobile_Amount + Desktop_Amount) AS Total_Spent
  FROM UserPlatformSpend
)
SELECT 
  Spend_date,
  Category,
  COUNT(DISTINCT User_id) AS Total_Users,
  SUM(Total_Spent) AS Total_Amount
FROM UserCategories
GROUP BY Spend_date, Category
ORDER BY Spend_date, Category;


--Write an SQL Statement to de-group the following data.
WITH Numbers AS (
    SELECT Product, Quantity, 1 AS qty
    FROM Grouped
    WHERE Quantity > 0
    UNION ALL
    SELECT Product, Quantity, qty + 1
    FROM Numbers
    WHERE qty + 1 <= Quantity
)
SELECT Product, 1 AS Quantity
FROM Numbers
ORDER BY Product;
