{{
  config(
    materialized='table'
  )
}}

SELECT 
    promo_id,
    discount AS price_discount_rate,
    status
FROM {{ source('tutorial', 'promos') }}
