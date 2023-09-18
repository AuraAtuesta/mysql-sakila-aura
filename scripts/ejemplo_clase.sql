use sakila;
-- 1. obtengo los datos de los clientes

with customer_data as(
    select 
        customer_id,
        first_name,
        last_name,
        address,
        district,
        city,
        country 
    from customer as c
        join address as a using(address_id)
        join city as ci using(city_id)
        join country as co using(country_id)
),
-- 2. Agrupo los datos por pais

data_by_country as (
    select 
        country,
        count(*) as customer_qty
    from
        customer_data
    group by 
        country
),
-- 3. Hacer la transposicion
data_in_columns as(
    select
        "customers" as customers,
        sum(case when country = 'Afghanistan' then customer_qty else 0 end) as Afghanistan,
        sum(case when country = 'Algeria' then customer_qty else 0 end) as Algeria,
        sum(case when country = 'American Samoa' then customer_qty else 0 end) as American_Samoa
    from 
        data_by_country
),
-- 4. Operaciones con columnas 
data_comparative as(
    select
        customers,
        Afghanistan,
        Algeria,
        (Algeria - Afghanistan) as diff,
        ((Algeria - Afghanistan)/Afghanistan) as porc
    from 
        data_in_columns
)

select *
from data_comparative
limit 5;

-- source /scripts/ejemplo_clase.sql