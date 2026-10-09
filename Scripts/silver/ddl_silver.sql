/*
===============================================================================
Purpose:
    This script initializes and creates the schema and tables for the Silver layer 
    in the Data Warehouse. It defines the structured data model for cleansed, 
    transformed, and standardized CRM and ERP data, appending a default data 
    warehouse load timestamp (`dwh_create_date`).

WARNING:
    Running this script will DROP existing tables in the 'silver' schema 
    (`silver.crm_cust_info`, `silver.crm_prd_info`, `silver.crm_sales_details`, 
    `silver.erp_cust_az12`, `silver.erp_loc_a101`, `silver.erp_px_cat_g1v2`) 
    and re-create them. ALL EXISTING DATA IN THESE TABLES WILL BE PERMANENTLY DELETED. 
    Ensure you have backups before executing this script in a production environment.
===============================================================================
*/

-- Drop table if it exists
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

-- Create crm_cust_info (customer table)
CREATE TABLE silver.crm_cust_info(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop table if it exists
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

-- Create crm_prd_info (product table)
CREATE TABLE silver.crm_prd_info(
    prd_id INT,
    cat_id NVARCHAR(50),
    prd_key NVARCHAR(50),	
    prd_nm NVARCHAR(50),
    prd_cost INT,	
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop table if it exists
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;

-- Create sales_details (sales table)
CREATE TABLE silver.crm_sales_details (
    sls_ord_num NVARCHAR(50),	
    sls_prd_key NVARCHAR(50),	
    sls_cust_id INT,	
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop table if it exists
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

-- Create CUST_AZ12 (customer table)
CREATE TABLE silver.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop table if it exists
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;

-- Create LOC_A101 (location table)
CREATE TABLE silver.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop table if it exists
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;

-- Create PX_CAT_G1V2 (product category)
CREATE TABLE silver.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
