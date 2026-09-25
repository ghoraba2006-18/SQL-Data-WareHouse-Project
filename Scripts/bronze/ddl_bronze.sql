/*
===============================================================================
DDL & Ingestion Script: Data Warehouse Architecture Setup (MySQL)
===============================================================================
Script Purpose:
    1. Initializes the Medallion Data Architecture layers ('bronze', 'silver', 'gold').
    2. Creates raw staging tables within the 'bronze' schema for source system ingestion.
    3. Configures client-side file loading settings (`local_infile`).
    4. Truncates and loads raw CSV source files (CRM & ERP) into Bronze layer tables.

Target Environment: MySQL Server 8.0+
Database Layer Context: 
    - Bronze : Raw ingestion layer (untransformed data direct from source systems)
    - Silver : Cleansed and transformed layer (reserved for future transformations)
    - Gold   : Business-level analytical layer (marts/fact-dimension models)
===============================================================================
*/

-- ============================================================================
-- 1. Database Layer Initialization
-- ============================================================================
-- Environment cleanup: Drop pre-existing databases to allow a fresh build
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Provision multi-layered database infrastructure
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;

-- Direct current session operations to the raw ingestion (bronze) layer
USE bronze;


-- ============================================================================
-- 2. CRM Source System Tables (Bronze Layer)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: crm_cust_info
-- Description: Raw customer demographic and profile data extracted from CRM.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE
);

-- ----------------------------------------------------------------------------
-- Table: crm_prd_info
-- Description: Raw product catalog data extracted from CRM.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE
);

-- ----------------------------------------------------------------------------
-- Table: crm_sales_details
-- Description: Raw sales transaction header and line-item details from CRM.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt DATE,
    sls_ship_dt  DATE,
    sls_due_dt   DATE,
    sls_sales    DECIMAL(10, 2),
    sls_quantity INT,
    sls_price    DECIMAL(10, 2)
);


-- ============================================================================
-- 3. ERP Source System Tables (Bronze Layer)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: erp_cust_az12
-- Description: Raw customer profile supplement data extracted from ERP (System AZ12).
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12 (
    CID   VARCHAR(50),
    BDATE DATE,
    GEN   VARCHAR(50)
);

-- ----------------------------------------------------------------------------
-- Table: erp_loc_a101
-- Description: Raw customer geographic and location mapping data from ERP (System A101).
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101 (
    CID   VARCHAR(50),
    CNTRY VARCHAR(50)
);

-- ----------------------------------------------------------------------------
-- Table: erp_px_cat_g1v2
-- Description: Raw product hierarchy, category, and maintenance flags from ERP.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2 (
    ID          VARCHAR(50),
    CAT         VARCHAR(50),
    SUBCAT      VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);
