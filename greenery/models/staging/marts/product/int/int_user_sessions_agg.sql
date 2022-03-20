{{
  config(
    materialized='view'
  )
}}

SELECT 
  user_id, 
  COUNT(DISTINCT session_id) AS total_sessions,
  ROUND(AVG(session_length_in_minutes)) AS avg_session_length_in_minutes,
  COUNT(DISTINCT CASE WHEN is_session_with_checkout = 1 THEN session_id ELSE NULL END) AS total_sessions_with_checkout,
  COUNT(DISTINCT CASE WHEN is_session_with_checkout = 0 THEN session_id ELSE NULL END) AS total_sessions_without_checkout,
  COUNT(DISTINCT CASE WHEN is_session_with_checkout = 0 AND total_add_to_cart_events >= 1 THEN session_id ELSE NULL END) AS total_sessions_with_abandoned_cart,
  ROUND(AVG(total_add_to_cart_events)::numeric,2) AS avg_add_to_cart_events_per_session,
  ROUND(AVG(total_content_page_views)::numeric,2) AS avg_content_page_views_per_session,
  ROUND(AVG(unique_urls_viewed)::numeric,2) AS avg_unique_urls_viewed_per_session
FROM {{ ref('fact_user_sessions') }}
GROUP BY 1 
