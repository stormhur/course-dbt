{{
  config(
    materialized='view'
  )
}}


SELECT 
  stg_users.user_id,
  stg_users.first_name,
  stg_users.last_name,
  concat(stg_users.first_name,' ',stg_users.last_name) AS user_first_name_last_name,
  stg_users.email,
  stg_users.phone_number,
  stg_users.user_created_at_utc,
  stg_users.user_updated_at_utc,
  STRING_AGG(stg_users.address_id::text,',' ORDER BY stg_users.address_id ASC) AS associated_address_ids_commasep,
  STRING_AGG(stg_addresses.address::text,',' ORDER BY stg_users.address_id ASC) AS associated_addresses_commasep,
  STRING_AGG(stg_addresses.zipcode::text,',' ORDER BY stg_users.address_id ASC) AS associated_zipcodes_commasep,
  STRING_AGG(stg_addresses.state::text,',' ORDER BY stg_users.address_id ASC) AS associated_states_commasep,
  STRING_AGG(stg_addresses.country::text,',' ORDER BY stg_users.address_id ASC) AS associated_countries_commasep,
  COUNT(DISTINCT stg_users.address_id) AS unique_associated_address_ids,
  COUNT(DISTINCT stg_addresses.address) AS unique_associated_addresses,
  COUNT(DISTINCT stg_addresses.zipcode) AS unique_associated_zipcodes,
  COUNT(DISTINCT stg_addresses.state) AS unique_associated_states,
  COUNT(DISTINCT stg_addresses.country) AS unique_associated_countries
FROM {{ ref('stg_users') }} AS stg_users 
  LEFT JOIN {{ ref('stg_addresses') }} AS stg_addresses
    ON stg_users.address_id = stg_addresses.address_id
GROUP BY 
  user_id,
  first_name,
  last_name,
  concat(first_name,' ',last_name),
  email,
  phone_number,
  user_created_at_utc,
  user_updated_at_utc
 