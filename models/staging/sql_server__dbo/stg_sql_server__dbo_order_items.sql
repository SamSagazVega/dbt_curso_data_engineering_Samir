with source as (

    select * from {{ source('sql_server__dbo', 'order_items') }}

),

renamed_casted as (

    select
        {{ dbt_utils.surrogate_key([
                'order_id', 
                'product_id'
            ])
        }} as order_items_id,
        order_id,
        product_id,
        quantity,
        _fivetran_deleted as deleted,
        _fivetran_synced as date_load_utc

    from source

)

select * from renamed_casted