{{
  config(
    materialized='view'
  )
}}

SELECT 
  product_name,
  COUNT(DISTINCT session_id) AS total_sessions
FROM {{ ref('int_user_content_pageviews') }}
GROUP BY 1
