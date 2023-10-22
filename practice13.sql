BAI TAP 01
with job_count_cte AS (
select
    company_id,
    title,
    description,
    count(job_id) AS job_count
  from job_listings
  group by company_id, title, description)
select count(distinct company_id) 
from job_count_cte
where job_count > 1;

BAI TAP 02

BAI TAP 03
with call_records_cte as 
(select policy_holder_id,
count(case_id) as call_count
from callers
group by policy_holder_id
having count(case_id) >= 3 )
select count (policy_holder_id) as member_count
FROM call_records_cte;

BAI TAP 04
select b.page_id from pages as b 
left join page_likes as l on  b.page_id = l.page_id
group by b.page_id
having count(l.page_id) = 0;

BAI TAP 05
with cte as 
(select  user_id	
from user_actions 
where extract(month from event_date) in (6,7) 
and extract(year from event_date) = 2022 
group by user_id 
having count(distinct extract(month from event_date)) = 2)
SELECT 7 as month_ , count(*) as number_of_user 
from cte
  
BAI TAP 06
select 
left(trans_date, 7) as month,
country, 
count(id) as trans_count,
sum(state = 'approved') as approved_count,
sum(amount) as trans_total_amount,
sum(if (state = 'approved', amount, 0)) as approved_total_amount
from transactions
group by left(trans_date, 7), country
  
BAI TAP 07
select product_id, year as first_year, quantity,price from Sales
where (product_id,year) in (select product_id,MIN(year) from Sales
group by product_id)
  
BAI TAP 08
select customer_id from customer
group by customer_id
having count(distinct product_key)=(select count(distinct product_key) from product)
  
BAI TAP 09 
select employee_id from Employees as a
where manager_id not in (select employee_id from employees) and salary < 30000
order by employee_id;

BAI TAP 10
with job_count_cte as (
select company_id, title, description,
count(job_id) as job_count from job_listings
group by company_id, title, description)
select count(distinct company_id) from job_count_cte
where job_count > 1;

BAI TAP 11
 with table_1_cte as 
(select name
from MovieRating as m inner join Users as u
on m.user_id = u.user_id
group by m.user_id
order by count(*) desc, name
limit 1),

table_2_cte as (select title
from MovieRating m inner join 
Movies mm on m.movie_id = mm.movie_id
where left(created_at,7) = '2020-02'
group by m.movie_id
order by avg(rating) desc, title
limit 1)

select table_1_cte.name as results
from table_1_cte union all
select table_2_cte.title as results
from table_2_cte
  
BAI TAP 12
select id, count(id) from 
    (select requester_id AS id from RequestAccepted
  union all select accepter_id as id from  RequestAccepted)
group by id
order by count(id) DESC
limit 1;
