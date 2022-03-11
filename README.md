# Analytics engineering with dbt

Template repository for the projects and environment of the course: Analytics engineering with dbt

> Please note that this sets some environment variables so if you create some new terminals please load them again.

## License

Apache 2.0

Project 1 Answers:

How many users do we have? **130.**
```
select 
  count(distinct user_id) as total_users
from dbt_storm_h.stg_users
```

On average, how many orders do we receive per hour? **15**
```
select
  ROUND(count(distinct order_id)
    /count(distinct(extract(hour from created_at_utc))),2) 
      as n_orders_per_hour
from dbt_storm_h.stg_orders
```

On average, how long does an order take from being placed to being delivered? **3 days, 21 hours, 24 minutes, and 11 seconds.**
```
select
  avg(delivered_at_utc-created_at_utc)
from dbt_storm_h.stg_orders
where delivered_at_utc is not null
```

How many users have only made one purchase? Two purchases? Three+ purchases? **25 users made 1 purchase, 28 made 2, 71 made 3+.**
```
select 
  case 
    when n_purchases = 1 then '1'
    when n_purchases = 2 then '2' 
    else '3_or_more' 
      end as total_purchases_bin,
  count(distinct user_id) as total_users
from 
  (
  select
    user_id,
    count(distinct order_id) as n_purchases
  from dbt_storm_h.stg_orders
  group by 1
  having count(distinct order_id) > 0
  ) x
group by 1
```

On average, how many unique sessions do we have per hour? **39.**
```
select 
  round(avg(sessions),0) as avg_sessions_per_hour
from 
(
  select 
    extract(hour from created_at_utc) as hour_of_day,
    count(distinct session_id) as sessions
    from dbt_storm_h.stg_events
  group by 1
) x
```
