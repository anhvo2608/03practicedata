BAI TAP 01
with cte as 
(select *, 
row_number() over (partition by customer_id order by order_date) as customer
, (case when order_date = customer_pref_delivery_date then 1.0 else 0 end) as 'immediate'
from Delivery)
select round(100*sum(immediate)/count(immediate),2) as 'immediate_percentage'
from cte
where customer = 1

BAI TAP 02
with cte as
(select player_id,
event_date,
lead(event_date) over (partition by player_id order by event_date)next_date,
dense_rank() over (partition by player_id order by event_date) as k from activity)
select round(sum(case when datediff(next_date,event_date) = 1 then 1 else 0 end)/count(distinct player_id),2) as f
from cte where k = 1

BAI TAP 03
select
case when mod(id,2)=0 then id-1
when mod(id,2)=1 and id+1 not in (select id from seat) then id
else id+1 end as id, student from seat 
order by id

BAI TAP 04
with cte as (select visited_on,
sum(amount) as total from Customer
group by visited_on)
select visited_on, amount, average_amount
from (select visited_on,
sum(total) over(order by visited_on rows between 6 preceding and current row) as amount,
round(avg(total) over(order by visited_on ASC rows between 6 preceding and current row), 2) as average_amount from cte) as t
where DATE_SUB(visited_on, INTERVAL 6 DAY) IN (SELECT visited_on from cte)
order by visited_on
  
BAI TAP 05
with cte as
(select pid, TIV_2015, TIV_2016, 
count(concat(lat, lon)) over (partition by concat(lat, lon))as t1, 
count(TIV_2015) over(partition by tiv_2015) as t
from Insurance)
select sum(TIV_2016) as TIV_2016 from cte where t1 = 1 and t != 1
  
BAI TAP 06 
with cte as 
(select d.name as 'Department', b.name as 'Employee', b.salary as Salary,
dense_rank() over (partition by d.name order by b.salary desc) as Ranking
from employee as b
left join department as d on b.departmentid = d.id)
select Department, Employee, Salary from cte where Ranking between 1 and 3;
  
BAI TAP 07
with cte as (select person_name,weight,turn,
sum(weight) over (order by turn) as total from Queue)
select person_name from cte
where total <= 1000
order by total desc
limit 1;

BAI TAP 08
with cte as
(select distinct product_id, MAX(change_date) over (PARTITION BY product_id) last_day from Products
where change_date<='2019-08-16' )
select cte.product_id, p.new_price price from cte
join Products as p on cte.product_id=p.product_id and cte.last_day=p.change_date
union
select product_id, 10 price from Products
where product_id not in (select product_id from cte)
