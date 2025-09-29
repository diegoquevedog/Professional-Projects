USE datawarehouseanalytics;

-- TOTAL SALES BY DAY
SELECT 
order_date,
SUM(sales_amount) AS total_amount
FROM fact_sales
WHERE order_date IS NOT NULL AND order_date <> 0
GROUP BY order_date
ORDER BY order_date ASC; 

-- TOTAL KPIS BY YEAR
SELECT 
YEAR(order_date) AS years,
SUM(sales_amount) AS total_amount,
COUNT(order_number) AS total_order_number,
COUNT(DISTINCT customer_key) AS number_customers,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS number_products
FROM fact_sales
WHERE order_date IS NOT NULL AND YEAR(order_date) <> 0
GROUP BY years
ORDER BY years ASC; 

-- TOTAL KPIS BY MONTH
SELECT 
MONTH(order_date) AS months,
SUM(sales_amount) AS total_amount,
COUNT(order_number) AS total_order_number,
COUNT(DISTINCT customer_key) AS number_customers,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS number_products
FROM fact_sales
WHERE order_date IS NOT NULL AND YEAR(order_date) <> 0
GROUP BY months
ORDER BY months ASC; 

-- TOTAL KPIS BY MONTH AND YEAR
SELECT 
DATE_FORMAT(order_date, '%Y-%m-01') AS order_dates,
SUM(sales_amount) AS total_amount,
COUNT(order_number) AS total_order_number,
COUNT(DISTINCT customer_key) AS number_customers,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS number_products
FROM fact_sales
WHERE order_date IS NOT NULL AND YEAR(order_date) <> 0
GROUP BY order_dates
ORDER BY order_dates ASC; 

-- TOTAL SALES PER MONTH AND RUNNING TOTAL OF SALES OVER TIME
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total,
ROUND(AVG(avg_price) OVER(ORDER BY order_date),2) AS moving_average_price
FROM
(
SELECT
DATE_FORMAT(order_date,'%Y-%m') AS order_date,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM fact_sales
WHERE order_date IS NOT NULL AND order_date <> 0
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
) t;

-- TOTAL SALES PER YEAR AND RUNNING TOTAL OF SALES OVER TIME
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total,
ROUND(AVG(avg_price) OVER(ORDER BY order_date),2) AS moving_average_price
FROM
(
SELECT
DATE_FORMAT(order_date,'%Y') AS order_date,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM fact_sales
WHERE order_date IS NOT NULL AND order_date <> 0
GROUP BY DATE_FORMAT(order_date,'%Y')
) t;


-- ANALISYS YEAR PERFORMANCE OF PRODUCTS COMPARING EACH PRODUCT 
-- THE AVERAGE SALES PERFORMANCE AND PREVIOUS YEAR'S SALES
WITH yearly_product_sales AS (
SELECT
YEAR(fs.order_date) AS year_order_date,
dp.product_name,
SUM(fs.sales_amount) AS total_sales
FROM fact_sales fs
LEFT JOIN dim_products dp
ON dp.product_key = fs.product_key
WHERE fs.order_date IS NOT NULL
GROUP BY dp.product_name, YEAR(fs.order_date)
)

SELECT
year_order_date,
product_name,
total_sales,
ROUND(AVG(total_sales) OVER(PARTITION BY product_name),2) AS total_sales_avg,
total_sales - AVG(total_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) > 0 THEN 'Abobe Avg'
	WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
    ELSE 'Avg'
    END avg_change,
-- Year over year analysis
LAG(total_sales) OVER(PARTITION BY product_name ORDER BY year_order_date) AS py_sales,
CASE WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY year_order_date) > 0 THEN 'Increase'
	WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY year_order_date) < 0 THEN 'Decrease'
    ELSE 'No Change'
    END avg_change
FROM yearly_product_sales
ORDER BY product_name, year_order_date;


