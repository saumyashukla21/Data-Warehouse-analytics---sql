-- Loading silver.crm_cust_info
INSERT INTO silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)

SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) As cst_firstname ,
TRIM(cst_lastname) As cst_lastname,
CASE 
  WHEN UPPER(TRIM (cst_marital_status))= 'S' THEN 'Single'
  WHEN UPPER(TRIM (cst_marital_status))= 'M' THEN 'Married'
  ELSE 'N/A'
END cst_gndr,
CASE 
  WHEN UPPER(TRIM (cst_gndr))= 'M' THEN 'Male'
  WHEN UPPER(TRIM (cst_gndr))= 'F' THEN 'Female'
  ELSE 'N/A'
END cst_gndr,
cst_create_date
FROM (
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS LATEST
FROM bronze.crm_cust_info
)l WHERE LATEST=1;

		-- Loading silver.crm_prd_info
INSERT INTO silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-' , '_') AS cat_id, --Extract Category Id
SUBSTRING(prd_key FROM 7 FOR LENGTH(prd_key)) AS prd_key, --Extract Product Id
prd_nm,
COALESCE(prd_cost, 0) AS prd_cost, 
CASE UPPER(TRIM (prd_line))
  WHEN 'R' THEN 'Road'
  WHEN 'M' THEN 'Mountain'
  WHEN 'S' THEN 'Other Sales'
  WHEN 't' THEN 'Touring'
  ELSE 'N/A'
END prd_line,
CAST(prd_start_dt AS DATE) prd_start_dt,
CAST(
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)- INTERVAL '1 Day' AS DATE)
AS prd_end_dt -- Calculate end date as one day prior to start date
FROM bronze.crm_prd_info;

        -- Loading crm_sales_details
INSERT INTO silver.crm_sales_details(
sls_ord_num,       
sls_prd_key,        
sls_cust_id,     
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity, 
sls_price
)
SELECT
sls_ord_num, 
sls_prd_key,
sls_cust_id,  
CASE
   WHEN sls_order_dt < 0 OR LENGTH(sls_order_dt:: TEXT) != 8 THEN NULL
   ELSE CAST(CAST (sls_order_dt AS VARCHAR) AS DATE)
END sls_order_dt,
CASE
   WHEN sls_ship_dt < 0 OR LENGTH(sls_ship_dt:: TEXT) != 8 THEN NULL
   ELSE CAST(CAST (sls_ship_dt AS VARCHAR) AS DATE)
END sls_ship_dt,   
CASE
   WHEN sls_due_dt < 0 OR LENGTH(sls_due_dt:: TEXT) != 8 THEN NULL
   ELSE CAST(CAST (sls_due_dt AS VARCHAR) AS DATE)
END sls_due_dt, 
CASE 
WHEN sls_sales IS NULL 
OR sls_sales <= 0 
OR sls_sales != sls_quantity * ABS(sls_price) 
THEN sls_quantity * ABS(sls_price)
ELSE sls_sales
END AS sls_sale,
sls_quantity,
CASE 
WHEN sls_price IS NULL OR sls_price <= 0 
THEN sls_sales / NULLIF(sls_quantity, 0)
ELSE sls_price
END AS sls_prices 
FROM bronze.crm_sales_details;



            -- Loading erp_cust_az12
INSERT INTO 
silver.erp_cust_az12 (
cid,
bdate,
gen
)
SELECT 
CASE
    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4) -- start at 4th character, go to end
    ELSE cid
END AS cid,
CASE
    WHEN bdate > CURRENT_DATE THEN NULL
    ELSE bdate
END AS bdate,
CASE
    WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
END AS gen

FROM bronze.erp_cust_az12

       
	   -- Loading erp_loc_a101


INSERT INTO silver.erp_loc_a101 (
cid,
cntry
)
SELECT
REPLACE(cid, '-', '') AS cid, 
CASE
WHEN TRIM(cntry) = 'DE' THEN 'Germany'
WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101;


		-- Loading erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2 (
id,
cat,
subcat,
maintenance
)
SELECT
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2;



