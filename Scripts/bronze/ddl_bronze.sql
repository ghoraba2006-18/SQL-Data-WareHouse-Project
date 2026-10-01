/*
===============================================================================
Script Name : DDL - Bronze Layer Tables Setup
Purpose     : Defines and creates all raw storage tables within the 'bronze' schema 
              for both CRM and ERP source systems.
WARNING     : Running this script will DROP existing tables if they already exist, 
              permanently deleting any data stored within them.
===============================================================================
*/

-- ============================================================================
-- CRM Tables
-- ============================================================================

-- Drop table if it exists
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

-- Create crm_cust_info (customer table)
CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);

-- Drop table if it exists
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

-- Create crm_prd_info (product table)
CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key NVARCHAR(50),	
    prd_nm NVARCHAR(50),
    prd_cost INT,	
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

-- Drop table if it exists
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

-- Create crm_sales_details (sales table)
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),	
    sls_prd_key NVARCHAR(50),	
    sls_cust_id INT,	
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- ============================================================================
-- ERP Tables
-- ============================================================================

-- Drop table if it exists
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;

-- Create erp_cust_az12 (customer table)
CREATE TABLE bronze.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);

-- Drop table if it exists
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;

-- Create erp_loc_a101 (location table)
CREATE TABLE bronze.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

-- Drop table if it exists
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;

-- Create erp_px_cat_g1v2 (product category)
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
