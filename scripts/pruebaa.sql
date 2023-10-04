WITH datos AS (
        SELECT
                CONCAT(district, ', ', city) as store,
                YEAR(payment_date) as annio,
                MONTH(payment_date) as mes,
                SUM(amount) as amount
            FROM country
                INNER JOIN city USING(country_id)
                INNER JOIN address USING(city_id)
                INNER JOIN store USING(address_id)
                INNER JOIN staff USING(store_id)
                INNER JOIN payment USING(staff_id)
                INNER JOIN customer USING(customer_id)
            GROUP BY store, annio, mes
            HAVING annio=2005
    ),
    ventas_mes AS (
        SELECT 
            store,
            SUM( 
                CASE WHEN mes=5 THEN amount ELSE 0 END
            ) as mayo,
            SUM(
                CASE WHEN mes=6 THEN amount ELSE 0 END
            ) as junio,
            SUM(
                CASE WHEN mes=7 THEN amount ELSE 0 END
            ) as julio
        FROM datos
        GROUP BY store
    ),

    alquiler as (
        select 
            CONCAT(district, ', ', city) as store_a,
            MONTH(rental_date) as mes_a,
            YEAR(rental_date) as annio_a,
            count(*) as cantidad
        from rental
            join customer using (customer_id)
            join inventory using (inventory_id)
            join film using (film_id)
            join staff using (staff_id)
            join store on inventory.store_id = store.store_id
            join address on store.address_id = address.address_id
            join city using (city_id)
        GROUP BY store_a, mes_a, annio_a
    ),
    ventas_alquiler as (
        SELECT 
            store_a,
            SUM( 
                CASE WHEN mes_a=5 and annio_a=2005 THEN cantidad ELSE 0 END
            ) as mayo_a,
            SUM(
                CASE WHEN mes_a=6 and annio_a=2005 THEN cantidad ELSE 0 END
            ) as junio_a,
            SUM(
                CASE WHEN mes_a=7 and annio_a=2005 THEN cantidad ELSE 0 END
            ) as julio_a

        FROM alquiler
        GROUP BY store_a
    ),
    union_ventas as(
        select 
            vm.store,
            va.store_a,
            (vm.mayo/va.mayo_a) as mayo2005,
            (vm.junio/va.junio_a) as junio2005,
            (vm.julio/va.julio_a) as julio2005
        FROM ventas_mes vm INNER JOIN ventas_alquiler va ON vm.store = va.store_a
    )
SELECT 
    store,
    mayo2005,
    junio2005,
    (junio2005-mayo2005) as diferencia,
    ((junio2005-mayo2005)/mayo2005) as porcen,
    julio2005,
    (julio2005-junio2005) as diferencia,
    ((julio2005-junio2005)/junio2005) as porcen
FROM union_ventas
;