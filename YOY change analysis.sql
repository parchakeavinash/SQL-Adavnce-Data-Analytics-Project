/* Analyse the yearly performance of product  by comparing thier salest
both the aveage sales perfomance of the product and the previous yearly sales */

-- year to year change analysis

with yealy_sales_performance as (
select 
year(f.order_date) as order_year,
p.product_name,
sum(f.sales_amount) as current_sales
from gold.fact_sales f
left join gold.dim_products p
on f.product_key  = p.product_key
where f.order_date is not null
group by year(f.order_date),
p.product_name
)

select 
order_year,
product_name,
current_sales,
avg(current_sales) OVER(PARTITION BY product_name) as avg_sales,
current_sales - avg(current_sales) OVER(PARTITION BY product_name) as diff_avg,
case when current_sales - avg(current_sales) OVER(PARTITION BY product_name) > 0 then 'Above Avg'
	when current_sales - avg(current_sales) OVER(PARTITION BY product_name)  < 0 then 'Below Avg'
	else '0'
End avg_change,
lag(current_sales) over(partition by product_name  order by order_year) as py_sales,
current_sales - lag(current_sales) over(partition by product_name  order by order_year) as diff_py,
case when lag(current_sales) over(partition by product_name  order by order_year) > 0 then 'Increase'
	when lag(current_sales) over(partition by product_name  order by order_year)  < 0 then 'Decrease'
	else 'No change'
End py_channge
from yealy_sales_performance
order by product_name, order_year;