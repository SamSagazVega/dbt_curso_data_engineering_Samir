{{ config(
    materialized='incremental',
    unique_key = ['DBT_VALID_FROM', 'user_id'] ,
    on_schema_change= 'append_new_columns'
    ) 
    }}

WITH stg_users AS (
    SELECT * 
    FROM {{ ref('users_snapshot') }}
    ),

stg_addresses as (
    select *
    FROM {{ ref('addresses_snapshot') }}
    ),

users AS (
    SELECT
        user_id,
        first_name,
        last_name,
        stg_users.address_id,
        address,
        state,
        zipcode,
        country,
        email,
        phone_number,
        created_at_utc,
        updated_at_utc,
        stg_users.deleted,
        stg_users.date_load_utc,
        stg_users.DBT_SCD_ID,
        stg_users.DBT_UPDATED_AT,
        stg_users.DBT_VALID_FROM,
        stg_users.DBT_VALID_TO

    from stg_users
    left join stg_addresses
        on stg_users.address_id = stg_addresses.address_id
     )

SELECT * FROM users

{% if is_incremental() %}

  where user_id in (select user_id from users where date_load_utc > (select max(date_load_utc) from {{ this }}))

{% endif %}