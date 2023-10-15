BAI TAP 01
SELECT NAME FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT((NAME),3) , ID ASC;

BAI TAP 02
SELECT 
user_id, 
concat(UPPER(left(name, 1)), LOWER(right(name,length(name) -1))) AS NAME
FROM USERS
order by user_id;

BAI TAP 03
SELECT manufacturer,
concat('$',round(sum(total_sales)/1000000), 'million') as sale
from pharmacy_sales
GROUP BY manufacturer
order by sum(total_sales) desc, manufacturer;

BAI TAP 04
SELECT
EXTRACT(MONTH FROM SUBMIT_DATE) AS MTH,
PRODUCT_ID,
ROUND(AVG(STARS),2) AS AVG_STARS
FROM REVIEWS
GROUP BY EXTRACT(MONTH FROM SUBMIT_DATE), PRODUCT_ID
ORDER BY MTH, PRODUCT_ID;

BAI TAP 05
SELECT 
COUNT(MESSAGE_ID) AS COUNT_MESSAGES
FROM MESSAGES
where sent_date >= '08/01/2022' and sent_date < '09/01/2022'
GROUP BY SENDER_ID
ORDER BY COUNT(MESSAGE_ID) DESC
LIMIT 2;

BAI TAP 06
select tweet_id from tweets
where LENGTH(CONTENT) > 15

BAI TAP 07
SELECT ACTIVITY_DATE AS DAY,
COUNT(DISTINCT USER_ID) AS ACTIVE_USERS
FROM ACTIVITY
GROUP BY ACTIVITY_DATE 
having activity_date between '2019-06-28' and '2019-07-27'

BAI TAP 08
SELECT first_name, last_name,
COUNT(*) AS "Number Of Employees Hired"
FROM Employees
group by (first_name, last_name);

BAI TAP 09
select first_name,
position('a' in first_name) from worker
where first_name = 'Amitah';

BAI TAP 10
select country,
substring (title,length(winery) +2, 4)
from winemag_p2
where country = 'Macedonia';
