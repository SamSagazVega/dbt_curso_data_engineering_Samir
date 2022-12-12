with source as (

    select * from {{ source('sql_server__dbo', 'products') }}

),

renamed as (

    select
        product_id,
        name as product_name,
        price as price_usd,
        inventory,
        _fivetran_deleted as deleted,
        _fivetran_synced as date_load_utc

    from source

)

select * from renamed