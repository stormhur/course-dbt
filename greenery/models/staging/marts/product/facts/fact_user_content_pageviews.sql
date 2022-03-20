{{
  config(
    materialized='table'
  )
}}

SELECT DISTINCT
  stg_events.event_id,
  stg_events.created_at_utc AS pageview_timestamp_utc,
  stg_events.created_at_utc::date pageview_date_utc,
  stg_events.user_id,
  dim_users.user_first_name_last_name,
  dim_users.email,
  dim_users.phone_number,
  dim_users.user_created_at_utc,
  dim_users.associated_address_ids_commasep AS user_associated_address_ids_commasep,
  dim_users.associated_addresses_commasep AS user_associated_addresses_commasep,
  dim_users.associated_zipcodes_commasep AS user_associated_zipcodes_commasep,
  dim_users.associated_states_commasep AS user_associated_states_commasep,
  dim_users.associated_countries_commasep AS user_associated_countries_commasep,
  stg_events.created_at_utc::date - dim_users.user_created_at_utc::date AS days_since_user_created,
  stg_events.session_id,
  stg_events.page_url,
  stg_events.product_id,
  CASE WHEN stg_products.total_inventory >= 1 THEN 1 ELSE 0 END AS is_product_inventory_available,
  CASE WHEN stg_products.total_inventory < 25 THEN 1 ELSE 0 END AS is_less_than_25_product_inventory_available,
  stg_products.product_name,
  stg_products.price_usd,
  stg_products.total_inventory AS total_product_inventory
FROM {{ ref('stg_events') }} AS stg_events
LEFT JOIN {{ ref('stg_products') }} AS stg_products
  ON stg_events.product_id = stg_products.product_id
LEFT JOIN {{ ref('dim_users') }} AS dim_users
  ON stg_events.user_id = dim_users.user_id
WHERE stg_events.event_type = 'page_view'


