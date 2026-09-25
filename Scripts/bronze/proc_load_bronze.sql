/*
===============================================================================
Section 4: Data Loading Configuration & CSV Import (Bronze Layer)
===============================================================================
PURPOSE:
    Configures MySQL session security settings for bulk loading and executes 
    full-refresh (TRUNCATE + LOAD) data ingestion from raw CSV flat files into 
    the Bronze staging tables for both CRM and ERP source domains.

WARNING:
    1. TRUNCATE OPERATIONS ARE NON-RECOVERABLE: Running this section empties 
       all target Bronze tables immediately before reloading. Any existing data 
       will be completely wiped out.
    2. LOCAL INFILE SECURITY RISK: Enabling `local_infile` allows local file 
       transfers to the database server. Ensure this privilege is granted only 
       to trusted ETL batch user accounts in non-development environments.
    3. FILE PATH ACCESSIBILITY: The executing MySQL process must have read 
       permissions for the specified file paths (e.g., standard Uploads directory).
===============================================================================
*/

-- =========================================================
-- 1. Ingestion Configuration & Environment Checks
-- =========================================================

-- Enable client-side local file bulk loading capability for the global server session
SET GLOBAL local_infile = 1;

-- Verify runtime status for 'local_infile' to ensure setting was successfully applied
SHOW VARIABLES LIKE 'local_infile';


-- =========================================================
-- 2. CRM Source System File Ingestion
-- =========================================================

-- Load: crm_cust_info
TRUNCATE TABLE crm_cust_info;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Load: crm_prd_info
TRUNCATE TABLE crm_prd_info;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Load: crm_sales_details
TRUNCATE TABLE crm_sales_details;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


-- =========================================================
-- 3. ERP Source System File Ingestion
-- =========================================================

-- Load: erp_cust_az12
TRUNCATE TABLE erp_cust_az12;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_az12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Load: erp_loc_a101
TRUNCATE TABLE erp_loc_a101;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loc_a101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Load: erp_px_cat_g1v2
TRUNCATE TABLE erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/px_cat_g1v2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
