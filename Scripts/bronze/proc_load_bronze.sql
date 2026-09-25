-- ============================================================================
-- 4. Data Loading Configuration & Bulk File Import
-- ============================================================================

-- Enable client-side file loading capabilities on the MySQL server session
SET GLOBAL local_infile = 1;

-- Verify runtime status for 'local_infile' configuration parameter
SHOW VARIABLES LIKE 'local_infile';

-- ----------------------------------------------------------------------------
-- Data Import: CRM Datasets
-- ----------------------------------------------------------------------------

-- Ingest Customer Info
TRUNCATE TABLE crm_cust_info;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Ingest Product Info
TRUNCATE TABLE crm_prd_info;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Ingest Sales Transaction Details
TRUNCATE TABLE crm_sales_details;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- ----------------------------------------------------------------------------
-- Data Import: ERP Datasets
-- ----------------------------------------------------------------------------

-- Ingest ERP Customer Demographics
TRUNCATE TABLE erp_cust_az12;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_az12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Ingest ERP Location Data
TRUNCATE TABLE erp_loc_a101;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loc_a101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Ingest ERP Product Category Mapping
TRUNCATE TABLE erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/px_cat_g1v2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- =========================================================
-- 5. Verification Queries
-- =========================================================

SELECT COUNT(*) AS cust_count FROM crm_cust_info;
SELECT COUNT(*) AS prd_count FROM crm_prd_info;
SELECT COUNT(*) AS sales_count FROM crm_sales_details;
SELECT COUNT(*) AS erp_cust_count FROM erp_cust_az12;
SELECT COUNT(*) AS erp_loc_count FROM erp_loc_a101;
SELECT COUNT(*) AS erp_px_count FROM erp_px_cat_g1v2;
