--ejercicios

select distinct count(user_id) from stg_sql_server__dbo_users ;

select  avg(DATEDIFF(Day, created_at, delivered_at)) as  Diferencia_dias
from stg_sql_server__dbo_orders ;


with cantidad_pedidos as (
    select user_id,
    count(distinct order_id) as pedidos  
    from stg_sql_server__dbo_orders 
    group by 1
    )

select 
    distinct count (user_id) ,
    case
        when pedidos>=3 then '3+'
        else : varchar
    end as pedidos
from cantidad_pedidos 
group by 1
order by 1  ;

with session_hour as (
    select
    hour(created_at) as created_hour,
    count (distinct session_id) as unique_session_number
    from stg_sql_server_dbo_events
    group by 1
)

select avg(unique_session_number) as avg_session
from session_hour




