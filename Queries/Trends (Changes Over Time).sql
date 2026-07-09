/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: EXTRACT(), DATE_TRUNC(), TO_CHAR()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

SELECT 
    EXTRACT('year' FROM order_date) AS Year,
    EXTRACT('month' FROM order_date) AS Month,
    COUNT (DISTINCT Customer_key) AS Total_customers, 
	SUM(sales_amount) AS Total_sales, 
	SUM(quantity) AS Total_qty
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY Year, Month
ORDER BY Year, Month;



-- DATETRUNC()
SELECT
    DATE_TRUNC('month', order_date):: Date AS month_start,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY month_start
ORDER BY month_start;

--TO_CHAR
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY TO_CHAR(order_date, 'YYYY-Mon');