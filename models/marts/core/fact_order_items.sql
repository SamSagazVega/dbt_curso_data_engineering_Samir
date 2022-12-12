{{ config(
    materialized='incremental',
    unique_key = ['DBT_VALID_FROM', 'order_items_id'] ,
    on_schema_change= 'append_new_columns'
    ) 
    }}

WITH stg_order_items AS (
    SELECT * 
    FROM {{ ref('order_items_snapshot') }}
    ),


order_items AS (
    SELECT order_items_id,
        order_id,
        product_id,
        quantity,
        deleted,
        date_load_utc,
        DBT_SCD_ID,
        DBT_UPDATED_AT,
        DBT_VALID_FROM,
        DBT_VALID_TO
    
    FROM stg_order_items
    )

SELECT * FROM order_items

{% if is_incremental() %}

  where order_items_id in (select order_items_id from order_items where date_load_utc > (select max(date_load_utc) from {{ this }}))

{% endif %} 