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
  fact_user_orders.user_first_name_last_name,
  fact_user_orders.email,
  fact_user_orders.phone_number,
  stg_events.created_at_utc::date - fact_user_orders.user_created_at_utc::date AS days_since_user_created,
  stg_events.session_id,
  stg_events.page_url,
  stg_events.order_id,
  fact_user_orders.active_promo_id,
  fact_user_orders.order_address_id,
  fact_user_orders.order_address,
  fact_user_orders.order_zipcode,
  fact_user_orders.order_state,
  fact_user_orders.order_country,
  fact_user_orders.order_created_at_utc,
  fact_user_orders.product_names_in_order_commasep,
  fact_user_orders.total_product_in_order_commasep,
  fact_user_orders.total_order_items,
  fact_user_orders.total_order_products,
  fact_user_orders.order_cost_usd,
  fact_user_orders.active_price_discount_in_usd, 
  fact_user_orders.shipping_cost_usd,
  fact_user_orders.order_total_usd,
  fact_user_orders.average_total_cost_per_item_usd,
  fact_user_orders.tracking_id,
  fact_user_orders.shipping_service,
  fact_user_orders.estimated_delivery_at_utc,
  fact_user_orders.delivered_at_utc,
  fact_user_orders.days_to_deliver,
  fact_user_orders.days_estimated_delivered_minus_delivered,
  fact_user_orders.estimated_delivery_performance,
  fact_user_orders.is_delivered
FROM {{ ref('stg_events') }} AS stg_events
LEFT JOIN {{ ref('int_user_orders') }} AS fact_user_orders
  ON stg_events.order_id = fact_user_orders.order_id
WHERE stg_events.event_type = 'checkout'


