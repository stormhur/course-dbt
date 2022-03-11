{{
  config(
    materialized='table'
  )
}}

SELECT 
    order_id,
    product_id,
    quantity AS total_order_items
FROM {{ source('tutorial', 'order_items') }}
