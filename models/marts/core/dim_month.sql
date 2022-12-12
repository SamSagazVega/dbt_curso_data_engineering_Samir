{{ config(
    materialized='table',
    unique_key = 'year_month_id' 
    ) 
    }}

with dim_month as ({{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2020-01-01' as date)",
    end_date="cast('2030-01-01' as date)"
   )
}}) ,

renamed_casted as (
select
    distinct to_varchar(year(date_day)*100+month(date_day)) as year_month_id
    , month(date_day) as month
    , to_char(date_day, 'MMMM')  as month_name
    , date_part('quarter', date_day) as quarter_of_year
    , year(date_day) as year
from dim_month
order by year_month_id )

select * from renamed_casted