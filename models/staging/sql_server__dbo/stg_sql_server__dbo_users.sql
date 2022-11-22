with source as (

    select * from {{ source('sql_server__dbo', 'users') }}

),

renamed as (

    select
        user_id,
        email,
        address_id,
        phone_number,
        first_name,
        total_orders,
        created_at,
        updated_at,
        last_name,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed