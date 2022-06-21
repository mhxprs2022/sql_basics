/* query that lists each movie from family movies, 
the film category it is classified in, and the number of times it has been rented out.  */

WITH all_rentals AS
(
	SELECT	f.film_id AS f_film_id,
			f.title AS film_title,
			c.category_id AS c_category_id,
			c.name AS category_name,
			f.rental_duration AS  f_rental_duration,
			i.inventory_id AS i_inventory_id,
			i.film_id AS i_film_id,
			i.store_id AS i_store_id,
			r.rental_id AS r_rental_id,
			r.rental_date AS r_rental_date,
			r.inventory_id AS r_inventory_id,
			r.customer_id AS r_customer_id,
			r.return_date AS r_return_date
	FROM category AS c
	JOIN film_category AS f_c
		ON c.category_id = f_c.category_id
	JOIN film AS f
		ON f.film_id = f_c.film_id
	JOIN inventory AS i
		ON i.film_id = f.film_id
	JOIN rental AS r
		ON i.inventory_id = r.inventory_id
	WHERE c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	ORDER BY 1
)

SELECT 	film_title, 
		category_name, 
		count(film_title) AS rental_count
FROM all_rentals
GROUP BY film_title, category_name
ORDER BY category_name, film_title, rental_count DESC