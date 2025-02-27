# SQL-Advanced-Data-Analytics-Project

## 📖 Project Overview
This project focuses on **Advanced Data Analytics using SQL** to derive insights from structured datasets. It includes **cumulative analysis, change-over-time trends, performance analytics, segmentation, and reporting.**

![image](https://github.com/user-attachments/assets/f25721a9-170b-460c-ab7f-b5db7906cf5d)

## 📊 Key Features

### ✅ Cumulative Analysis
Calculating running totals and cumulative trends over time.

```sql
SELECT 
    order_date,
    SUM(sales_amount) AS total_sales,
    SUM(SUM(sales_amount)) OVER (ORDER BY order_date) AS running_total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date;
```

### ✅ Change-Over-Time Trends
Tracking monthly sales trends to understand revenue growth.

```sql
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS order_month,
    SUM(sales_amount) AS monthly_sales
FROM gold.fact_sales
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY order_month;
```

### ✅ Performance Analytics
Analyzing customer spending behavior.

```sql
WITH customer_segment AS (
    SELECT 
        customer_key,
        SUM(sales_amount) AS total_spending,
        MIN(order_date) AS first_date,
        MAX(order_date) AS last_date
    FROM gold.fact_sales
    GROUP BY customer_key
)

SELECT 
    customer_key, 
    total_spending,
    DATEDIFF(MONTH, first_date, last_date) AS customer_lifespan,
    CASE 
        WHEN DATEDIFF(MONTH, first_date, last_date) >= 12 AND total_spending > 5000 THEN 'VIP'
        WHEN DATEDIFF(MONTH, first_date, last_date) >= 12 THEN 'Regular'
        ELSE 'New'
    END AS customer_type
FROM customer_segment;
```

### ✅ Part-to-Whole Proportion
Calculating sales contribution percentage by product category.

```sql
WITH category_sales AS (
    SELECT 
        category,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales f
    JOIN gold.dim_products p ON f.product_key = p.product_key
    GROUP BY category
)
SELECT 
    category,
    total_sales,
    ROUND((total_sales * 100.0 / SUM(total_sales) OVER()), 2) AS sales_percentage
FROM category_sales
ORDER BY total_sales DESC;
```

### ✅ Data Segmentation
Grouping customers based on their purchase patterns.

```sql
SELECT 
    customer_key,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_spent,
    CASE 
        WHEN COUNT(DISTINCT order_number) >= 10 THEN 'Frequent Buyer'
        WHEN SUM(sales_amount) > 3000 THEN 'High Spender'
        ELSE 'Casual Buyer'
    END AS customer_segment
FROM gold.fact_sales
GROUP BY customer_key;
```

### ✅ Reporting
Generating a summary of key metrics.

```sql
SELECT 
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_revenue,
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales;
```

## 📂 Project Structure
```
📦 SQL-Advanced-Data-Analytics
 ┣ 📂 data                 # Raw and cleaned datasets
 ┣ 📂 queries              # SQL scripts
 ┣ 📂 reports              # Analysis reports
 ┣ 📜 README.md            # Project documentation
 ┗ 📜 image.png            # Data flow diagram
```

## 🚀 How to Use
Clone the repository:
```sh
git clone https://github.com/your-username/SQL-Advanced-Data-Analytics.git
```
Run the SQL scripts in **SQL Server or any supported database engine.**

Analyze the reports and visualize insights using **Excel/Power BI.**

## 📌 Conclusion
This project helps businesses analyze **sales trends, customer behavior, and revenue performance** using SQL. It can be extended with **visualization dashboards** for deeper insights.