-- Which categorie Contribute the most overall sales
WITH total_analysis AS (
SELECT 
dp.catery,
SUM(fs.sales_amount) AS total_sales_category,
COUNT(fs.customer_key) AS number_customers,
(
SELECT 
SUM(sales_amount)
FROM fact_sales
) AS total_sales,
AVG(fs.price) AS avg_price
FROM fact_sales fs
LEFT JOIN dim_products dp
ON dp.product_key = fs.product_key
GROUP BY catery
)

SELECT 
catery,
number_customers,
total_sales_category,
CONCAT(ROUND(((total_sales_category/total_sales)*100),2),'%') AS contibution_per_category,
ROUND(avg_price,2)
FROM total_analysis
ORDER BY total_sales_category DESC;

-- New Dimension
USE datawarehouseanalytics;
WITH total_products AS (
SELECT
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
    WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
    ELSE 'Above 1000'
    END cost_range
FROM dim_products
)
SELECT 
cost_range,
COUNT(product_key) AS number_product
FROM total_products
GROUP BY cost_range
ORDER BY number_product DESC;

/*
Three segment customers base in their spending behavior
VIP: at least 12 months history and more 5k spendings
Regular: at least 12 months history and spendings 5k or less
New: Lifespan less than 12 months
*/
WITH table_data AS(
SELECT 
dc.customer_key,
SUM(fs.sales_amount) total_sales_customer,
MIN(fs.order_date) AS first_order,
MAX(fs.order_date) AS last_order,
TIMESTAMPDIFF(MONTH,MIN(fs.order_date),MAX(fs.order_date)) AS lifespan
FROM fact_sales fs
LEFT JOIN
dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY customer_key
),
customer_segmentation_table AS (
SELECT
customer_key,
total_sales_customer,
lifespan,
CASE WHEN lifespan >= 12 AND total_sales_customer > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_sales_customer <= 5000 THEN 'Regular'
    ELSE 'New'
	END customer_segmentation
FROM table_data
)

SELECT 
COUNT(customer_key) AS number_customers
FROM customer_segmentation_table
GROUP BY customer_segmentation
ORDER BY number_customers DESC;
    
    
    
/*
Customer Report

Purpose:
     - This report consolidates key customer metrics and behaviors
Highlights:
     1. Gathers essential fields such as names, ages, and transaction details.
     2. Segments customers into categories (VIP, Regular, New) and age groups.
     3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
     4. Calculates valuable KPIs:
         - recency (months since last order)
         - average order value
         - average monthly spend

*/
CREATE VIEW report_customers AS
WITH base_query AS (
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
f.price,
dc.customer_key,
dc.customer_number,
CONCAT(dc.first_name, ' ',dc.last_name) AS customer_name,
TIMESTAMPDIFF(YEAR,dc.birthdate,NOW()) AS age,
dp.catery,
dp.subcatery,
dp.cost,
dp.start_date
FROM fact_sales f
LEFT JOIN dim_customers dc
ON f.customer_key = dc.customer_key
LEFT JOIN dim_products dp
ON f.product_key = dp.product_key
WHERE f.order_date IS NOT NULL
),

customer_aggregation AS(
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(*) AS number_product,
	COUNT(DISTINCT order_number) AS number_orders,
	MAX(order_date) AS last_order,
	TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)

SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
    CASE WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE 'Above 50' 
		END age_range,
	total_sales,
	total_quantity,
    CASE WHEN number_orders = 0 THEN 0
		ELSE total_sales/number_orders 
        END avg_order_value,
	number_product,
	number_orders,
	last_order,
    TIMESTAMPDIFF(MONTH,last_order,NOW()) AS time_last_order,
	lifespan,
	CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/lifespan
        END avg_monthly_spending,
	CASE WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan > 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New' 
		END customer_category
FROM customer_aggregation;

SELECT * 
FROM report_customers
INTO OUTFILE 'C:/Users/DIEGO/Documents/Projects/SQL Data Project/report_customers.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    