BAI TAP 01
with yearly_spend_cte as (
select
    extract(year from transaction_date) as year,
    product_id,
    spend as current_year_spend,
    lag(spend) over (partition by product_id order by product_id, 
    extract(year from transaction_date)) as previous_year_spend from user_transactions)
select year,
  product_id, 
  current_year_spend, 
  previous_year_spend, 
  round(100 * (current_year_spend - previous_year_spend)/ previous_year_spend, 2) as yoy_rate 
from yearly_spend_cte;

BAI TAP 02
with card_launch_cte as (select card_name, issued_amount,
rank() over(partition by card_name order by issue_year, issue_month)
as issue_date
from monthly_cards_issued)
select  card_name, 
  issued_amount
  from card_launch_cte
  where issue_date = 1
  order by issued_amount desc;

BAI TAP 03
with cte as(select*,
row_number() over(PARTITION BY user_id
order by transaction_date) as tran_num
from transactions)
select user_id, spend, transaction_date
from cte where tran_num = 3;

BAI TAP 04
with cte as(select
transaction_date,user_id,count(1) as purchase_count,
dense_rank() over(partition BY user_id order by transaction_date desc) as rank from user_transactions
group by transaction_date,user_id
order by user_id)
select transaction_date,user_id,purchase_count from CTE 
where rank = 1
order by transaction_date;

BAI TAP 05
select t1.user_id, t1.tweet_date,
    ROUND(AVG(t2.tweet_count), 2) as rolling_avg
from tweets as t1
join tweets as t2 on t1.user_id = t2.user_id
and t2.tweet_date between t1.tweet_date - INTERVAL '2 days' and t1.tweet_date
group by t1.user_id, t1.tweet_date
order by t1.user_id, t1.tweet_date;

BAI TAP 06
with identical_transaction_cte as (select transaction_id, merchant_id, credit_card_id, amount, 
transaction_timestamp as current_transaction,
lag(transaction_timestamp) over(partition by merchant_id, credit_card_id, amount order by transaction_timestamp) as previous_transaction
from transactions)
select count(merchant_id) as payment_count
from identical_transaction_cte
where current_transaction-previous_transaction <= INTERVAL '10 minutes'
BAI TAP 07
with cte as(select category, product, sum(spend) as total_spend,
rank() over(partition by category order by sum(spend) desc) as ranking from product_spend
where extract(year from transaction_date) = 2022
group by category, product)
select category, product, total_spend from cte 
where ranking <= 2

BAI TAP 08
with top_artists_cte as (select artist_name,
count(*) as no_appearance
from artists as a
join songs as b on b.artist_id = a.artist_id
join global_song_rank as c on c.song_id = b.song_id
where c.rank < 11
group by artist_name)
select artist_name, artist_rank from(
select artist_name,
dense_rank() over(order by no_appearance desc) as artist_rank
from top_artists_cte) as top
where artist_rank < 6
