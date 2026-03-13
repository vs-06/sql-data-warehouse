/*
==========================
NOTE: MYSQL Engine wont allow Stored Procedures if there are LOAD DATA lines in the script.
==========================

DELIMITER //
CREATE PROCEDURE dw_bronze.load_dw_bronze()
BEGIN*/

CREATE TABLE dw_bronze.bronze_data_load_log(
	table_name VARCHAR(50),
    start_time DATETIME,
    end_time DATETIME,
    duration_sec INT
);

SELECT '---------- Truncating Table: dw_bronze.crm_cust_info ----------';
TRUNCATE TABLE dw_bronze.crm_cust_info;
SELECT '---------- dw_bronze.crm_cust_info Table Successfully Truncated ----------';

SELECT '---------- Loading data in to dw_bronze.crm_cust_info ----------';

SET @start_time = NOW();
LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_crm/cust_info.csv'
INTO TABLE dw_bronze.crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();
INSERT INTO dw_bronze.bronze_data_load_log
VALUES (
	'crm_cust_info',
    @start_time,
    @end_time,
    TIMESTAMPDIFF(SECOND,@start_time,@end_time)
);

SELECT '---------- Loading data in to dw_bronze.crm_cust_info ----------';

SET @row_count = (
	SELECT COUNT(*) AS crm_cust_info_count
	FROM dw_bronze.crm_cust_info
);

SET @load_duration = (
	SELECT duration_sec
	FROM dw_bronze.bronze_data_load_log
    ORDER BY end_time
    LIMIT 1
);

SELECT CONCAT ('---------- Loading completed in to dw_bronze.crm_cust_info .', @row_count, ' records are loaded.', ' Total Duration: ', @load_duration, ' secs. ----------') AS message;

SELECT '---------- Truncating Table: dw_bronze.crm_prd_info';
TRUNCATE TABLE dw_bronze.crm_prd_info;
SELECT '---------- dw_bronze.crm_prd_info Table Successfully Truncated ----------';

SELECT '---------- Loading Data in to dw_bronze.crm_prd_info ----------';
SET @start_time = NOW();
LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_crm/prd_info.csv'
INTO TABLE dw_bronze.crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @end_time = NOW();

INSERT INTO dw_bronze.bronze_data_load_log
VALUES(
	'dw_bronze.crm_prd_info',
	@start_time,
	@end_time,
	TIMESTAMPDIFF(SECOND,@start_time, @end_time)
);

SET @row_count =(
	SELECT COUNT(*)
	FROM dw_bronze.crm_prd_info
);

SET @load_duration = (
	SELECT duration_sec 
    FROM dw_bronze.bronze_data_load_log
    ORDER BY end_time
    LIMIT 1
);

SELECT CONCAT ('---------- Loading completed in to dw_bronze.crm_prd_info. ', @row_count, 'records are loaded.', ' Total Duration: ', @load_duration, ' secs. ----------') AS message;

TRUNCATE TABLE dw_bronze.crm_sales_details;

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_crm/sales_details.csv'
INTO TABLE dw_bronze.crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS crm_sales_details_count
FROM dw_bronze.crm_sales_details;


TRUNCATE TABLE dw_bronze.erp_cust_az12;

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE dw_bronze.erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS erp_cust_az12_count
FROM dw_bronze.erp_cust_az12;


TRUNCATE TABLE dw_bronze.erp_loc_a101;

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_erp/LOC_A101.csv'
INTO TABLE dw_bronze.erp_loc_a101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS erp_loc_a101_count
FROM dw_bronze.erp_loc_a101;


TRUNCATE TABLE dw_bronze.erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE '/Users/vamshisaini/Developer/Data Engineering/Projects/Data_Warehouse-Data_With_Baraa/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE dw_bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS erp_px_cat_g1v2_count
FROM dw_bronze.erp_px_cat_g1v2;
