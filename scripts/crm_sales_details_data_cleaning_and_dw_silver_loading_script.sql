-- Checking for unwanted spaces in sls_ord_num
-- Expectation: No results

SELECT
sls_cust_id,
sls_due_dt,
sls_order_dt,
sls_ord_num,
sls_prd_key,
sls_price,
sls_quantity,
sls_sales,
sls_ship_dt
FROM dw_bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

SELECT COUNT(*)
FROM dw_bronze.crm_sales_details;

-- Checking for sls_prd_key that are not in crm_prd_info
-- Expectation: No Results
SELECT *
FROM dw_bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM dw_silver.crm_prd_info);


-- Checking for sls_prd_key that are not in crm_prd_info
-- Expectation: No Results
SELECT *
FROM dw_bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM dw_silver.crm_cust_info);

-- Checking for invalid dates
-- 19 invalid rows returned, so we need to fix them.
SET @today = DATE(NOW());
SELECT 
NULLIF(sls_order_dt,0) sls_order_dt
FROM dw_bronze.crm_sales_details
WHERE sls_order_dt <=0 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101
OR LENGTH(sls_order_dt) !=8;

-- Converting integer date columns to DATE type
SELECT
sls_cust_id,
CASE 
	WHEN sls_order_dt <=0 OR LENGTH(sls_order_dt) != 8 THEN null
    ELSE CAST(sls_order_dt AS DATE)
END AS sls_order_dt,
CASE 
	WHEN sls_ship_dt <=0 OR LENGTH(sls_ship_dt) != 8 THEN null
    ELSE CAST(sls_ship_dt AS DATE)
END AS sls_ship_dt,
CASE 
	WHEN sls_due_dt <=0 OR LENGTH(sls_due_dt) != 8 THEN null
    ELSE CAST(sls_due_dt AS DATE)
END AS sls_due_dt,
sls_ord_num,
sls_prd_key,
sls_price,
sls_quantity,
sls_sales
FROM dw_bronze.crm_sales_details;

-- Check for invalid date orders ( Where order date is greater than shipping date and due date)
-- Expected Result: No Results
SELECT
sls_order_dt,
sls_ship_dt,
sls_due_dt
FROM dw_bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Business Rules Check
-- Conditions: 
-- 1. Sum of Sales must be equal to Quantity times Price
-- 2. No Negative, Zero, Null values are allowed.
-- Expected Result: No Results
-- Actual Result: 32 Bad rows returned
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM dw_bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price;


-- Fixing bad records in Business Rules check.
-- Rules to fix:
-- 1. If sales is negative, zero, or null, derive it using Quality and Price.
-- 2. If price is zero or null, calculate it using Sales and Quantity.
-- 3. If price is negative, convert it in to a positive value.

SELECT      
CASE 
	WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN ABS(sls_price) * sls_quantity
    ELSE sls_sales
END AS sls_sales,
CASE
    WHEN sls_price <=0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity,0)
    ELSE sls_price
END AS sls_price,
sls_quantity
FROM dw_bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <=0 OR sls_price <=0;

-- Insertion in to dw_silver.crm_sales_details
INSERT INTO dw_silver.crm_sales_details(
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE 
	WHEN sls_order_dt <=0 OR LENGTH(sls_order_dt) != 8 THEN null
    ELSE CAST(sls_order_dt AS DATE)
END AS sls_order_dt,
CASE 
	WHEN sls_ship_dt <=0 OR LENGTH(sls_ship_dt) != 8 THEN null
    ELSE CAST(sls_ship_dt AS DATE)
END AS sls_ship_dt,
CASE 
	WHEN sls_due_dt <=0 OR LENGTH(sls_due_dt) != 8 THEN null
    ELSE CAST(sls_due_dt AS DATE)
END AS sls_due_dt,
CASE 
	WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN ABS(sls_price) * sls_quantity
    ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE
    WHEN sls_price <=0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity,0)
    ELSE sls_price
END AS sls_price
FROM dw_bronze.crm_sales_details;
