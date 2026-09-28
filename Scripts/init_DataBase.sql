/*
===============================================================================
Create Database and Schemas
===============================================================================
Purpose:
    Creates a new database named 'DataWarehouse'. If it already exists,
    it is dropped and recreated. Then creates three schemas:
    bronze, silver, and gold.

WARNING:
    Running this script will permanently delete the entire 'DataWarehouse'
    database and all its data if it exists. Make sure you have a backup
    before running it.
===============================================================================
*/

USE master;

GO

-- Drop the database if it already exists
IF EXISTS (SELECT 1 FROM SYS.DATABASES WHERE NAME = 'DataWarehouse')
BEGIN
	-- Disconnect other users and roll back their open transactions
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;

GO

-- Create the database
CREATE DATABASE DataWarehouse;

GO

USE DataWarehouse;

GO

-- Create the schemas
CREATE SCHEMA bronze;   -- raw data

GO

CREATE SCHEMA silver;   -- cleaned data

GO

CREATE SCHEMA gold;     -- business-ready data

GO
