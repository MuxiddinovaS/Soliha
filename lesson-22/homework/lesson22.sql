--Compute Running Total Sales per Customer
select *, sum(total_amount) over (partition by customer_id order by order_date
rows between unbounded preceding and current row) 
as running_total_sales 
from Sales_Data
order by customer_id, order_date
--Count the Number of Orders per Product Category
select product_category,
count(*) as total_orders_per_category 
from Sales_Data 
group by product_category 
order by total_orders_per_category
--Find the Maximum Total Amount per Product Category
select product_category,
max(total_amount) as total_max_amount_per_category 
from Sales_Data 
group by product_category 
order by total_orders_per_category
--Find the Minimum Price of Products per Product Category
select product_category,
min(unit_price) as total_min_price
from Sales_Data 
group by product_category 
order by total_min_price
--Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
SELECT 
    sale_id,
    order_date,
    total_amount,
    ROUND(
        AVG(total_amount) OVER (
            ORDER BY order_date
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
        ),
        2
    ) AS moving_avg_sales
FROM 
    sales_data
ORDER BY 
    order_date;

--Find the Total Sales per Region
SELECT 
    region,
    SUM(total_amount) AS total_sales
FROM 
    sales_data
GROUP BY 
    region
ORDER BY 
    total_sales DESC;

--Compute the Rank of Customers Based on Their Total Purchase Amount
SELECT 
    customer_id,
    customer_name,
    SUM(total_amount) AS total_purchase,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS customer_rank
FROM 
    sales_data
GROUP BY 
    customer_id, customer_name
ORDER BY 
    customer_rank;

--Calculate the Difference Between Current and Previous Sale Amount per Customer
SELECT
    sale_id,
    customer_id,
    customer_name,
    order_date,
    total_amount,
    LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_amount,
    total_amount - LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS difference_from_previous
FROM
    sales_data
ORDER BY
    customer_id, order_date;

--Find the Top 3 Most Expensive Products in Each Category
select product_category, product_name, unit_price from
( select product_category, product_name, unit_price, 
DENSE_RANK() over (partition by product_category order by unit_price desc) as price_rank
from sales_data) ranked_products where price_rank <= 3
order by product_category, price_rank
--Compute the Cumulative Sum of Sales Per Region by Order Date
SELECT
    region,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY region
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM
    sales_data
ORDER BY
    region,
    order_date;

--Compute Cumulative Revenue per Product Category
SELECT
    product_category,
    order_date,
    product_name,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM
    sales_data
ORDER BY
    product_category,
    order_date;

	--Here you need to find out the sum of previous values. Please go through the sample input and expected output.
select sale_id, sum(sale_id) over (order by sale_id rows between unbounded preceding and current row) as SumPreValues
from sales_data


--Sum of Previous Values to Current Value
select value, sum(value) over (order by value rows between unbounded preceding and current row) as SumPreValues
from OneColumn



--Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.For more details please check the sample input and expected output.
SELECT
    product_category,
    product_name,
    order_date,
    ROW_NUMBER() OVER (
        PARTITION BY product_category
        ORDER BY order_date
    ) AS original_row_number,
    (2 * ROW_NUMBER() OVER (
        PARTITION BY product_category
        ORDER BY order_date
    ) - 1) AS custom_row_number
FROM
    sales_data;


--	Find customers who have purchased items from more than one product_category
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT product_category) AS category_count
FROM
    sales_data
GROUP BY
    customer_id,
    customer_name
HAVING
    COUNT(DISTINCT product_category) > 1;

--Find Customers with Above-Average Spending in Their Region
SELECT
    customer_id,
    customer_name,
    region,
    SUM(total_amount) AS customer_total,
    region_avg
FROM (
    SELECT
        customer_id,
        customer_name,
        region,
        total_amount,
        AVG(total_amount) OVER (PARTITION BY region) AS region_avg
    FROM
        sales_data
) sub
GROUP BY
    customer_id,
    customer_name,
    region,
    region_avg
HAVING
    SUM(total_amount) > region_avg;

--Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.
SELECT
    customer_id,
    customer_name,
    region,
    total_spending,
    RANK() OVER (PARTITION BY region ORDER BY total_spending DESC) AS spending_rank
FROM (
    SELECT
        customer_id,
        customer_name,
        region,
        SUM(total_amount) AS total_spending
    FROM
        sales_data
    GROUP BY
        customer_id,
        customer_name,
        region
) sub;

--Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.
SELECT
    sale_id,
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM
    sales_data
ORDER BY
    customer_id,
    order_date;

--Calculate the sales growth rate (growth_rate) for each month compared to the previous month.
WITH monthly_sales AS (
    SELECT
        FORMAT(order_date, 'yyyy-MM') AS sales_month,
        SUM(total_amount) AS total_sales
    FROM sales_data
    GROUP BY FORMAT(order_date, 'yyyy-MM')
),
growth AS (
    SELECT
        sales_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sales_month) AS prev_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    total_sales,
    prev_month_sales,
    ROUND(
        (total_sales - prev_month_sales) * 1.0 / NULLIF(prev_month_sales, 0), 4
    ) AS growth_rate
FROM growth
ORDER BY sales_month;


--Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)
with prev_amount as(
select *, lag(total_amount) over (partition by customer_id order by order_date) as prev_amount from sales_data)
select * from prev_amount where total_amount> prev_amount

--Identify Products that prices are above the average product price
with price_above as(
select *, avg(unit_price) over (partition by product_category) as avg_price from sales_data)
select * from price_above where unit_price > avg_price


--In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. The challenge here is to do this in a single select. For more details please see the sample input and expected output.
SELECT 
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM MyData;


--Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.
select ID,
sum(Cost) as Cost,
sum(distinct Quantity) as Quantity 
from TheSumPuzzle
group by ID

--From following set of integers, write an SQL statement to determine the expected outputs
WITH Numbered AS (
    SELECT SeatNumber,
           LEAD(SeatNumber) OVER (ORDER BY SeatNumber) AS NextSeat
    FROM Seats
),
Gaps AS (
    SELECT 
        SeatNumber + 1 AS GapStart,
        NextSeat - 1 AS GapEnd
    FROM Numbered
    WHERE NextSeat - SeatNumber > 1
)
-- Include start of the range if SeatNumber > 1
SELECT * FROM Gaps
UNION ALL
SELECT 1 AS GapStart, MIN(SeatNumber) - 1 AS GapEnd
FROM Seats
WHERE MIN(SeatNumber) > 1
GROUP BY SeatNumber
ORDER BY GapStart;


--In this puzzle you need to generate row numbers for the given data. The condition is that the first row number for every partition should be even number.For more details please check the sample input and expected output.
WITH Numbered AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS rn
    FROM Row_Nums
),
StartNums AS (
    SELECT Id,
           MIN(rn) AS min_rn,
           DENSE_RANK() OVER (ORDER BY Id) AS dr
    FROM Numbered
    GROUP BY Id
),
Final AS (
    SELECT n.Id, n.Vals,
           (s.dr * 2) + n.rn - 1 AS Changed
    FROM Numbered n
    JOIN StartNums s ON n.Id = s.Id
)
SELECT * FROM Final
ORDER BY Changed;
