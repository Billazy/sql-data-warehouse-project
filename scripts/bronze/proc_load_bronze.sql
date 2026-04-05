/*
============================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
============================================================================================

Description:
This stored procedure loads raw data from CSV files into Bronze tables.
It performs a full refresh by truncating tables before inserting new data.

Steps:
1. Initialize execution timestamps
2. Load CRM data (Customer, Product, Sales)
3. Load ERP data (Location, Customer, Product Categories)
4. Track execution time for each table and overall batch
5. Handle errors using TRY...CATCH

============================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN

    -- Declare variables to track execution time
    DECLARE @start_time DATETIME, 
            @end_time DATETIME, 
            @batch_start_time DATETIME, 
            @batch_end_time DATETIME;

    BEGIN TRY

        -- Start batch timer
        SET @batch_start_time = GETDATE();

        PRINT '=================================================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=================================================================================';

        -------------------------------------------------------------------------------------
        -- STEP 1: Load CRM Tables
        -------------------------------------------------------------------------------------
        PRINT 'Loading CRM Tables';

        -- Load Customer Information
        SET @start_time = GETDATE();

        -- Remove existing data (full refresh strategy)
        TRUNCATE TABLE bronze.crm_cust_info;  

        -- Load data from CSV file into table
        BULK INSERT bronze.crm_cust_info
        FROM 'D:\DataEngineering\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH 
        (
            FIRSTROW = 2,            -- Skip header row
            FIELDTERMINATOR = ',',   -- CSV delimiter
            TABLOCK                  -- Improve performance
        );

        -- Log execution time
        SET @end_time = GETDATE();
        PRINT 'crm_cust_info Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        -------------------------------------------------------------------------------------
        -- Load Product Information
        -------------------------------------------------------------------------------------
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.crm_prd_info;  

        BULK INSERT bronze.crm_prd_info
        FROM 'D:\DataEngineering\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'crm_prd_info Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        -------------------------------------------------------------------------------------
        -- Load Sales Details
        -------------------------------------------------------------------------------------
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.crm_sales_details;  

        BULK INSERT bronze.crm_sales_details
        FROM 'D:\DataEngineering\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'crm_sales_details Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        -------------------------------------------------------------------------------------
        -- STEP 2: Load ERP Tables
        -------------------------------------------------------------------------------------
        PRINT 'Loading ERP Tables';

        -- Load Location Data
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.erp_loc_a101;  

        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\DataEngineering\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'erp_loc_a101 Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        -------------------------------------------------------------------------------------
        -- Load ERP Customer Data
        -------------------------------------------------------------------------------------
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.erp_cust_az12;  

        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\DataEngineering\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'erp_cust_az12 Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        -------------------------------------------------------------------------------------
        -- Load Product Category Data
        -------------------------------------------------------------------------------------
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;  

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\DataEngineering\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'erp_px_cat_g1v2 Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        -------------------------------------------------------------------------------------
        -- STEP 3: End of Batch
        -------------------------------------------------------------------------------------
        SET @batch_end_time = GETDATE();

        PRINT 'Loading Bronze Layer Completed';
        PRINT 'Total Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';


    END TRY

    -----------------------------------------------------------------------------------------
    -- ERROR HANDLING
    -----------------------------------------------------------------------------------------
    BEGIN CATCH
        
        PRINT 'Error occurred during Bronze Layer loading';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);

    END CATCH

END;
GO

EXEC bronze.load_bronze;
