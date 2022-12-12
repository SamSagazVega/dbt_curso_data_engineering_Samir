{% set event_types = dbt_utils.get_column_values(ref('fct_events'),'event_type') %}
with fact_events as (
    select *
    from {{ ref('fct_events')}}
),