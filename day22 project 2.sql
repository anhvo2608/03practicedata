--- III. Tạo metric trước khi dựng dashboard

CREATE VIEW vw_ecommerce_analyst AS
with cte as (
  select * from (select date('%Y-%m', date(b.created_at)) as month_year,
  extract(year from b.created_at),
  c.category,
  sum(b.sale_price) over(partition by c.category order by date('%Y-%m', date(b.created_at))) as s,
  count(order_id) over (partition by c.category order by date('%Y-%m', date(b.created_at))) as cou,
  date('%Y-%m', date_add(date (a.created_at), interval 1 month)) as m,
  sum(b.cost) over(partition by c.category order by date('%Y-%m', date(b.created_at))) as cost,
  from bigquery-public-data.thelook_ecommerce.order_items as b
  join bigquery-public-data.thelook_ecommerce.products as c 
  on b.product_id = b.id
  where b.status = 'Complete')
group by 1,2,3,4,5,6,7)




-- COHORT ANALYSIS
with cte_1 as (
  select user_id, sale_price,
  date('%Y-%m', date(first_purchase_date)) as cohort_date,
  create_at,
  (extarct(year from created_at) - extract(year from first_purchase_date)) * 12 + (extract(
  month fromcreated_at) - extract(month from first_purchase_date)) + 1 as index
  from ( select user_id,sale_price,
  min(created_at) over(partition by user_id) as first_puchase_date, created_at
 from bigquery-public-data.thelook_ecommerce.order_items
 where status ='Complete') )
, cte_2 as(
  select cohort_date, index,
  count(distinct user_id) as id,
  sum(sale_price) as price,
  where index <= 4
  group by 1,2
  order by cohort_date
, cte_3 as
  select cohort_date,
  sum(case when index =1 then id else 0 end) as c1,
  sum(case when index = 2 then id else 0 end) as c2,
  sum(case when index = 3 then id else 0 end) as c3,
  sum(case when index = 4 then id else 0 end) as c4
  from cte_2
  group by cohort_date
  order by cohort_date)

--- retention cohort
,retention_cohort as ( select cohort_date,
  round(100.00 * c1/c1,2)||'%' c1,
  round(100.00 * c2/c1,2)||'%' c2,
  round(100.00 * c3/c1,2)||'%' c3,
  round(100.00 * c4/c1,2)||'%' c4
from cte_3)
  
