with source as (

    select * from {{ source('sql_server__dbo', 'promos') }}

),

renamed_casted as (

    select
        promo_id as promo_type,
        status,
        discount as discount_usd,
        _fivetran_deleted as deleted,
        _fivetran_synced as date_load_utc

    from source

)

select * from renamed_casted