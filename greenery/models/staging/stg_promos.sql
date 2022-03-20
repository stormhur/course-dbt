{{
  config(
    materialized='table'
  )
}}

SELECT 
    LOWER(promo_id) AS promo_id,
    discount AS price_discount_in_usd,
    status
FROM {{ source('tutorial', 'promos') }}
