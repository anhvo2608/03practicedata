BAI TAP 01
SELECT country.continent, FLOOR(AVG(city.population))FROM COUNTRY
LEFT JOIN CITY ON (CITY.CountryCode = COUNTRY.Code) 
WHERE city.population is not NULL 
GROUP BY country.continent

BAI TAP 02
  SELECT
ROUND(SUM(CASE WHEN SIGNUP_ACTION = 'Confirmed' 
THEN 1 ELSE 0 
END)*1.0/COUNT(*),2)
FROM EMAILS AS A
inner JOIN TEXTS AS B
ON A.EMAIL_ID = B.EMAIL_ID;

BAI TAP 03
with cte as 
(SELECT B.age_bucket,
sum(case when activity_type = 'open' then time_spent else 0 end) as t_o,
sum(case when activity_type = 'spend' then time_spent else 0 end) as t_s
from activities as A
left join age_breakdown as B on A.user_id = B.user_id
group by B.age_bucket)

select age_bucket, round(t_s/(t_s+t_o)
 * 100.0,2) as send_percentage, 
round(t_o/(t_s+t_o) * 100,2) as open_percentage
from cte;

BAI TAP 04
with cte AS
(select a.*, b.product_category
from customer_contracts a
left join products as b
on a.product_id = b.product_id)

select customer_id 
from cte 
group by customer_id
having count(distinct product_category)
= (select count(distinct product_category)
from products);

BAI TAP 05
with cte as 
(select reports_to, count(employee_id)
as reports_count,
round(avg(age),0) as average_age
from employees
where reports_to is Not null
group by reports_to)

select c.reports_to as employee_id,
e.name, c.reports_count, c.average_age
from cte AS C
left join employees as E
on c.reports_to = e.employee_id
order by employee_id;

BAI TAP 06
with cte AS
(select a.*, b.product_category
from customer_contracts a
left join products as b
on a.product_id = b.product_id)

select customer_id 
from cte 
group by customer_id
having count(distinct product_category)
= (select count(distinct product_category)
from products);

BAI TAP 06
select product_name, sum(unit)
from orders as A
left join products as B
on A. product_id = B.product_id
where order_date between 
'2020-02-02' and '2020-02-29'
group by B.product_id
having sum(unit) >= 100;

BAI TAP 07
SELECT a.page_id
FROM pages as a
LEFT JOIN page_likes as c
on a.page_id = c.page_id
WHERE c.page_id IS NULL
ORDER BY page_id ASC;
  
MID COURSE
QUESTION 1
select 
min(replacement_cost)
from film;

QUESTION 02
  C1:
SELECT
case
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
else 'high'
END AS category,
COUNT(*) AS so_luong
FROM film
GROUP BY category
  

QUESTION 03
SELECT
    film.title AS film_title,
    film.length AS film_length,
    category.name AS category_name
FROM film
LEFT JOIN film_category ON film.film_id = film_category.film_id
LEFT JOIN category ON film_category.category_id = category.category_id
WHERE category.name IN ('Drama', 'Sports')
ORDER BY film.length DESC
LIMIT 1;

QUESTION 04
SELECT c.name AS category_name, COUNT(film.film_id) AS film_count
FROM public.category c
LEFT JOIN film_category b ON c.category_id = b.category_id
LEFT JOIN film ON b.film_id = film.film_id
GROUP BY c.category_id, c.name
ORDER BY film_count DESC
LIMIT 1;

QUESTION 05 
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name, 
    COUNT(fa.film_id) AS film_count
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actor_name
ORDER BY film_count DESC
LIMIT 1;

QUESTION 6 
SELECT a.address_id, a.address
FROM address a
LEFT JOIN customer b ON a.address_id = b.address_id
WHERE a.address_id IS NULL;

QUESTION 7
select a.city, 
sum(d.amount) as total_amount
from city as a
join public.address as b on a.city_id = b.city_id
join public.customer as c on c.address_id = b.address_id
join public.payment as d on d.customer_id = c.customer_id
GROUP BY a.city_id
ORDER BY sum(d.amount) DESC
LIMIT 1;

QUESTION 8 
select
    CONCAT(a.city, ' , ', e.country) AS city_country,
    SUM(d.amount) AS total_amount
from public.city as a
join public.address as b on a.city_id = b.city_id
join public.customer as c on c.address_id = b.address_id
join public.payment as d on d.customer_id = c.customer_id
join public.country as e ON a.country_id = e.country_id
group by city_country
order by SUM(d.amount)
LIMIT 1;
