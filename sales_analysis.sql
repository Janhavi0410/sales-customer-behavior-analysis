/*=========================================================
 Project      : Sales Customer Behavior Analysis
 Author       : Janhavi Rewale
 Database     : sales_customer_analysis
 Table        : superstore_sales

 Description:
 This SQL script contains data validation, business analysis,
 and advanced analytical queries performed on the Superstore
 Sales dataset.

 Skills Demonstrated:
 ✓ Data Validation
 ✓ Aggregate Functions
 ✓ GROUP BY
 ✓ ORDER BY
 ✓ HAVING
 ✓ CASE
 ✓ DISTINCT
 ✓ Window Functions
 ✓ CTE
 ✓ Ranking
 ✓ Running Totals
=========================================================*/

USE sales_customer_analysis;

-- =========================================================
-- SECTION 1 : DATA VALIDATION
-- =========================================================

-- 1. Total Records
SELECT COUNT(*) AS total_records
FROM superstore_sales;

-- 2. Preview Dataset
SELECT *
FROM superstore_sales
LIMIT 10;

-- 3. Missing Sales Values
SELECT COUNT(*) AS missing_sales
FROM superstore_sales
WHERE Sales IS NULL;

-- 4. Duplicate Orders
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM superstore_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- =========================================================
-- SECTION 2 : BASIC BUSINESS ANALYSIS
-- =========================================================

-- 5. Total Sales
SELECT
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales;

-- 6. Average Sales
SELECT
ROUND(AVG(Sales),2) AS Average_Sales
FROM superstore_sales;

-- 7. Minimum & Maximum Sales
SELECT
MIN(Sales) AS Minimum_Sale,
MAX(Sales) AS Maximum_Sale
FROM superstore_sales;

-- 8. Sales by Category
SELECT
Category,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 9. Sales by Region
SELECT
Region,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

-- 10. Sales by Customer Segment
SELECT
Segment,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- 11. Top 10 States
SELECT
State,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 10;

-- 12. Top 10 Cities
SELECT
City,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY City
ORDER BY Total_Sales DESC
LIMIT 10;

-- 13. Top 10 Customers
SELECT
customer_name,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY customer_name
ORDER BY Total_Sales DESC
LIMIT 10;

-- 14. Top 10 Products
SELECT
product_name,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY product_name
ORDER BY Total_Sales DESC
LIMIT 10;

-- 15. Sales by Ship Mode
SELECT
ship_mode,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY ship_mode
ORDER BY Total_Sales DESC;

-- =========================================================
-- SECTION 3 : INTERMEDIATE SQL
-- =========================================================

-- 16. Total Orders
SELECT
COUNT(DISTINCT order_id) AS Total_Orders
FROM superstore_sales;

-- 17. Total Customers
SELECT
COUNT(DISTINCT customer_id) AS Total_Customers
FROM superstore_sales;

-- 18. Customers by Segment
SELECT
Segment,
COUNT(DISTINCT customer_id) AS Customers
FROM superstore_sales
GROUP BY Segment
ORDER BY Customers DESC;

-- 19. Average Sales by Category
SELECT
Category,
ROUND(AVG(Sales),2) AS Average_Sales
FROM superstore_sales
GROUP BY Category
ORDER BY Average_Sales DESC;

-- 20. High Value Transactions
SELECT *
FROM superstore_sales
WHERE Sales > 1000
ORDER BY Sales DESC;

-- 21. High Value Customers
SELECT
customer_name,
ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore_sales
GROUP BY customer_name
HAVING SUM(Sales) > 10000
ORDER BY Total_Sales DESC;

-- 22. Sales Classification
SELECT
order_id,
Sales,
CASE
    WHEN Sales >= 1000 THEN 'High'
    WHEN Sales >= 500 THEN 'Medium'
    ELSE 'Low'
END AS Sales_Category
FROM superstore_sales;

-- =========================================================
-- SECTION 4 : ADVANCED SQL
-- =========================================================

-- 23. Customer Ranking
SELECT
customer_name,
SUM(Sales) AS Total_Sales,
RANK() OVER(
ORDER BY SUM(Sales) DESC
) AS Customer_Rank
FROM superstore_sales
GROUP BY customer_name;

-- 24. Dense Ranking
SELECT
    customer_name,
    Total_Sales,
    DENSE_RANK() OVER (ORDER BY Total_Sales DESC) AS dense_ran
FROM
(
    SELECT
        customer_name,
        SUM(Sales) AS Total_Sales
    FROM superstore_sales
    GROUP BY customer_name
) AS CustomerSales;
    

-- 25. Row Number
SELECT
customer_name,
Sales,
ROW_NUMBER() OVER(
ORDER BY Sales DESC
) AS Row_Num
FROM superstore_sales;

-- 26. Running Total
SELECT
row_id,
Sales,
SUM(Sales) OVER(
ORDER BY row_id
) AS Running_Total
FROM superstore_sales;

-- 27. Top Product in Each Category
WITH ProductSales AS
(
SELECT
Category,
product_name,
SUM(Sales) AS Total_Sales,
RANK() OVER(
PARTITION BY Category
ORDER BY SUM(Sales) DESC
) AS Ranking
FROM superstore_sales
GROUP BY Category, product_name
)

SELECT *
FROM ProductSales
WHERE Ranking = 1;

-- 28. Highest Selling Category
SELECT
Category,
SUM(Sales) AS Total_Sales
FROM superstore_sales
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 1;

-- 29. Lowest Selling Products
SELECT
product_name,
SUM(Sales) AS Total_Sales
FROM superstore_sales
GROUP BY product_name
ORDER BY Total_Sales
LIMIT 10;

-- 30. Orders per Customer
SELECT
customer_name,
COUNT(*) AS Orders
FROM superstore_sales
GROUP BY customer_name
ORDER BY Orders DESC;

