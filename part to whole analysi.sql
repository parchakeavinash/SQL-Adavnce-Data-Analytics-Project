          -- 4 part to whole analysis ( proportion) 
-- which category has the most impact to overall sales?

with category_sales as (
select
category,
sum(sales_amount) as total_sales
from gold.fact_sales f
join gold.dim_products p
on f.product_key  = p.product_key
group by category)

select
category,
total_sales,
sum(total_sales) over() as overall_sales,
concat(round((cast(total_sales as  float) / sum(total_sales) over()) * 100,2),'%')  as sales_percentage
from category_sales
order by total_sales desc;






          -- 4 part to whole analysis ( proportion) 
-- which category has the most impact to overall sales?

with product_sales as (
select
product_name,
sum(sales_amount) as total_sales
from gold.fact_sales f
join gold.dim_products p
on f.product_key  = p.product_key
group by product_name)

select
product_name,
total_sales,
sum(total_sales) over() as overall_sales,
concat(round((cast(total_sales as  float) / sum(total_sales) over()) * 100,2),'%')  as sales_percentage
from product_sales
order by total_sales desc