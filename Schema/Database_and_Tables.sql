/*
=============================================================
Create Database and Schemas
=============================================================
Creates a new database named 'DataWarehouseAnalytics' */



-- Create Schema (if not exists)
CREATE SCHEMA IF NOT EXISTS gold;

-- Create Tables
CREATE TABLE gold.dim_customers (
    customer_key     INT,
    customer_id      INT,
    customer_number  VARCHAR(50),
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    country          VARCHAR(50),
    marital_status   VARCHAR(50),
    gender           VARCHAR(50),
    birthdate        DATE,
    create_date      DATE
);

CREATE TABLE gold.dim_products (
    product_key     INT,
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(50),
    category_id     VARCHAR(50),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     VARCHAR(50),
    cost            INT,
    product_line    VARCHAR(50),
    start_date      DATE
);

CREATE TABLE gold.fact_sales (
    order_number   VARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     DATE,
    shipping_date  DATE,
    due_date       DATE,
    sales_amount   INT,
    quantity       SMALLINT,
    price          INT
);

-- Truncate tables
TRUNCATE TABLE gold.dim_customers;
TRUNCATE TABLE gold.dim_products;
TRUNCATE TABLE gold.fact_sales;