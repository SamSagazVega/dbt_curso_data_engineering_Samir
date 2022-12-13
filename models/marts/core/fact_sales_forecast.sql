{{ config(
    materialized='incremental',
    unique_key = ['DBT_VALID_FROM', 'sales_forecast_id'] ,
    on_schema_change= 'append_new_columns'
    ) 
    }}


WITH stg_sales_forecast AS (
    SELECT * 
    FROM {{ ref('sales_forecast_snapshot') }}
    ),

stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_products') }}
    ),


dim_month AS (
    SELECT * 
    FROM {{ ref('dim_month') }}
    ),


sales_forecast AS (
    SELECT
        sales_forecast_id
        , stg_sales_forecast.product_id
        , quantity
        , stg_products.price_usd as unit_price_usd
        , unit_price_usd * quantity as sale_forecast_usd
        , stg_sales_forecast.year_month_id
        , dim_month.QUARTER_OF_YEAR
        , stg_sales_forecast.date_load_utc
        , DBT_SCD_ID
        , DBT_UPDATED_AT
        , DBT_VALID_FROM
        , DBT_VALID_TO
        
    FROM stg_sales_forecast
    inner join stg_products
        on stg_sales_forecast.product_id = stg_products.product_id
    inner join dim_month
        on stg_sales_forecast.year_month_id = dim_month.year_month_id
    )

SELECT * FROM sales_forecast

{% if is_incremental() %}

  where sales_forecast_id in (select sales_forecast_id from sales_forecast where date_load_utc > (select max(date_load_utc) from {{ this }}))

{% endif %} 