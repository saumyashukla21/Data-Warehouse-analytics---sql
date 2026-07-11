--ADDING METADATA COLUMN
DO $$
DECLARE
start_time TIMESTAMP;
end_time   TIMESTAMP;
BEGIN
-- Capture start time
start_time := clock_timestamp();
CREATE TABLE IF NOT EXISTS silver.crm_cust_info (
cst_id              INT,
cst_key             VARCHAR(50),
cst_firstname       VARCHAR(50),
cst_lastname        VARCHAR(50),
cst_marital_status  VARCHAR(50),
cst_gndr            VARCHAR(50),
cst_create_date     DATE,
dwh_create_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
IF NOT EXISTS
DROP TABLE silver.crm_prd_info 
CREATE TABLE silver.crm_prd_info (
prd_id       INT,
cat_id       VARCHAR(50),
prd_key      VARCHAR(50),
prd_nm       VARCHAR(50),
prd_cost     INT,
prd_line     VARCHAR(50),
prd_start_dt DATE,
prd_end_dt   DATE,
dwh_create_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DROP Table silver.crm_sales_details
CREATE TABLE IF NOT EXISTS silver.crm_sales_details (
sls_ord_num        VARCHAR(50),
sls_prd_key        VARCHAR(50),
sls_cust_id        INT,
sls_order_dt       DATE,
sls_ship_dt        DATE,
sls_due_dt         DATE,
sls_sales          INT,
sls_quantity       INT, 
sls_price          INT,
dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS silver.erp_loc_a101 (
cid                 VARCHAR(50),
cntry               VARCHAR(50),
dwh_create_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE silver.erp_cust_az12 (
cid                 VARCHAR(50),
bdate               TIMESTAMP,
gen                 VARCHAR(50),
dwh_create_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS silver.erp_px_cat_g1v2 (
id                  VARCHAR(50),
cat                 VARCHAR(50),
subcat              VARCHAR(50),
maintenance         VARCHAR(50),
dwh_create_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
