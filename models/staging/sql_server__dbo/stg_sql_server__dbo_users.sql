with source as (

    select * from {{ source('sql_server__dbo', 'users') }}

),

renamed as (

    select
        user_id,
        address_id,
        first_name,
        last_name,
        email,
        phone_number,
        created_at as created_at_utc,
        updated_at as updated_at_utc,
        _fivetran_deleted as deleted,
        _fivetran_synced as date_load_utc

    from source

)

select * from renamed