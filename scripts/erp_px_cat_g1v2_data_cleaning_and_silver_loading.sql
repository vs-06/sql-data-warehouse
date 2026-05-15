SELECT
id,
cat,
subcat,
maintenance
FROM dw_bronze.erp_px_cat_g1v2;

-- Checking for unwantyed spaces
-- Expected Output: No Results
SELECT *
FROM dw_bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Data Standardization and Consistency Check
SELECT DISTINCT subcat
FROM dw_bronze.erp_px_cat_g1v2;

-- NOTE: This Table have a very good data quality, so no need to clean or do any transformations

-- Insertion in to silver table
INSERT INTO dw_silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintenance
)
SELECT
id,
cat,
subcat,
maintenance
FROM dw_bronze.erp_px_cat_g1v2;

-- Checking the insertion
SELECT *
FROM dw_silver.erp_px_cat_g1v2;