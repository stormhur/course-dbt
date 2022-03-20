{{
  config(
    materialized='table'
  )
}}

SELECT 
    event_id,
    session_id,
    user_id,
    event_type,
    page_url,
    created_at AS created_at_utc,
    order_id,
    LOWER(product_id) AS product_id
FROM {{ source('tutorial', 'events') }}
