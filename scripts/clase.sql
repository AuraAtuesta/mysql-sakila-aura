select
        customer_id,
        rental_id,
        CONCAT(customer.first_name, ' ', customer.last_name) as customer,
        title as film,
        CONCAT(district, ', ', city) as store,
        CONCAT(staff.first_name, ' ', staff.last_name) as staff,
        MONTH(rental_date) as mes,
        YEAR(rental_date) as annio
    from rental, payment
        join customer using (customer_id)
        join inventory using (inventory_id)
        join film using (film_id)
        join staff using (staff_id)
        join store on inventory.store_id = store.store_id
        join address on store.address_id = address.address_id
        join city using (city_id)
        join payment using(payment_id)