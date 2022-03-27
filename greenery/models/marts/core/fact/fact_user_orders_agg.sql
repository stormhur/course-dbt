{{
  config(
    materialized='view'
  )
}}

{% set delivery_status_types = ["later_than_estimated","as_estimated","earlier_than_esimated"] %}
{% set delivery_companies = dbt_utils.get_query_results_as_dict( 
  "SELECT DISTINCT shipping_service FROM" ~ref('int_user_orders')) %}

SELECT
  user_id, 
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT 
    CASE WHEN estimated_delivery_performance IS NULL 
      THEN order_id ELSE NULL END) AS total_pending_orders,
{% for i in deliver_status_types %}
  COUNT(DISTINCT 
    CASE WHEN estimated_delivery_performance = '{{i}}' 
      THEN order_id ELSE NULL END) AS total_{{i}}_orders,
{% endfor %}
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 1 AND total_order_items <= 2)
      THEN order_id ELSE NULL END) AS total_small_orders,
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 3 AND total_order_items <= 5)
      THEN order_id ELSE NULL END) AS total_medium_orders,
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 6 AND total_order_items <= 10)
      THEN order_id ELSE NULL END) AS total_large_orders,
  COUNT(DISTINCT 
    CASE WHEN (total_order_items >= 11)
      THEN order_id ELSE NULL END) AS total_extra_large_orders,
{% for c in delivery_companies['shipping_service'] %}
  COUNT(DISTINCT 
    CASE WHEN shipping_service = '{{c}}' 
      THEN order_id ELSE NULL END) AS total_{{c}}_orders,
{% endfor %}
  COUNT(DISTINCT 
    CASE WHEN shipping_service IS NULL
      THEN order_id ELSE NULL END) AS total_missing_shipping_provider_orders,
  COUNT(DISTINCT 
    CASE WHEN active_promo_id IS NOT NULL
      THEN order_id ELSE NULL END) AS total_orders_with_promo_applied,
  {{round_avg('order_total_usd')}} AS average_total_order_value_usd,
  {{round_avg('total_order_items')}} AS average_total_order_items,
  {{round_avg('total_order_products')}} AS average_total_order_products,
  {{round_avg('days_to_deliver')}} AS average_days_to_deliver,
  {{round_avg('days_estimated_delivered_minus_delivered')}} AS average_delivery_days_late_versus_estimate,
  CASE WHEN AVG(days_estimated_delivered_minus_delivered) < 0 THEN 1 ELSE 0 END AS is_average_order_late
FROM {{ ref('int_user_orders') }}
GROUP BY 1 