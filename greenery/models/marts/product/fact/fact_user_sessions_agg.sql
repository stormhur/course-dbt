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
  {{round_avg('total_add_to_cart_events')}} AS avg_add_to_cart_events_per_session,
  {{round_avg('total_page_view_events')}} AS avg_content_page_views_per_session,
  {{round_avg('unique_urls_viewed')}} AS avg_unique_urls_viewed_per_session
FROM {{ ref('int_user_sessions') }}
GROUP BY 1 
