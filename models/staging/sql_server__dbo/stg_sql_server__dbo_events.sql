WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server__dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        event_id
        ,session_id
        ,user_id
        ,product_id
        ,order_id
        ,page_url
        ,event_type
        ,created_at as created_at_utc
        ,_fivetran_deleted as deleted
        ,_fivetran_synced as date_load_utc
    FROM src_events
    )

SELECT * FROM renamed_casted