						-- SQL Advance Analytics
						-- Change  over time trends analysis
						-- changing over year 
select 
year(order_date) as order_year,
sum(sales_amount) as total_Sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date)
order by year(order_date);

select 
datetrunc(month, order_date) as order_year,
sum(sales_amount) as total_Sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
order by datetrunc(month, order_date);


/*SELECT 
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM'); */


select * from gold.fact_sales;

-- HOW MANY NEW CUSTOMERS WERE ADDED EACH YEAR

select 
DATETRUNC(year, create_date) as create_date,
count(customer_key) as total_customer
from gold.dim_customers
group by DATETRUNC(year, create_date)
order by DATETRUNC(year, create_date);



