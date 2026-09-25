/*
===============================================================================
Script Name: Data Warehouse Architecture Setup & Bronze DDL (MySQL)
===============================================================================
PURPOSE:
    This script initializes the core multi-layer database architecture (Bronze, 
    Silver, Gold) for the Data Warehouse. It specifically sets up the Bronze 
    layer schema by creating raw staging tables for CRM and ERP source systems.

WARNING:
    !!! DESTRUCTIVE ACTION WARNING !!!
    Running this script will DROP the 'bronze', 'silver', and 'gold' databases 
    if they already exist. ALL DATA stored in these databases will be PERMANENTLY 
    DELETED. Do NOT run this script in a Production environment without backing up 
    existing schemas and data first.
===============================================================================
*/

-- =========================================================
-- 1. Database Creation & Environment Setup
-- =========================================================

DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Provision the Medallion Data Architecture layers
CREATE DATABASE bronze;  -- Raw data landing zone
CREATE DATABASE silver;  -- Cleansed & transformed data zone
CREATE DATABASE gold;    -- Business-level reporting zone/marts

-- Set active context to the Bronze database for staging table creation
USE bronze;


-- =========================================================
-- 2. CRM Tables Creation (Raw Ingestion Layer)
-- =========================================================

-- Table: crm_cust_info
DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info (
	cst_id INT,                     -- Unique internal customer ID
	cst_key VARCHAR(50),            -- Customer natural key/identifier
	cst_firstname VARCHAR(50),      -- Customer first name
	cst_lastname VARCHAR(50),       -- Customer last name
	cst_marital_status VARCHAR(50), -- Marital status code/description
	cst_gndr VARCHAR(50),           -- Gender code/description
	cst_create_date DATE            -- Record creation timestamp
);

-- Table: crm_prd_info
DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info (
	prd_id INT,                     -- Unique product surrogate/internal ID
	prd_key VARCHAR(50),            -- Product business key
	prd_nm VARCHAR(50),             -- Product display name
	prd_cost INT,                   -- Base cost per unit
	prd_line VARCHAR(50),           -- Product line classification
	prd_start_dt DATE,              -- Effective start date of product record
	prd_end_dt DATE                 -- Effective end date of product record
);

-- Table: crm_sales_details
DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details (
	sls_ord_num VARCHAR(50),        -- Sales order reference number
	sls_prd_key VARCHAR(50),        -- Foreign key referencing product key
	sls_cust_id INT,                -- Foreign key referencing customer ID
	sls_order_dt DATE,              -- Date the order was placed
	sls_ship_dt DATE,               -- Date the order was shipped
	sls_due_dt DATE,                -- Order payment due date
	sls_sales DECIMAL(10, 2),       -- Total transaction amount
	sls_quantity INT,               -- Quantity sold
	sls_price DECIMAL(10, 2)        -- Unit sale price
);


-- =========================================================
-- 3. ERP Tables Creation (Raw Ingestion Layer)
-- =========================================================

-- Table: erp_cust_az12
DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12 (
	CID VARCHAR(50),                -- Customer ID (matches crm_cust_info)
	BDATE DATE,                     -- Customer birth date
	GEN VARCHAR(50)                 -- Customer gender
);

-- Table: erp_loc_a101
DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101 (
	CID VARCHAR(50),                -- Customer ID
	CNTRY VARCHAR(50)               -- Country location
);

-- Table: erp_px_cat_g1v2
DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2 (
	ID VARCHAR(50),                 -- Category mapping ID
	CAT VARCHAR(50),                -- Main product category
	SUBCAT VARCHAR(50),             -- Sub-category
	MAINTENANCE VARCHAR(50)         -- Product maintenance flag or status
);
