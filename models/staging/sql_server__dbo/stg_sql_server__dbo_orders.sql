with source as (

    select * from {{ source('sql_server__dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        shipping_service,
        promo_id,
        estimated_delivery_at,
        order_cost,
        order_total,
        user_id,
        status,
        address_id,
        shipping_cost,
        delivered_at,
        tracking_id,
        created_at,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed