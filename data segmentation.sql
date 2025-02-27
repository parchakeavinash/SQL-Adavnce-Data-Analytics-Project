/* Group customer into three segment base on their spending behavior
	- VIP customers with at least 12 month of history and spending more than $5000,
	- Regular customer with at least 12 month of history but spending $5000 or less,
	- new customer with a lifespan less than 12 month.
and find the total number of customers by each group */

WITH customer_segment AS (
    SELECT 
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_date,
        MAX(f.order_date) AS last_date
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
), 
customer_type AS (
    SELECT
        customer_key, 
        DATEDIFF(MONTH, first_date, last_date) AS total_month,
        CASE 
            WHEN DATEDIFF(MONTH, first_date, last_date) >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN DATEDIFF(MONTH, first_date, last_date) >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS Customer_type 
    FROM customer_segment
)

SELECT 
    Customer_type,
    COUNT(customer_key) AS total_customers
FROM customer_type
GROUP BY Customer_type
ORDER BY total_customers DESC;
