{{ config(
    materialized='incremental',
    unique_key = ['DBT_VALID_FROM', 'address_id'] ,
    on_schema_change= 'append_new_columns'
    ) 
    }}

WITH stg_addresses AS (
    SELECT * 
    FROM {{ ref('addresses_snapshot') }}
    ),


shipping_addresses AS (
    SELECT address_id,
        address,
        state,
        zipcode,
        country,
        deleted,
        date_load_utc,
        DBT_SCD_ID,
        DBT_UPDATED_AT,
        DBT_VALID_FROM,
        DBT_VALID_TO
    
    FROM stg_addresses
    )

SELECT * FROM shipping_addresses

{% if is_incremental() %}

  where address_id in (select address_id from shipping_addresses where date_load_utc > (select max(date_load_utc) from {{ this }}))

{% endif %} 