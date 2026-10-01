/*
===============================================================================
Procedure Name : bronze.load_bronze
Purpose        : Truncates and loads raw CRM and ERP CSV data into the Bronze 
                 schema tables, measuring individual table and total batch execution time.
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	-- Track timing for individual tables and total batch execution
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		-- Record batch start time
		SET @batch_start_time = GETDATE();
		PRINT '=============================';
		PRINT 'Load the Bronze Layer';
		PRINT '=============================';

		PRINT '-----------------------------';
		PRINT 'Loading the CRM Tables';
		PRINT '-----------------------------';

		-- Load CRM Customer Info Table
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>>Inserting Data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\pc\Documents\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration: '+ Cast(DATEDIFF(SECOND, @start_time , @end_time) AS NVARCHAR) + 'Seconds';

		-- Load CRM Product Info Table
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>>Inserting Data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\pc\Documents\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration: '+ Cast(DATEDIFF(SECOND, @start_time , @end_time) AS NVARCHAR) + 'Seconds';

		-- Load CRM Sales Details Table
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>>Inserting Data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\pc\Documents\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration: '+ Cast(DATEDIFF(SECOND, @start_time , @end_time) AS NVARCHAR) + 'Seconds';

		PRINT '-----------------------------';
		PRINT 'Loading the ERP Tables';
		PRINT '-----------------------------';

		-- Load ERP Customer Table
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.erp_CUST_AZ12';
		TRUNCATE TABLE bronze.erp_CUST_AZ12;

		PRINT '>>Inserting Data into: bronze.erp_CUST_AZ12';
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\pc\Documents\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration: '+ Cast(DATEDIFF(SECOND, @start_time , @end_time) AS NVARCHAR) + 'Seconds';

		-- Load ERP Location Table
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.erp_LOC_A101';
		TRUNCATE TABLE bronze.erp_LOC_A101;

		PRINT '>>Inserting Data into: bronze.erp_LOC_A101';
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\pc\Documents\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration: '+ Cast(DATEDIFF(SECOND, @start_time , @end_time) AS NVARCHAR) + 'Seconds';

		-- Load ERP Product Category Table
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.erp_PX_CAT_G1V2';
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

		PRINT '>>Inserting Data into: bronze.erp_PX_CAT_G1V2';
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\pc\Documents\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration: '+ Cast(DATEDIFF(SECOND, @start_time , @end_time) AS NVARCHAR) + 'Seconds';

		-- Log total batch execution duration
		SET @batch_end_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading The Bronze Layer Completed in: '+ Cast(DATEDIFF(SECOND, @batch_start_time , @batch_end_time) AS NVARCHAR) + 'Seconds';
		PRINT '================================================';	
	END TRY
	BEGIN CATCH 
		-- Handle and log runtime errors
		PRINT '=================================================';
		PRINT 'ERROR OCCURED DURING LOADING THE BRONZE LAYER';
		PRINT 'ERROR MESSAGE '+ ERROR_MESSAGE();
		PRINT 'ERROR NUMBER  '+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE   '+ CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================';
	END CATCH
END;
GO

-- Execute the procedure
EXEC bronze.load_bronze;
