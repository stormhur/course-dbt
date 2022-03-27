{{
  config(
    materialized='table'
  )
}}


SELECT
  stg_orders.order_id,
  dim_active_promos.active_promo_id,
  stg_orders.user_id,
  dim_users.user_first_name_last_name,
  dim_users.email,
  dim_users.phone_number,
  dim_users.user_created_at_utc,
  stg_orders.created_at_utc::date - dim_users.user_created_at_utc::date AS days_since_user_created,
  stg_orders.address_id AS order_address_id,
  stg_addresses.address AS order_address,
  stg_addresses.zipcode AS order_zipcode,
  stg_addresses.state AS order_state,
  stg_addresses.country AS order_country,
  stg_orders.created_at_utc AS order_created_at_utc,
  int_product.product_names_in_order_commasep,
  int_product.total_product_in_order_commasep,
  int_product.total_order_items,
  int_product.total_order_products,
  stg_orders.order_cost_usd,
  dim_active_promos.active_price_discount_in_usd, 
  stg_orders.shipping_cost_usd,
  stg_orders.order_total_usd,
  ROUND(stg_orders.order_total_usd/NULLIF(int_product.total_order_items,0)) AS average_total_cost_per_item_usd,
  stg_orders.tracking_id,
  stg_orders.shipping_service,
  stg_orders.estimated_delivery_at_utc,
  stg_orders.delivered_at_utc,
  stg_orders.delivered_at_utc::date - stg_orders.created_at_utc::date AS days_to_deliver,
  stg_orders.delivered_at_utc::date - stg_orders.estimated_delivery_at_utc::date AS days_estimated_delivered_minus_delivered,
  CASE
    WHEN stg_orders.delivered_at_utc IS NULL THEN NULL
    WHEN stg_orders.delivered_at_utc::date - stg_orders.estimated_delivery_at_utc::date > 0 THEN 'later_than_estimated'
    WHEN stg_orders.delivered_at_utc::date - stg_orders.estimated_delivery_at_utc::date = 0 THEN 'as_estimated'
    ELSE 'earlier_than_estimated' 
    END AS estimated_delivery_performance,
  CASE WHEN stg_orders.delivered_at_utc IS NOT NULL THEN 1 ELSE 0 END AS is_delivered
FROM {{ ref('stg_orders') }} AS stg_orders
  LEFT JOIN {{ ref('int_active_promos') }} AS dim_active_promos
    ON stg_orders.promo_id = dim_active_promos.active_promo_id
  LEFT JOIN {{ ref('int_order_products') }}  AS int_product
    ON stg_orders.order_id = int_product.order_id
  LEFT JOIN {{ ref('stg_addresses') }} AS stg_addresses
    ON stg_orders.address_id = stg_addresses.address_id
  LEFT JOIN {{ ref('dim_users') }} AS dim_users 
    ON stg_orders.user_id = dim_users.user_id 