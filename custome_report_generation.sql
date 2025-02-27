/* Customer Report

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

purpose: This report  consolidates key customer metric and behaviours

Hightlights: 
	1. Gathering essential field such as names, age, transaction ,
	2. segment customers into categories ( vip, regular , new) and age groups
	3. aggrage customer -level metrics:
	 - total orders
	 - total sales
	 - total quantity purchased
	 - total products
	 -	lifespan ( in month)
	4. calulate valuable kpis
		- recent (month order)
		-averge order value
		- average monthly spend
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
*/
create view  gold.report_customer as 
with base_query as(
select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) as customer_name,
DATEDIFF(year,c.birthdate, getdate()) age
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key  = f.customer_key)
,customer_aggregation as(
select 
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
count(distinct product_key)  as total_products,
sum(quantity) as total_quantity,
max(order_date) as last_order_date,
DATEDIFF(month, min(order_date), max(order_date)) as lifespan
from base_query
group by customer_key,customer_number,customer_name,age)

select 
customer_key,
customer_number,
customer_name,
age,
case when age < 20 then 'Under 20'
	 when age between 20 and 29 then '20-29'
	 when age between 29 and 39 then '29-39'
	 when age between 39 and 49 then '39-49'
	 else '50  and above'
end age_group,
CASE 
 WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
 ELSE 'New'
 END AS Customer_type,
last_order_date,
DATEDIFF(month, last_order_date, getdate()) as recency,
total_orders,
total_sales,
total_products,
total_quantity,
case when total_sales  = 0 then 0 
	else total_sales / total_orders 
end avg_order_value,
case when lifespan = 0 then total_sales
	else total_sales  / lifespan
end avg_monthly_spending
from customer_aggregation
