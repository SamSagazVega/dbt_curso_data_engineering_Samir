with source as (

    select * from {{ source('sql_server__dbo', 'products') }}

),

renamed as (

    select
        product_id,
        name,
        price,
        inventory,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed