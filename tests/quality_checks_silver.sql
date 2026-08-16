--Check for nulls or duplicates in primary key
-- Expectation: No result

SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--Check unwanted spaces
-- Expectation: No result

SELECT prd_nm
from silver.crm_prd_info
where prd_nm != TRIM(prd_nm)

--Check nulls or nagative numbers
-- Expectation: No result
SELECT prd_cost
from silver.crm_prd_info
where prd_cost < 0 OR prd_cost IS NULL
-- Data standardization & consistancy 
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

--Check invalid date orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt

--Check for invalid dates
SELECT 
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 --Negative numbers ore zeros can't be cast to a date

SELECT * FROM 
bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt>sls_due_dt

--Check data consistancy,NULL or zero values
-->> Sales = Quatity * price
-->> Values must not be NULL,zero, or negative

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	  THEN sls_quantity * ABS(sls_price)
	  ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0 
	 THEN sls_price / NULLIF(sls_quantity, 0)
	 ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details

--check table erp_cust_az12
SELECT * FROM bronze.erp_cust_az12
SELECT * FROM silver.crm_cust_info

SELECT 
cid,
CASE  WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	  ELSE cid
END AS cid,
bdate,
gen
FROM bronze.erp_cust_az12 
WHERE cid NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

SELECT bdate from silver.erp_cust_az12 where bdate <= '1926-01-01' or bdate >= GETDATE()

SELECT DISTINCT gen from silver.erp_cust_az12 
--Check bronze.erp_loc_a101
SELECT DISTINCT cntry FROM silver.erp_loc_a101
-- Check erp_px_cat_g1v2 
SELECT id from bronze.erp_px_cat_g1v2
WHERE id  NOT IN (SELECT cat_id FROM silver.crm_prd_info )

SELECT 
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) or subcat != TRIM(subcat) or maintenance != TRIM(maintenance) --check unwanted spaces

SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2 --data standarzation 
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2

