/* query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. 
Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month  */

SELECT DISTINCT rental_month AS Rental_month, 
				rental_year AS Rental_year, 
				so_id AS Store_ID, 
				total_count AS Count_rentals
FROM 
(
	SELECT 	so.store_id AS so_id,
			so.manager_staff_id AS so_manager_id,
			rl.rental_id AS rl_id,
			rl.rental_date AS rl_date,
			DATE_PART('year', rl.rental_date) AS rental_year,
			DATE_PART('month', rl.rental_date) AS rental_month,
			COUNT(*) OVER (PARTITION BY so.store_id, DATE_PART('year', rl.rental_date), DATE_PART('month', rl.rental_date)) AS Total_Count
	FROM store AS so
	JOIN staff AS sf
		ON so.store_id = sf.store_id
	JOIN rental AS rl
		ON sf.staff_id = rl.staff_id
	ORDER BY so_id, rental_year, rental_month
) T1
ORDER BY Count_rentals DESC
