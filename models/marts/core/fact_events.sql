{{ config(
    materialized='incremental',
    unique_key = ['DBT_VALID_FROM', 'event_id'] ,
    on_schema_change= 'append_new_columns'
    ) 
    }}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('events_snapshot') }}
    ),


events AS (
    SELECT event_id
        ,session_id
        ,user_id
        ,product_id
        ,order_id
        ,page_url
        ,event_type
        ,created_at_utc
        ,deleted
        ,date_load_utc
        ,DBT_SCD_ID
        ,DBT_UPDATED_AT
        ,DBT_VALID_FROM
        ,DBT_VALID_TO

    FROM stg_events
    )

SELECT * FROM events

{% if is_incremental() %}

  where event_id in (select event_id from events where date_load_utc > (select max(date_load_utc) from {{ this }}))

{% endif %} 