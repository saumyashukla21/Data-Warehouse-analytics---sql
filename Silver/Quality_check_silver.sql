--Check for nulls And Duplicates in Primary key
--PK: Must be UNIQUE and NOT NULL

SELECT 
prd_id, COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL

--Order By latest
--Remove Duplicates
SELECT * FROM


--Check unwanted spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname!= TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname!= TRIM(cst_lastname);

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr!= TRIM(cst_gndr);


--Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;


SELECT 
cst_id, COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL

--Order By latest
--Remove Duplicates
SELECT * FROM


--Check unwanted spaces
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname!= TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname!= TRIM(cst_lastname);

SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr!= TRIM(cst_gndr);


--Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

--Check for Nulls & negative numbers
SELECT prd_cost FROM bronze.crm_prd_info
Where prd_cost < 0 OR prd_cost IS NULL

--Check for Invalid Date orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--check data consistency
-- Sales = Qty * price
--Values must not be null, zero, or negative
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price,
CASE 
WHEN sls_sales IS NULL 
OR sls_sales <= 0 
OR sls_sales != sls_quantity * ABS(sls_price) 
THEN sls_quantity * ABS(sls_price)
ELSE sls_sales
END AS sls_sale,
CASE 
WHEN sls_price IS NULL OR sls_price <= 0 
THEN sls_sales / NULLIF(sls_quantity, 0)
ELSE sls_price
END AS sls_prices
FROM bronze.crm_sales_details
Where sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 IS NULL OR sls_price <=0 IS NULL
ORDER BY sls_sale, sls_quantity, sls_prices;


