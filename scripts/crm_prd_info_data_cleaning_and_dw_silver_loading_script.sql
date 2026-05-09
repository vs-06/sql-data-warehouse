/* Check for NULLS --> Resulting 0 records, so no duplicates */
SELECT
prd_id,
COUNT(*)
FROM dw_bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

/* TRANSFORMATION - Deriving Sub Columns to relate the table to erp_px_cat_g1v2 table */
SELECT prd_id,
prd_key, 
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM dw_bronze.crm_prd_info;

/* Filtering out unmatched data in erp_px_cat_g1v2 table after applying transformation to the current data) --> Only CO_PE is not matching */
SELECT prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM dw_bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5), '-', '_') NOT IN (
	SELECT DISTINCT id FROM dw_bronze.erp_px_cat_g1v2);
    
/* Check for unwanted spaces --> Resulted in 0 records*/
SELECT prd_nm
FROM dw_bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

/* Check for negative values and nulls --> Resulted in 0 records*/
SELECT prd_cost
FROM dw_bronze.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL;

SELECT prd_id, prd_cost
FROM dw_bronze.crm_prd_info
WHERE prd_id = 210;

/* Replacing NULL values in prd_cost column with 0's) */
SELECT prd_id,
prd_key, 
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
IFNULL(prd_cost,0) AS prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM dw_bronze.crm_prd_info;

/* Checking for unique values in prd_line */

SELECT DISTINCT(prd_line)
FROM dw_bronze.crm_prd_info;

/* Data Standardization - Replacing abbrevations with full names */
SELECT prd_id,
prd_key, 
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
IFNULL(prd_cost,0) AS prd_cost,
/* As we are using the same function check for mapping, we can use "QUICK CASE MAPPING" instead of regular CASE Mapping to reduce the code*/
CASE UPPER(TRIM(prd_line))
	WHEN 'R' THEN 'Road'
    WHEN 'M' THEN 'Mountain'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'T' THEN 'Touring'
    ELSE 'n/a'
END AS prd_line,
prd_start_dt,
prd_end_dt
FROM dw_bronze.crm_prd_info;

/* Fixing the order dates logic (The Order End date should always be more than the start date and less than the next order start date of the same product
SOLUTION: Grab start date from next order and subtract it by 1 and paste it in the current order end date */
WITH base AS (
  SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
    SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key_clean,
    prd_nm,
    IFNULL(prd_cost,0) AS prd_cost,
    CASE UPPER(TRIM(prd_line))
      WHEN 'R' THEN 'Road'
      WHEN 'M' THEN 'Mountain'
      WHEN 'S' THEN 'Other Sales'
      WHEN 'T' THEN 'Touring'
      ELSE 'n/a'
    END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt
  FROM dw_bronze.crm_prd_info
)
SELECT 
  prd_id,
  prd_key_clean AS prd_key,
  cat_id,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt,
  DATE_SUB(LEAD(prd_start_dt) OVER(PARTITION BY prd_key_clean ORDER BY prd_start_dt), INTERVAL 1 DAY) AS prd_end_dt
FROM base;


/* Insertion in to the dw_silver.crm_prd_info table*/
INSERT INTO dw_silver.crm_prd_info(
  prd_id,
  prd_key,
  cat_id,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt,
  prd_end_dt
)WITH base AS (
  SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
    SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key_clean,
    prd_nm,
    IFNULL(prd_cost,0) AS prd_cost,
    CASE UPPER(TRIM(prd_line))
      WHEN 'R' THEN 'Road'
      WHEN 'M' THEN 'Mountain'
      WHEN 'S' THEN 'Other Sales'
      WHEN 'T' THEN 'Touring'
      ELSE 'n/a'
    END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt
  FROM dw_bronze.crm_prd_info
)
SELECT 
  prd_id,
  prd_key_clean AS prd_key,
  cat_id,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt,
  DATE_SUB(LEAD(prd_start_dt) OVER(PARTITION BY prd_key_clean ORDER BY prd_start_dt), INTERVAL 1 DAY) AS prd_end_dt
FROM base;
