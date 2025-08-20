use coffee_shop_sales_db
select * from coffee_shop_sales
describe coffee_shop_sales

SELECT ROUND(SUM(unit_price * transaction_qty)) as Total_Sales 
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)


SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'
 
-- sun=1, mon=2.....sat=7
select
    case when dayofweek(transaction_date) in (1,7) then "Weekends"
    else "Weekdays"
    end as day_type,
    sum(unit_price * transaction_qty) as Total_sales
from coffee_shop_sales
where month(transaction_date)= 5
group by
    case when dayofweek(transaction_date) in (1,7) then "Weekends"
    else "Weekdays"
    end 


select
	 store_location,
	 concat(round(sum(unit_price* transaction_qty)/1000,2), "K") as Total_sales
from coffee_shop_sales
where month(transaction_date)= 6
group by store_location
order by sum(unit_price* transaction_qty) desc

-- monthly sales analysis
select
     concat(round(avg(total_sales)/1000, 1), "K") as Avg_sales
from
     (
     select sum(transaction_qty* unit_price) as total_sales
     from coffee_shop_sales
     where month(transaction_date)= 5
     group by transaction_date
     ) as Internal_query

-- daily sales analysis
select
     day(transaction_date) as day_of_month,
     sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date)= 5
group by day(transaction_date)
order by day(transaction_date)


SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;


select
     product_category,
     sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date)=5
group by product_category
order by sum(unit_price * transaction_qty) desc
