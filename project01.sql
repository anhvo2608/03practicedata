-- QUESTION 01
select * from SALES_DATASET_RFM_PRJ
alter table SALES_DATASET_RFM_PRJ
alter column priceeach type numeric using(trim(priceeach)::numeric);

-- Question 2
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
  ORDERNUMBER IS NULL OR ORDERNUMBER = '';
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
  QUANTITYORDERED IS NULL OR QUANTITYORDERED = '';
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
  PRICEEACH IS NULL OR PRICEEACH = '';
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
  ORDERLINENUMBER IS NULL OR ORDERLINENUMBER = '';
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
  SALES IS NULL OR SALES = '';
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
  ORDERDATE IS NULL OR ORDERDATE = '';
  
-- QUESTION 03
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD CONTACTLASTNAME VARCHAR(255),
ADD CONTACTFIRSTNAME VARCHAR(255);

UPDATE sales_dataset_rfm_prj
SET contactfirstname = UPPER(LEFT(contactfullname,1))||
LOWER(SUBSTRING(contactfullname,2,POSITION('-' IN contactfullname)-2))

UPDATE sales_dataset_rfm_prj
SET contactlastname = UPPER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1,1))||
LOWER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+2,LENGTH(contactfullname)))

-- QUESTION 04
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD column QTR_ID numeric(10)
ALTER TABLE sales_dataset_rfm_prj
ADD column MONTH_ID numeric(10)
ALTER TABLE sales_dataset_rfm_prj
ADD column YEAR_ID numeric(10)  

ALTER TABLE sales_dataset_rfm_prj
ADD column new_orderdate timestamp;
  
UPDATE sales_dataset_rfm_prj
SET new_orderdate = to_date(orderdate,'dd/mm/yyyy HH24:MI:SS');

-- update dữ liệu vào cột QTR_ID, MONTH_ID, YEAR_ID từ cột new_orderdate

UPDATE sales_dataset_rfm_prj
SET qtr_id = EXTRACT(quarter from new_orderdate) ;

UPDATE sales_dataset_rfm_prj
SET month_id = EXTRACT(month from new_orderdate) ;

UPDATE sales_dataset_rfm_prj
SET year_id = EXTRACT(year from new_orderdate) ;

-- QUESTION 05
WITH cte AS (
SELECT Q1-1.5*IQR as min_value, Q3+1.5*IQR as max_value
FROM (
 SELECT 
percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) as Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered)-
percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as IQR
FROM sales_dataset_rfm_prj 
 ) as a )
SELECT * FROM sales_dataset_rfm_prj 
WHERE quantityordered < (SELECT min_value FROM cte )
OR quantityordered > (SELECT max_value FROM cte )

-- CÁCH 2 - sử dụng Z-score
WITH cte AS(
SELECT orderdate,
quantityordered,
(SELECT AVG(quantityordered)
FROM sales_dataset_rfm_prj) as avg,
(SELECT stddev(quantityordered)
FROM sales_dataset_rfm_prj ) as stddev
FROM sales_dataset_rfm_prj )

SELECT orderdate, quantityordered, (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev) >3

P2: XỬ LÝ OUTLIER
-- XÓA
  --với lệnh DELETE ko nên chạy trước khi bài được review--> xóa sau vậy


-- THAY THẾ BẰNG GIÁ TRỊ TRUNG BÌNH
WITH cte AS(
SELECT orderdate,
quantityordered,
(SELECT AVG(quantityordered)
FROM sales_dataset_rfm_prj) as avg,
(SELECT stddev(quantityordered)
FROM sales_dataset_rfm_prj ) as stddev
FROM sales_dataset_rfm_prj ),

cte_outliner as (
SELECT orderdate, quantityordered, (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev) >3)

UPDATE sales_dataset_rfm_prj
SET quantityordered = (SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj)
WHERE quantityordered IN (SELECT quantityordered FROM cte_outliner)

-- QUESTION 06 
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT *
FROM SALES_DATASET_RFM_PRJ;
