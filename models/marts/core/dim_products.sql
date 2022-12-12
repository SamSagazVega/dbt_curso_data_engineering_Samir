{{ config(
    materialized='incremental',
    unique_key = ['DBT_VALID_FROM', 'product_id'] ,
    on_schema_change= 'append_new_columns'
    ) 
    }}

WITH stg_products AS (
    SELECT * 
    FROM {{ ref('products_snapshot') }}
    ),

products AS (
    SELECT
        product_id,
        product_name,
        price_usd,
        inventory,
        deleted,
        date_load_utc,
        DBT_SCD_ID,
        DBT_UPDATED_AT,
        DBT_VALID_FROM,
        DBT_VALID_TO
    from stg_products )

SELECT * FROM products

{% if is_incremental() %}

   where product_id in (select product_id from products where date_load_utc > (select max(date_load_utc) from {{ this }}))

{% endif %}