{{ config(materialized='table') }}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_events') }}
    ),

dates AS (
    SELECT * 
    FROM {{ ref('dim_date') }}
    ),

stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server__dbo_products') }}
    ),

interactions_product_month AS (
select 
    stg_events.product_id
    , product_name
    , month_name
    ,count (event_id) as Interactions_by_product
from stg_events
inner join dates
    on cast(stg_events.created_at_utc as date) = dates.date_day
inner join stg_products
    on stg_events.product_id = stg_products.product_id
group by stg_events.product_id , month_name, product_name
order by month_name desc )

SELECT * FROM interactions_product_month
