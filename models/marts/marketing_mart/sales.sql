{{ config(materialized='table') }}

WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_orders') }}
    ),

dates AS (
    SELECT * 
    FROM {{ ref('dim_date') }}
    ),

stg_order_items AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_order_items') }}
    ),

stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_products') }}
    ),

stg_addresses AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_addresses') }}
    ),

sales AS (
select 
        stg_orders.order_id,
        stg_order_items.product_id,
        stg_products.product_name,
        stg_order_items.quantity,
        price_usd,
        order_cost_usd,
        user_id,
        stg_orders.address_id,
        state,
        created_at_utc,
        quarter_of_year

    FROM stg_orders
    inner join stg_order_items
        on stg_orders.order_id = stg_order_items.order_id
    inner join dates
        on cast(stg_orders.created_at_utc as date) = dates.date_day
    inner join stg_products
        on stg_order_items.product_id = stg_products.product_id
    inner join stg_addresses
        on stg_orders.address_id = stg_addresses.address_id

    order by stg_orders.order_id
 )


SELECT * FROM sales