/* segment products  into cost range
	count how many  products fall into  each segment */

with product_segment as 
(select 
product_key,
product_name,
cost,
case  when cost < 100 then 'Below 100'
	  when cost between 100 and 500 then '100-500'
	  when cost between 500 and 1000 then '500-1000'
	  else 'Above 1000'
end cost_range
from gold.dim_products)

select 
cost_range,
count(product_key) as total_product
from product_segment
group by cost_range
order by 2 desc;



