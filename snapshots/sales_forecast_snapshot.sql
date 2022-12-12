{% snapshot sales_forecast_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='sales_forecast_id',
      strategy='timestamp',
      updated_at='date_load_utc',
      invalidate_hard_deletes=True,
        )
}}

select * from {{ ref('stg_google_sheets_sales_forecast') }}

{% endsnapshot %}