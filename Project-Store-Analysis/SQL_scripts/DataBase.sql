/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called ld
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/
SHOW VARIABLES LIKE 'local_infile';
SELECT @@GLOBAL.local_infile, @@SESSION.local_infile;
SHOW VARIABLES LIKE 'secure_file_priv';


-- Drop and recreate the 'DataWarehouseAnalytics' database
DROP DATABASE IF EXISTS DataWarehouseAnalytics;

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;


USE DataWarehouseAnalytics;


CREATE TABLE DataWarehouseAnalytics.dim_customers(
	customer_key int,
	customer_id int,
	customer_number VARCHAR(50),
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	country VARCHAR(50),
	marital_status VARCHAR(50),
	gender VARCHAR(50),
	birthdate date,
	create_date date
);


CREATE TABLE DataWarehouseAnalytics.dim_products(
	product_key int ,
	product_id int ,
	product_number VARCHAR(50) ,
	product_name VARCHAR(50) ,
	catery_id VARCHAR(50) ,
	catery VARCHAR(50) ,
	subcatery VARCHAR(50) ,
	maintenance VARCHAR(50) ,
	cost decimal,
	product_line VARCHAR(50),
	start_date date 
);


CREATE TABLE DataWarehouseAnalytics.fact_sales(
	order_number VARCHAR(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity int,
	price decimal 
);


TRUNCATE TABLE DataWarehouseAnalytics.dim_customers;

LOAD DATA LOCAL INFILE 'C:/Users/DIEGO/Documents/Projects/SQL Data Project/datasets/csv-files/dim_customers.csv'
INTO TABLE DataWarehouseAnalytics.dim_customers
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

TRUNCATE TABLE DataWarehouseAnalytics.dim_products;

LOAD DATA LOCAL INFILE 'C:/Users/DIEGO/Documents/Projects/SQL Data Project/datasets/csv-files/dim_products.csv'
INTO TABLE DataWarehouseAnalytics.dim_products
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


TRUNCATE TABLE DataWarehouseAnalytics.fact_sales;

LOAD DATA LOCAL INFILE 'C:/Users/DIEGO/Documents/Projects/SQL Data Project/datasets/csv-files/fact_sales.csv'
INTO TABLE DataWarehouseAnalytics.fact_sales
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

use datawarehouseanalytics;
select * from dim_customers;