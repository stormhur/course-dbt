{{
  config(
    materialized='table'
  )
}}

SELECT 
    address_id,
    LOWER(address) AS address,
    zipcode,
    LOWER(state) AS state,
    LOWER(country) AS country
FROM {{ source('tutorial', 'addresses') }}
