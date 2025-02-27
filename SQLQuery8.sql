WITH product_sales AS (
    SELECT
        product_name,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales f
    JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY product_name
),
sales_with_percentage AS (
    SELECT
        product_name,
        total_sales,
        SUM(total_sales) OVER() AS overall_sales, -- Compute total sales once
        ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 2) AS sales_percentage
    FROM product_sales
)
SELECT *
FROM sales_with_percentage
WHERE sales_percentage > 3  -- Now we can filter properly
ORDER BY total_sales DESC;
