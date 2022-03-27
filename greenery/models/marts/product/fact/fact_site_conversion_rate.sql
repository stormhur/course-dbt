{{
  config(
    materialized='view'
  )
}}

SELECT 
  SUM(total_sessions_with_checkout)/SUM(total_sessions) AS overall_site_conversion_rate
FROM {{ ref('fact_user_sessions_agg') }}
