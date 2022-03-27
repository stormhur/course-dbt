
{{
  config(
    materialized='view'
  )
}}

SELECT 
  order_item,
  COUNT(DISTINCT session_id) AS total_sessions_with_order
FROM {{ ref('int_checkout_sessions_by_product') }}
GROUP BY 1