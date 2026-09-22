/*
===============================================================================
Script Name:    init_DataBase.sql
Purpose:        Creates the 'DataWareHouse' database and sets up the Medallion 
                architecture schemas (Bronze, Silver, Gold).
===============================================================================
WARNING:
    Running this script will switch context to the master database and 
    initialize the 'DataWareHouse' database and its primary schemas.
===============================================================================
*/

USE master;

CREATE DATABASE DataWareHouse;

USE DataWareHouse;

CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;
GO
