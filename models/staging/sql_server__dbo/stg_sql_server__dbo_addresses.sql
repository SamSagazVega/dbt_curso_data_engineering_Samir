with source as (

    select * from {{ source('sql_server__dbo', 'addresses') }}

),

renamed as (

    select
        address_id,
        state,
        country,
        zipcode,
        address,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed