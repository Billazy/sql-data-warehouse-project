
/*
====================================================================================================================================
DDL Script: Create Silver Tables
====================================================================================================================================


Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables if they alredy exist.
    Run this script to re-define the DDL structure of 'silver' Tables
=====================================================================================================================================


*/
----- All Create Table silver  ------------------------------------------------------------------------------------------------------
USE DataWarehouse;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO


-------------------------------------------- First System  -----------------------------------------------------------------

-- Customer information

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info
(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
) 

--SELECT 
--*
--FROM silver.crm_cust_info


-- Product information before any extraction substring
IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info
(
    prd_id INT,
    prd_key NVARCHAR(50),
    pdr_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    pdr_start_dt DATETIME,
    pdr_end_dt DATETIME,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
)

-- Sales details
IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details
(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quatity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-------------------------------------------- Second System  -----------------------------------------------------------------
IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101
(
    cid   NVARCHAR(50),
    cntry NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12
(
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2
(
    id             NVARCHAR(50),
    cat            NVARCHAR(50),
    subcat         NVARCHAR(50),
    maintenance    NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
