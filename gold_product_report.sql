WITH base_query AS (
    SELECT 
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_id,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    WHERE order_date IS NOT NULL
),
product_aggregation as (
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_order_date,
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    round(CAST(SUM(sales_amount) AS FLOAT) / NULLIF(SUM(quantity), 0),1) AS avg_selling_price
FROM base_query
GROUP BY 
    product_key,
    product_name,
    category,
    subcategory,
    cost)

select 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) as recency_in_months,
	case when total_sales > 50000 then 'High Performance'
		when total_sales >=10000 then 'Mid Range'
		else 'Low Performer'
	end Product_Segment,
	lifespan,
	total_orders,
    total_customers,
    total_sales,
    total_quantity,
    avg_selling_price,
	--average order revenue ( AOR)
	case when total_sales = 0 then 0
		else total_sales / total_orders
	end avg_order_revenue,
	--Average month revenue ( AMR)
	case when lifespan =  0 then 0 
	else total_sales / lifespan
	end avg_monthly_revenue
from product_aggregation;

/*product report view query
select * from gold.product_report; */
