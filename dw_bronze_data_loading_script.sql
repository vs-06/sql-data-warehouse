/*
==========================================================
NOTE:
MySQL engine will not allow Stored Procedures if
there are LOAD DATA lines in the script.
==========================================================

DELIMITER //
CREATE PROCEDURE dw_bronze.load_dw_bronze()
BEGIN
*/

DROP TABLE IF EXISTS dw_bronze.bronze_data_load_log;

CREATE TABLE dw_bronze.bronze_data_load_log (
    table_name   VARCHAR(100),
    start_time   DATETIME,
    end_time     DATETIME,
    row_count    INT,
    duration_sec INT
);

-- ==========================================================
-- 1. Load dw_bronze.crm_cust_info
-- ==========================================================
SELECT '---------- Truncating Table: dw_bronze.crm_cust_info ----------' AS message;
TRUNCATE TABLE dw_bronze.crm_cust_info;
SELECT '---------- dw_bronze.crm_cust_info table successfully truncated ----------' AS message;

SELECT '---------- Loading data into dw_bronze.crm_cust_info ----------' AS message;

SET @start_time = NOW();

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_crm/cust_info.csv'
INTO TABLE dw_bronze.crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SET @row_count = (
    SELECT COUNT(*)
    FROM dw_bronze.crm_cust_info
);

SET @duration_sec = TIMESTAMPDIFF(SECOND, @start_time, @end_time);

INSERT INTO dw_bronze.bronze_data_load_log (
    table_name,
    start_time,
    end_time,
    row_count,
    duration_sec
)
VALUES (
    'dw_bronze.crm_cust_info',
    @start_time,
    @end_time,
    @row_count,
    @duration_sec
);

SELECT CONCAT(
    '---------- Load completed for dw_bronze.crm_cust_info | ',
    'Start Time: ', @start_time,
    ' | End Time: ', @end_time,
    ' | Rows Loaded: ', @row_count,
    ' | Duration: ', @duration_sec, ' sec ----------'
) AS message;


-- ==========================================================
-- 2. Load dw_bronze.crm_prd_info
-- ==========================================================
SELECT '---------- Truncating Table: dw_bronze.crm_prd_info ----------' AS message;
TRUNCATE TABLE dw_bronze.crm_prd_info;
SELECT '---------- dw_bronze.crm_prd_info table successfully truncated ----------' AS message;

SELECT '---------- Loading data into dw_bronze.crm_prd_info ----------' AS message;

SET @start_time = NOW();

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_crm/prd_info.csv'
INTO TABLE dw_bronze.crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SET @row_count = (
    SELECT COUNT(*)
    FROM dw_bronze.crm_prd_info
);

SET @duration_sec = TIMESTAMPDIFF(SECOND, @start_time, @end_time);

INSERT INTO dw_bronze.bronze_data_load_log (
    table_name,
    start_time,
    end_time,
    row_count,
    duration_sec
)
VALUES (
    'dw_bronze.crm_prd_info',
    @start_time,
    @end_time,
    @row_count,
    @duration_sec
);

SELECT CONCAT(
    '---------- Load completed for dw_bronze.crm_prd_info | ',
    'Start Time: ', @start_time,
    ' | End Time: ', @end_time,
    ' | Rows Loaded: ', @row_count,
    ' | Duration: ', @duration_sec, ' sec ----------'
) AS message;


-- ==========================================================
-- 3. Load dw_bronze.crm_sales_details
-- ==========================================================
SELECT '---------- Truncating Table: dw_bronze.crm_sales_details ----------' AS message;
TRUNCATE TABLE dw_bronze.crm_sales_details;
SELECT '---------- dw_bronze.crm_sales_details table successfully truncated ----------' AS message;

SELECT '---------- Loading data into dw_bronze.crm_sales_details ----------' AS message;

SET @start_time = NOW();

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_crm/sales_details.csv'
INTO TABLE dw_bronze.crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SET @row_count = (
    SELECT COUNT(*)
    FROM dw_bronze.crm_sales_details
);

SET @duration_sec = TIMESTAMPDIFF(SECOND, @start_time, @end_time);

INSERT INTO dw_bronze.bronze_data_load_log (
    table_name,
    start_time,
    end_time,
    row_count,
    duration_sec
)
VALUES (
    'dw_bronze.crm_sales_details',
    @start_time,
    @end_time,
    @row_count,
    @duration_sec
);

