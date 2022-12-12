{{ config( materialized='table' ) }}

with stg_sales_forecast as (
    select *
    from {{ref('stg_google_sheets_sales_forecast')}}
),

stg_products as (
    select *
    from {{ref('stg_sql_server__dbo_products')}}
),

dim_month AS (
    SELECT * 
    FROM {{ ref('dim_month') }}
    ),

sales_forecast_inventory as (
    select
        sales_forecast_id
        , stg_sales_forecast.product_id
        , stg_products.product_name
        , quantity
        , stg_products.inventory
        , case when inventory < quantity
                then 'increase stock'
                else 'enought stock'
            end as forecast
        , stg_sales_forecast.year_month_id
        , dim_month.QUARTER_OF_YEAR
    from stg_sales_forecast
    inner join stg_products
        on stg_sales_forecast.product_id = stg_products.product_id
    inner join dim_month
        on stg_sales_forecast.year_month_id = dim_month.year_month_id
    )


select * from sales_forecast_inventory