with source as (

    select * from {{ source('sql_server__dbo', 'order_items') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select 
 {{ dbt_utils.surrogate_key([
                'order_id', 
                'product_id'
            ])
        }} as order_items_id,

order_id,
product_id,
quantity,
_fivetran_deleted,
_fivetran_synced      

 from renamed