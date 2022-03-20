{{
  config(
    materialized='view'
  )
}}

SELECT
    order_id,
    STRING_AGG(product_name::text,',' ORDER BY product_name ASC) AS product_names_in_order_commasep,
    STRING_AGG(total_order_items::text,',' ORDER BY product_name ASC) AS total_product_in_order_commasep,
    SUM(total_order_items) AS total_order_items,
    COUNT(DISTINCT product_name) AS total_order_products
FROM 
    (
        SELECT 
        stg_order_items.order_id,
        stg_order_items.product_id,
        stg_order_items.total_order_items,
        stg_products.product_name,
        stg_products.price_usd
        FROM {{ ref('stg_order_items') }} AS  stg_order_items
        LEFT JOIN {{ ref('stg_products') }} AS stg_products
        ON stg_order_items.product_id = stg_products.product_id
    ) X
GROUP BY order_id
