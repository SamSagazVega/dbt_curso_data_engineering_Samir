with source as (

    select * from {{ source('sql_server__dbo', 'addresses') }}

),

renamed_casted as (

    select
        address_id,
        address,
        state,
        zipcode,
        country,
        _fivetran_deleted as deleted,
        _fivetran_synced as date_load_utc

    from source

)

select * from renamed_casted