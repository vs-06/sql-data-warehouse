/* TO CHECK IF THERE ANY DUPLICATE RECORDS */
USE dw_bronze;
SELECT cst_id, COUNT(*)
FROM dw_bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL;

/* TO RANK THE DUPLICATE RECORDS AND GET THE ONLY ONES THAT ARE RECENT AND IGNORING THE DUPLICATES */
SELECT *
FROM (
	SELECT *, 
	ROW_NUMBER() 
	OVER (
		PARTITION BY cst_id
		ORDER BY cst_create_date DESC )
	AS flag_last
	FROM dw_bronze.crm_cust_info)t
WHERE flag_last =1;

/* Checking for white spaces (CHECK FOR ALL COLUMNS BY REPLACING THE COLUMN NAME IN THE BELOW QUERY*/
SELECT cst_firstname
FROM dw_bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

/* Selecting records without duplicates in the primary key and without whitespaces in all columns. */

SELECT 
cst_id, 
cst_key, 
TRIM(cst_firstname) AS cst_fistname, 
TRIM(cst_lastname) AS cst_lastname, 
cst_marital_status, 
cst_gndr, 
cst_create_date
FROM (
	SELECT *,
    ROW_NUMBER()
    OVER(
		PARTITION BY cst_id
        ORDER BY cst_create_date DESC)
	AS flag_last
    FROM dw_bronze.crm_cust_info
    WHERE cst_id IS NOT NULL)t
WHERE flag_last = 1;

/* PREV STEPS + Data Normalization and Standardization for cst_gndr and cst_martial_status */

SELECT 
cst_id, 
cst_key,
CASE
	WHEN TRIM(cst_firstname) != cst_firstname AND cst_firstname IS NOT NULL THEN TRIM(cst_firstname)
    WHEN TRIM(cst_firstname) = cst_firstname AND cst_firstname IS NOT NULL THEN cst_firstname
    ELSE 'n/a'
END AS cst_firstname,
CASE
	WHEN TRIM(cst_lastname) != cst_lastname AND cst_lastname IS NOT NULL THEN TRIM(cst_lastname)
    WHEN TRIM(cst_lastname) = cst_lastname AND cst_lastname IS NOT NULL THEN cst_lastname
    ELSE 'n/a'
END AS cst_lastname,
CASE
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    ELSE 'n/a'
END AS cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM(
	SELECT *,
    ROW_NUMBER()
    OVER(
		PARTITION BY cst_id
        ORDER BY cst_create_date DESC)
	AS flag_last
    FROM dw_bronze.crm_cust_info
    WHERE cst_id IS NOT NULL)t
WHERE flag_last = 1;

/* DELETING SOME INCONSISTENT DATA
DELETE 
FROM dw_bronze.crm_cust_info
WHERE cst_id = 0 
LIMIT 1000;
*/

/* INSERTION OF RECORDS IN TO SILVER TABLE */
INSERT INTO dw_silver.crm_cust_info(
	cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date)
SELECT 
cst_id, 
cst_key,
CASE
	WHEN TRIM(cst_firstname) != cst_firstname AND cst_firstname IS NOT NULL THEN TRIM(cst_firstname)
    WHEN TRIM(cst_firstname) = cst_firstname AND cst_firstname IS NOT NULL THEN cst_firstname
    ELSE 'n/a'
END AS cst_firstname,
CASE
	WHEN TRIM(cst_lastname) != cst_lastname AND cst_lastname IS NOT NULL THEN TRIM(cst_lastname)
    WHEN TRIM(cst_lastname) = cst_lastname AND cst_lastname IS NOT NULL THEN cst_lastname
    ELSE 'n/a'
END AS cst_lastname,
CASE
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    ELSE 'n/a'
END AS cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM(
	SELECT *,
    ROW_NUMBER()
    OVER(
		PARTITION BY cst_id
        ORDER BY cst_create_date DESC)
	AS flag_last
    FROM dw_bronze.crm_cust_info
    WHERE cst_id IS NOT NULL)t
WHERE flag_last = 1;


SELECT *
FROM dw_silver.crm_cust_info;