{{
  config(
    materialized='view'
  )
}}

SELECT 
pv_by_product.product_name,
(order_by_product.total_sessions_with_order::numeric/NULLIF(pv_by_product.total_sessions::numeric,0))::numeric AS product_conversion_rate
FROM {{ ref('int_pageview_sessions_by_product_agg') }} AS pv_by_product
LEFT JOIN {{ ref('int_checkout_sessions_by_product_agg') }} AS order_by_product 
ON pv_by_product.product_name = order_by_product.order_item

