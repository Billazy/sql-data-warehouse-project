
/*

================================================================================================================
Create Database and Schemas
================================================================================================================

This script initializes the DataWarehouse environment from scratch. It first checks if the database already exists
and safely drops it (forcing single-user mode to terminate active connections), ensuring a clean setup.

After recreating the database, it defines a layered architecture using three schemas:

bronze: raw, ingested data
silver: cleaned and transformed data
gold: curated, business-ready data

This structure follows modern data engineering best practices, enabling clear separation of data processing stages and 
improving maintainability and scalability of the warehouse.

*/



--- Create Database 'DataWarehouse'
USE master;
GO



-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO


-- Create the 'DataWarehouse' data base 
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO


-- Create Schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
