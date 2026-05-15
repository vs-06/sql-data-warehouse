SELECT
cid,
cntry
FROM dw_bronze.erp_loc_a101;

-- Cleaning the cid (by removing the "-" in between the characters so that the id can be used to relate it to the crm_cust_info table
SELECT cid,
REPLACE(cid, '-', '') AS cid_new
FROM dw_bronze.erp_loc_a101;

-- Data Standardization and Consistency (cntry column)
SELECT DISTINCT cntry
FROM dw_bronze.erp_loc_a101;

SELECT DISTINCT cntry,
CASE
	WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
    WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
    WHEN UPPER(TRIM(cntry)) IS NULL OR UPPER(TRIM(cntry)) = '' THEN 'n/a'
    ELSE TRIM(cntry)
END AS cntry_new
FROM dw_bronze.erp_loc_a101;

-- Loading in top Silver Table
INSERT INTO dw_silver.erp_loc_a101(
	cid,
    cntry
)
SELECT
REPLACE(cid, '-', '') AS cid,
CASE
	WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
    WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
    WHEN UPPER(TRIM(cntry)) IS NULL OR UPPER(TRIM(cntry)) = '' THEN 'n/a'
    ELSE TRIM(cntry)
END AS cntry
FROM dw_bronze.erp_loc_a101;

-- Checking the insertion
SELECT DISTINCT cntry
FROM dw_silver.erp_loc_a101;