1. ---- Số lượng đơn hàng và số lượng khách hàng mỗi tháng
SELECT EXTRACT(YEAR FROM CREATED_AT)||'-'|| EXTRACT(MONTH FROM CREATED_AT)
 AS month_year,
       COUNT(DISTINCT order_id) AS total_user,
       COUNT(*) AS total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE CREATED_AT BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY 1
ORDER BY 1;

2. ---- Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
SELECT
  EXTRACT(YEAR FROM CREATED_AT)||'-'|| EXTRACT(MONTH FROM CREATED_AT) AS month_year,
  COUNT(DISTINCT ORDER_ID) AS distinct_users,
  SUM(SALE_PRICE) / COUNT(*) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE CREATED_AT BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY 1
ORDER BY 1;

3. ---- Nhóm khách hàng theo độ tuổi
---- youngest
CREATE TEMP TABLE youngest_customers AS
SELECT first_name, last_name, gender, age, 'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users)
UNION ALL
SELECT first_name, last_name, gender, age, 'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users);

--- oldest
CREATE TEMP TABLE oldest_customers AS
SELECT first_name, last_name, gender, age, 'oldest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users)
UNION ALL
SELECT first_name, last_name, gender, age, 'oldest' AS tag
FROM your_table
WHERE age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users);

CREATE TEMP TABLE combined_results AS
SELECT * FROM youngest_customers
UNION ALL
SELECT * FROM oldest_customers;

SELECT tag, COUNT(*) AS count
FROM combined_results
GROUP BY tag;

4. ----- Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
with RankedProducts_cte as 
(select Extract(year from created_at) ||'-'|| Extract(month from created_at) as month_year, 
t.product_id,b.name as product_name,
sum(t.sale_price) as sales,
sum(b.cost) as cost,
sum(t.sale_price)-sum(b.cost) as profit,
from bigquery-public-data.thelook_ecommerce.order_items as t join bigquery-public-data.thelook_ecommerce.products as b
on t.product_id = b.id
where DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
group by 1,2,3)

select * from 
(select month_year, product_id, product_name, sales, cost, profit,
dense_rank() over(partition by month_year order by profit desc) as rank_per_month from RankedProducts_cte
order by month_year) as a
where rank_per_month <=5

5. ---- Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
SELECT * FROM (
SELECT DATE(o.created_at) as dates ,
oi.category as product_categories,
SUM(o.sale_price) OVER (PARTITION BY oi.category ORDER BY DATE(o.created_at)) as revenue
FROM bigquery-public-data.thelook_ecommerce.order_items as o
LEFT JOIN bigquery-public-data.thelook_ecommerce.products as oi ON o.product_id = oi.id
GROUP BY dates, product_categories, revenue
ORDER BY dates;


