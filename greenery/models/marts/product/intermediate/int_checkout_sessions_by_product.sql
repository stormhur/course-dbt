
{{
  config(
    materialized='view'
  )
}}
SELECT DISTINCT
  session_id,
  UNNEST(
        STRING_TO_ARRAY(product_names_in_order_commasep, ',')
        ) AS order_item
FROM {{ ref('int_user_checkout_pageviews') }}
WHERE product_names_in_order_commasep IS NOT NULL