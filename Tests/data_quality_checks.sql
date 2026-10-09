/*
===============================================================================
Purpose:
    This script verifies and validates data integrity across all Silver layer 
    tables (CRM & ERP) after the ETL load process. It ensures that data cleansing,
    deduplication, value standardization, and referential integrity rules were 
    properly applied across the data warehouse.
===============================================================================
*/

-- ============================================================================
-- 1. CRM CUSTOMER DATA VALIDATION (silver.crm_cust_info)
-- ============================================================================

-- View all records in the Silver customer table
SELECT * FROM Silver.crm_cust_info;

-- Verify primary key uniqueness (Ensure deduplication worked and no NULL cst_id exists)
SELECT cst_id, COUNT(*)
FROM Silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Verify whitespace trimming on text columns
SELECT cst_firstname      FROM silver.crm_cust_info WHERE cst_firstname      != TRIM(cst_firstname);
SELECT cst_lastname       FROM silver.crm_cust_info WHERE cst_lastname       != TRIM(cst_lastname);
SELECT cst_gndr           FROM silver.crm_cust_info WHERE cst_gndr           != TRIM(cst_gndr);
SELECT cst_marital_status FROM silver.crm_cust_info WHERE cst_marital_status != TRIM(cst_marital_status);

-- Confirm domain values were properly standardized ('Male'/'Female'/'N/A', 'Single'/'Married'/'N/A')
SELECT DISTINCT cst_gndr           FROM silver.crm_cust_info;
SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info;


-- ============================================================================
-- 2. CRM PRODUCT DATA VALIDATION (silver.crm_prd_info)
-- ============================================================================

-- View all records in the Silver product table
SELECT * FROM silver.crm_prd_info;

-- Verify primary key uniqueness (No duplicate prd_id or NULL values)
SELECT prd_id, COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Review cleansed product keys
SELECT prd_key FROM silver.crm_prd_info;

-- Verify whitespace trimming on product names
SELECT prd_nm FROM silver.crm_prd_info WHERE prd_nm != TRIM(prd_nm);

-- Verify standardized product lines ('Road', 'Mountain', 'Touring', 'Other Sales', 'N/A')
SELECT DISTINCT prd_line FROM silver.crm_prd_info;

-- Ensure no invalid or NULL product costs remain
SELECT prd_cost FROM silver.crm_prd_info WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Verify date range logic (Ensure effective start date is never after end date)
SELECT * FROM silver.crm_prd_info WHERE prd_start_dt > prd_end_dt;


-- ============================================================================
-- 3. CRM SALES DETAILS DATA VALIDATION (silver.crm_sales_details)
-- ============================================================================

-- Verify no leading/trailing spaces in order numbers
SELECT * FROM silver.crm_sales_details WHERE sls_ord_num != TRIM(sls_ord_num);

-- Check referential integrity: Orphan sales records referencing missing product keys
SELECT 
    sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, 
    sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM Silver.crm_prd_info);

-- Check referential integrity: Orphan sales records referencing missing customer IDs
SELECT 
    sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, 
    sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM Silver.crm_cust_info);

-- Check for invalid due date values outside acceptable bounds
SELECT NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <= 0 
   OR LEN(sls_due_dt) != 8 
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- Verify date sequencing logic (Order date must precede ship date and due date)
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt;

-- Verify numeric calculation integrity (Sales = Quantity * Price and non-negative values)
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL    OR sls_quantity IS NULL    OR sls_price IS NULL
   OR sls_sales <= 0       OR sls_quantity <= 0       OR sls_price <= 0 
ORDER BY sls_sales, sls_quantity, sls_price;


-- ============================================================================
-- 4. ERP CUSTOMER DATA VALIDATION (silver.erp_cust_az12)
-- ============================================================================

-- View cleansed customer demographic data from ERP
SELECT cid, bdate, gen FROM silver.erp_CUST_AZ12;

-- Check raw Bronze gender values to confirm transformation accuracy
SELECT DISTINCT gen FROM bronze.erp_CUST_AZ12;


-- ============================================================================
-- 5. ERP LOCATION DATA VALIDATION (silver.erp_loc_a101)
-- ============================================================================

-- Check referential integrity: ERP customer locations matching CRM customer keys
SELECT cid, cntry
FROM silver.erp_LOC_A101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Verify distinct standardized country names in Silver ERP location table
SELECT DISTINCT cntry FROM silver.erp_LOC_A101;


-- ============================================================================
-- 6. ERP PRODUCT CATEGORY VALIDATION (silver.erp_px_cat_g1v2)
-- ============================================================================

-- View cleansed product category lookup records
SELECT id, cat, subcat, maintenance FROM silver.erp_PX_CAT_G1V2;

-- Verify whitespace trimming on category and subcategory text
SELECT id, cat, subcat, maintenance 
FROM silver.erp_PX_CAT_G1V2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat);

-- Find category IDs in raw Bronze that do not map to Silver product categories
SELECT id 
FROM bronze.erp_PX_CAT_G1V2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info);
