{{
  config(
    materialized='table'
  )
}}

SELECT 
    product_id,
    LOWER(name) AS product_name,
    price AS price_usd,
    inventory AS total_inventory
FROM {{ source('tutorial', 'products') }}
