{{
  config(
    materialized='table'
  )
}}

{% set events = dbt_utils.get_query_results_as_dict( 
  "SELECT DISTINCT event_type FROM" ~ref('stg_events')) %}

SELECT 
  user_id,
  session_id,
  ROUND(EXTRACT(EPOCH FROM (MAX(created_at_utc) - MIN(created_at_utc))::INTERVAL)/60) AS session_length_in_minutes,
  MIN(created_at_utc) AS session_start_time,
  MAX(created_at_utc) AS session_end_time,
  MAX(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS is_session_with_checkout,
  COUNT(DISTINCT event_id) AS total_events,
  {% for e in events['event_type'] %}
  COUNT(DISTINCT CASE WHEN event_type = '{{e}}' THEN event_id ELSE NULL END) AS total_{{e}}_events,
  {% endfor %}
  COUNT(DISTINCT page_url) AS unique_urls_viewed,
  COUNT(DISTINCT order_id) AS unique_orders_viewed,
  COUNT(DISTINCT product_id) AS unique_products_viewed
FROM {{ ref('stg_events') }}
GROUP BY 
  user_id,
  session_id