SELECT CONCAT(
    '---------- Load completed for dw_bronze.crm_sales_details | ',
    'Start Time: ', @start_time,
    ' | End Time: ', @end_time,
    ' | Rows Loaded: ', @row_count,
    ' | Duration: ', @duration_sec, ' sec ----------'
) AS message;


-- ==========================================================
-- 4. Load dw_bronze.erp_cust_az12
-- ==========================================================
SELECT '---------- Truncating Table: dw_bronze.erp_cust_az12 ----------' AS message;
TRUNCATE TABLE dw_bronze.erp_cust_az12;
SELECT '---------- dw_bronze.erp_cust_az12 table successfully truncated ----------' AS message;

SELECT '---------- Loading data into dw_bronze.erp_cust_az12 ----------' AS message;

SET @start_time = NOW();

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE dw_bronze.erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SET @row_count = (
    SELECT COUNT(*)
    FROM dw_bronze.erp_cust_az12
);

SET @duration_sec = TIMESTAMPDIFF(SECOND, @start_time, @end_time);

INSERT INTO dw_bronze.bronze_data_load_log (
    table_name,
    start_time,
    end_time,
    row_count,
    duration_sec
)
VALUES (
    'dw_bronze.erp_cust_az12',
    @start_time,
    @end_time,
    @row_count,
    @duration_sec
);

SELECT CONCAT(
    '---------- Load completed for dw_bronze.erp_cust_az12 | ',
    'Start Time: ', @start_time,
    ' | End Time: ', @end_time,
    ' | Rows Loaded: ', @row_count,
    ' | Duration: ', @duration_sec, ' sec ----------'
) AS message;


-- ==========================================================
-- 5. Load dw_bronze.erp_loc_a101
-- ==========================================================
SELECT '---------- Truncating Table: dw_bronze.erp_loc_a101 ----------' AS message;
TRUNCATE TABLE dw_bronze.erp_loc_a101;
SELECT '---------- dw_bronze.erp_loc_a101 table successfully truncated ----------' AS message;

SELECT '---------- Loading data into dw_bronze.erp_loc_a101 ----------' AS message;

SET @start_time = NOW();

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_erp/LOC_A101.csv'
INTO TABLE dw_bronze.erp_loc_a101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SET @row_count = (
    SELECT COUNT(*)
    FROM dw_bronze.erp_loc_a101
);

SET @duration_sec = TIMESTAMPDIFF(SECOND, @start_time, @end_time);

INSERT INTO dw_bronze.bronze_data_load_log (
    table_name,
    start_time,
    end_time,
    row_count,
    duration_sec
)
VALUES (
    'dw_bronze.erp_loc_a101',
    @start_time,
    @end_time,
    @row_count,
    @duration_sec
);

SELECT CONCAT(
    '---------- Load completed for dw_bronze.erp_loc_a101 | ',
    'Start Time: ', @start_time,
    ' | End Time: ', @end_time,
    ' | Rows Loaded: ', @row_count,
    ' | Duration: ', @duration_sec, ' sec ----------'
) AS message;


-- ==========================================================
-- 6. Load dw_bronze.erp_px_cat_g1v2
-- ==========================================================
SELECT '---------- Truncating Table: dw_bronze.erp_px_cat_g1v2 ----------' AS message;
TRUNCATE TABLE dw_bronze.erp_px_cat_g1v2;
SELECT '---------- dw_bronze.erp_px_cat_g1v2 table successfully truncated ----------' AS message;

SELECT '---------- Loading data into dw_bronze.erp_px_cat_g1v2 ----------' AS message;

SET @start_time = NOW();

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE dw_bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SET @row_count = (
    SELECT COUNT(*)
    FROM dw_bronze.erp_px_cat_g1v2
);

SET @duration_sec = TIMESTAMPDIFF(SECOND, @start_time, @end_time);

INSERT INTO dw_bronze.bronze_data_load_log (
    table_name,
    start_time,
    end_time,
    row_count,
    duration_sec
)
VALUES (
    'dw_bronze.erp_px_cat_g1v2',
    @start_time,
    @end_time,
    @row_count,
    @duration_sec
);

SELECT CONCAT(
    '---------- Load completed for dw_bronze.erp_px_cat_g1v2 | ',
    'Start Time: ', @start_time,
    ' | End Time: ', @end_time,
    ' | Rows Loaded: ', @row_count,
    ' | Duration: ', @duration_sec, ' sec ----------'
) AS message;


-- ==========================================================
-- Final log output
-- ==========================================================
SELECT *
FROM dw_bronze.bronze_data_load_log
ORDER BY start_time;

/*
END //
DELIMITER ;
*/