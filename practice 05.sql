BAI TAP 01
select distinct city from station
where id % 2 = 0;

BAI TAP 02
select 
  count(city) - count(distinct city)
  from station;

BAI TAP 03
select 
ceiling(avg(salary) - avg(replace(salary,'0','')))
from employees;

BAI TAP 04
EM KHÔNG BIẾT LÀM MÀ HỎI C TRỢ GIẢNG CÓ GIẢI THÍCH NHƯNG VƯỢT TẦM CỦA EM
  DÙNG HÀM CAST?

BAI TAP 05
SELECT candidate_id FROM candidates
where skill IN ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(skill) = 3
order by candidate_id;

BAI TAP 06



BAI TAP 07
SELECT CARD_NAME, MAX(issued_amount) - MIN(issued_amount) 
FROM monthly_cards_issued
GROUP BY CARD_NAME
ORDER BY MAX(issued_amount) - MIN(issued_amount) DESC;

BAI TAP 08
SELECT MANUFACTURER,
COUNT(DRUG) AS DRUG_COUNT,
SUM(COGS - TOTAL_SALES) AS TOTAL_LOSS
FROM pharmacy_sales
where (cogs - total_sales) > 0
GROUP BY MANUFACTURER
ORDER BY 3 DESC;

BAI TAP 09
SELECT * FROM CINEMA
WHERE (ID%2=1) AND (DESCRIPTION <> 'BORING')
ORDER BY RATING DESC;

BAI TAP 10
SELECT TEACHER_ID, COUNT(DISTINCT SUBJECT_ID) AS CNT
FROM TEACHER
GROUP BY TEACHER_ID;

BÀI TAP 11
SELECT user_id, COUNT(follower_id) as followers_count from followers
GROUP BY user_id
ORDER BY USER_ID ASC;

BAI TAP 12
SELECT CLASS FROM COURSES
GROUP BY CLASS
HAVING COUNT(STUDENT)>=5;
