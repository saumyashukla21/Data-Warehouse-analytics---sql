/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
*/
/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
*/
DO $$
DECLARE
start_time TIMESTAMP;
end_time   TIMESTAMP;
BEGIN
-- Capture start time
start_time := clock_timestamp();
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
cst_id              INT,
cst_key             VARCHAR(50),
cst_firstname       VARCHAR(50),
cst_lastname        VARCHAR(50),
cst_marital_status  VARCHAR(50),
cst_gndr            VARCHAR(50),
cst_create_date     DATE
);


CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
prd_id       INT,
prd_key      VARCHAR(50),
prd_nm       VARCHAR(50),
prd_cost     INT,
prd_line     VARCHAR(50),
prd_start_dt TIMESTAMP,
prd_end_dt   TIMESTAMP
);



CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
sls_ord_num  VARCHAR(50),
sls_prd_key  VARCHAR(50),
sls_cust_id  INT,
sls_order_dt TIMESTAMP,
sls_ship_dt  INT,
sls_due_dt   INT,
sls_sales    INT,
sls_quantity INT,
sls_price    INT
);


CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
cid    VARCHAR(50),
cntry  VARCHAR(50)
);

CREATE TABLE bronze.erp_cust_az12 (
cid    VARCHAR(50),
bdate  TIMESTAMP,
gen    VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
id           VARCHAR(50),
cat          VARCHAR(50),
subcat       VARCHAR(50),
maintenance  VARCHAR(50)
);
EXCEPTION
  WHEN unique_violation THEN
    RAISE NOTICE 'Duplicate entry detected, skipping insert.';
  WHEN foreign_key_violation THEN
    RAISE NOTICE 'Foreign key issue occurred.';
  WHEN others THEN
    RAISE NOTICE 'Unexpected error: %', SQLERRM;
	 end_time := clock_timestamp();

-- Show duration
RAISE NOTICE 'Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
END;
$$;