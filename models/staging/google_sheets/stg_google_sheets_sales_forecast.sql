with source as (

    select * from {{ source('google_sheets', 'budget') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key([
                '_row', 
                'product_id',
                'to_varchar(year(month)*100+month(month))' ])
        }} as sales_forecast_id,
        product_id,
        quantity,
        to_varchar(year(month)*100+month(month)) as year_month_id ,
        _fivetran_synced as date_load_utc

    from source

)

select * from renamed