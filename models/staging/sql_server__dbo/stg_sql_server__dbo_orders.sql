with source as (

    select * from {{ source('sql_server__dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        created_at as created_at_utc,
        user_id,
        address_id,
        shipping_service,
        shipping_cost as shipping_cost_usd,
        order_cost as order_cost_usd,
        order_total as order_total_usd,
        promo_id as promo_type,
        estimated_delivery_at as estimated_delivery_at_utc,
        delivered_at as delivered_at_utc,
        tracking_id,
        status,
        _fivetran_deleted as deleted,
        _fivetran_synced as date_load_utc
        

    from source

)

select * from renamed