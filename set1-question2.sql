/* provide a table with the movie titles and divide them into 4 levels 
(first_quarter, second_quarter, third_quarter, and final_quarter) 
based ON the quartiles (25%, 50%, 75%) of the rental duration 
for movies across all categories  */


WITH all_family_friendly_rentals AS
(
	SELECT 	f.film_id AS f_film_id,
			f.title AS film_title,
			f.rental_duration AS  f_rental_duration,
			c.category_id AS c_category_id,
			c.name AS category_name,
			f_c.film_id AS f_c_film_id,
			f_c.category_id
	FROM category AS c
	JOIN film_category AS f_c
		ON c.category_id = f_c.category_id
	JOIN film AS f
		ON f.film_id = f_c.film_id
	WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	ORDER BY 5, 3
)

SELECT 	film_title AS title, 
		category_name AS name,
		f_rental_duration AS rental_duration,
		NTILE(4) OVER (ORDER BY f_rental_duration) AS standard_quartile
FROM all_family_friendly_rentals 
GROUP BY film_title, category_name, f_rental_duration
ORDER BY standard_quartile, rental_duration
