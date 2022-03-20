{{
  config(
    materialized='table'
  )
}}

SELECT 
    user_id,
    LOWER(first_name) AS first_name,
    LOWER(last_name) AS last_name,
    email,
    phone_number,
    created_at AS user_created_at_utc,
    updated_at AS user_updated_at_utc,
    address_id
FROM {{ source('tutorial', 'users') }}
