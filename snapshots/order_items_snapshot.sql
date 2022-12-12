{% snapshot order_items_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='order_items_id',
      strategy='timestamp',
      updated_at='date_load_utc',
      invalidate_hard_deletes=True,
        )
}}

select * from {{ ref('stg_sql_server__dbo_order_items') }}

{% endsnapshot %}