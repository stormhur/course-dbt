{{
  config(
    materialized='view'
  )
}}


SELECT 
  promo_id AS active_promo_id,
  price_discount_in_usd AS active_price_discount_in_usd
FROM {{ ref('stg_promos') }} 
WHERE LOWER(status) = 'active'