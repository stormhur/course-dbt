{{
  config(
    materialized='view'
  )
}}

SELECT
  user_id, 
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT 
    CASE WHEN estimated_delivery_performance IS NULL 
      THEN order_id ELSE NULL END) AS total_pending_orders,
  COUNT(DISTINCT 
    CASE WHEN estimated_delivery_performance = 'later_than_estimated' 
      THEN order_id ELSE NULL END) AS total_late_delivered_orders,
  COUNT(DISTINCT 
    CASE WHEN estimated_delivery_performance = 'as_estimated' 
      THEN order_id ELSE NULL END) AS total_as_estimated_orders,
  COUNT(DISTINCT 
    CASE WHEN estimated_delivery_performance = 'earlier_than_estimated' 
      THEN order_id ELSE NULL END) AS total_earlier_than_estimated_orders,
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 1 AND total_order_items <= 2)
      THEN order_id ELSE NULL END) AS total_small_orders,
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 3 AND total_order_items <= 5)
      THEN order_id ELSE NULL END) AS total_medium_orders,
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 6 AND total_order_items <= 10)
      THEN order_id ELSE NULL END) AS total_large_orders,
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 11)
      THEN order_id ELSE NULL END) AS total_extra_large_orders,
  COUNT(DISTINCT 
    CASE WHEN shipping_service = 'ups'
      THEN order_id ELSE NULL END) AS total_ups_orders,
  COUNT(DISTINCT 
    CASE WHEN shipping_service = 'fedex'
      THEN order_id ELSE NULL END) AS total_fedex_orders,
  COUNT(DISTINCT 
    CASE WHEN shipping_service = 'usps'
      THEN order_id ELSE NULL END) AS total_usps_orders,
  COUNT(DISTINCT 
    CASE WHEN shipping_service = 'dhl'
      THEN order_id ELSE NULL END) AS total_dhl_orders,
  COUNT(DISTINCT 
    CASE WHEN shipping_service IS NULL
      THEN order_id ELSE NULL END) AS total_missing_shipping_provider_orders,
  COUNT(DISTINCT 
    CASE WHEN active_promo_id IS NOT NULL
      THEN order_id ELSE NULL END) AS total_orders_with_promo_applied,
  ROUND(AVG(order_total_usd)::numeric,2) AS average_total_order_value_usd,
  ROUND(AVG(total_order_items)::numeric,2) AS average_total_order_items,
  ROUND(AVG(total_order_products)::numeric,2) AS average_total_order_products,
  ROUND(AVG(days_to_deliver)::numeric,2) AS average_days_to_deliver,
  ROUND(AVG(days_estimated_delivered_minus_delivered)::numeric,2) AS average_delivery_days_late_versus_estimate,
  CASE WHEN AVG(days_estimated_delivered_minus_delivered) < 0 THEN 1 ELSE 0 END AS is_average_order_late
FROM {{ ref('fact_user_orders') }}
GROUP BY 1 