{{ config(
    materialized='incremental',
    unique_key = ['DBT_VALID_FROM', 'order_id'] ,
    on_schema_change= 'append_new_columns'
    ) 
    }}

WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('orders_snapshot') }}
    ),

 stg_promos AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_promos') }}
    ),


orders AS (
    SELECT
        order_id,
        created_at_utc,
        user_id,
        address_id,
        shipping_service,
        shipping_cost_usd,
        order_cost_usd,
        order_total_usd,
        stg_orders.promo_type ,
        stg_promos.status as promo_status ,
        stg_promos.discount_usd ,
        estimated_delivery_at_utc,
        delivered_at_utc,
        tracking_id,
        stg_orders.status as shipping_status,
        stg_orders.deleted,
        stg_orders.date_load_utc,
        stg_orders.DBT_SCD_ID,
        stg_orders.DBT_UPDATED_AT,
        stg_orders.DBT_VALID_FROM,
        stg_orders.DBT_VALID_TO

    FROM stg_orders
    left join stg_promos
        on stg_orders.promo_type = stg_promos.promo_type
        )

SELECT * FROM orders

{% if is_incremental() %}

  where order_id in (select order_id from orders where date_load_utc > (select max(date_load_utc) from {{ this }}))

{% endif %} 