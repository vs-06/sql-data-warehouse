-- Quality Checks
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT
prd_id,
COunt(*)
FROM dw_silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT prd_nm
FROM dw_silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Numbers
-- Expectations: No Results
SELECT prd_cost
FROM dw_silver.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL;

-- Data Standardization and Consistency
SELECT DISTINCT prd_line
FROM dw_silver.crm_prd_info;

-- Check for Invalid Date Orders
-- Expectations: No Results
SELECT *
FROM dw_silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Final Look
SELECT *
FROM dw_silver.crm_prd_info