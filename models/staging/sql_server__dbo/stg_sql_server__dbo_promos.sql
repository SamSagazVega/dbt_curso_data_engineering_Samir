with source as (

    select * from {{ source('sql_server__dbo', 'promos') }}

),

renamed as (

    select
        promo_id,
        status,
        discount,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed