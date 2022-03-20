{{
  config(
    materialized='table'
  )
}}

SELECT 
  user_id,
  session_id,
  ROUND(EXTRACT(EPOCH FROM (MAX(created_at_utc) - MIN(created_at_utc))::INTERVAL)/60) AS session_length_in_minutes,
  MIN(created_at_utc) AS session_start_time,
  MAX(created_at_utc) AS session_end_time,
  MAX(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS is_session_with_checkout,
  COUNT(DISTINCT event_id) AS total_events,
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN event_id ELSE NULL END) AS total_add_to_cart_events,
  COUNT(DISTINCT CASE WHEN event_type = 'checkout' THEN event_id ELSE NULL END) AS total_checkout_page_views,
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN event_id ELSE NULL END) AS total_content_page_views,
  COUNT(DISTINCT page_url) AS unique_urls_viewed,
  COUNT(DISTINCT CASE WHEN event_type = 'package_shipped' THEN event_id ELSE NULL END) AS total_package_shipped_page_views,
  COUNT(DISTINCT order_id) AS unique_orders_viewed,
  COUNT(DISTINCT product_id) AS unique_products_viewed
FROM {{ ref('stg_events') }}
GROUP BY 
  user_id,
  session_id
