use sakila;

with datos as(
    select
        customer_id,
        rental_id,
        CONCAT(customer.first_name, ' ', customer.last_name) as customer,
        title as film,
        CONCAT(district, ', ', city) as store,
        CONCAT(staff.first_name, ' ', staff.last_name) as staff,
        MONTH(rental_date) as mes,
        YEAR(rental_date) as annio
    from rental
        join customer using (customer_id)
        join inventory using (inventory_id)
        join film using (film_id)
        join staff using (staff_id)
        join store on inventory.store_id = store.store_id
        join address on store.address_id = address.address_id
        join city using (city_id)
),
datos_mes as(
    select
        store,
        mes,
        annio,
        count(*) as cantidad
    from datos
    group by 
        store,
        mes,
        annio
),
pago_mes as(
    select
        staff_id,
        MONTH(payment_date) as mes,
        YEAR(payment_date) as annio,
        sum(amount) as amount
    from 
        payment
    group by 
        staff_id,
        mes,
        annio    
),
datos_mes_col_pago as(
    select
        staff_id,
        amount,
        sum(case when annio=2005 and mes=5 then amount else 0 end) as mayo2005,
        sum(case when annio=2005 and mes=6 then amount else 0 end) as junio2005,
        sum(case when annio=2005 and mes=7 then amount else 0 end) as julio2005  
    from pago_mes
    group by 
        staff_id, 
        amount
),
datos_mes_col_cant as(
    select
        store,
        sum(case when annio=2005 and mes=5 then cantidad else 0 end) as mayocant,
        sum(case when annio=2005 and mes=6 then cantidad else 0 end) as juniocant,
        sum(case when annio=2005 and mes=7 then cantidad else 0 end) as juliocant  
    from datos_mes
    group by 
        store
)

select 
    mayo2005/mayocant as mayo,
    junio2005/juniocant as junio,
    (junio2005 - mayo2005) as diferencia, 
    ((junio2005 - mayo2005) / mayocant) as crecim,
    julio2005/juliocant as julio,
    (julio2005 - junio2005) as diferencia, 
    ((julio2005 - junio2005) / juniocant) as crecim
from datos_mes_col_cant, datos_mes_col_pago
limit 5;