BAI TAP 01
SELECT
 SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
 SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership;

BAI TAP 02
select
case 
    when ((x+y) > z and (y+z) > x and (z+x) > y) then 'Yes' 
    else 'No' 
end as triangle 
from Triangle;

BAI TAP 03
SELECT
    ROUND(SUM(CASE 
      WHEN call_category = 'N/A' THEN 1 
      WHEN call_category is NULL THEN 1
      ELSE 0
    END), 1)
FROM callers;

BAI TAP 04
SELECT NAME FROM CUSTOMER
WHERE REFEREE_ID <> 2 OR REFEREE_ID IS NULL ;
 
BAI TP 05
select 
CASE
    WHEN PCLASS = 1 THEN 'FIRST_CLASS'
    WHEN PCLASS = 2 THEN 'SECOND_CLASS'
    ELSE 'THIRD_CLASS'
END 
from titanic;
