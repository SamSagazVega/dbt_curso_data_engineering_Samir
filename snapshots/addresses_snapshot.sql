{% snapshot addresses_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='address_id',
      strategy='timestamp',
      updated_at='date_load_utc',
      invalidate_hard_deletes=True,
        )
}}

select * from {{ ref('stg_sql_server__dbo_addresses') }}

{% endsnapshot %} 