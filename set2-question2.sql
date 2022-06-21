/* query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers? */
WITH TOP_10_CUSTOMERS AS
(
	/* This query pull top 10 customers that paid the most total  */
	SELECT DISTINCT cust_id, cms_first_name, cms_last_name, total_payment_by_one_customer
	FROM
	(
		/* This query obtained how much total each customer paid in 2007, using a window function */
		SELECT 	cmr.customer_id AS cust_id,
				pmt.amount AS pmt_amount,
				cmr.first_name AS cms_first_name,
				cmr.last_name AS cms_last_name,
				DATE_TRUNC('month', pmt.payment_date) AS pay_mon,
				SUM(pmt.amount) OVER (PARTITION BY cmr.customer_id) AS total_payment_by_one_customer
		FROM 	payment AS pmt
		JOIN 	customer AS cmr
			ON 	cmr.customer_id = pmt.customer_id
		WHERE 	DATE_PART('year', pmt.payment_date) = 2007
		ORDER BY total_payment_by_one_customer DESC, cust_id
	) T1
	ORDER BY total_payment_by_one_customer DESC
	LIMIT 10
)


SELECT DISTINCT pay_mon,
				cms_fullname AS fullname,
				pay_countpermon,
				pay_amount
FROM 
(
	SELECT	cmr.customer_id AS cust_id,
			pmt.amount AS pmt_amount,
			CONCAT(cmr.first_name, ' ', cmr.last_name) AS cms_fullname,		
			DATE_TRUNC('month', pmt.payment_date) AS pay_mon,
			COUNT(*) OVER (PARTITION BY cmr.customer_id, DATE_TRUNC('month', pmt.payment_date)) AS pay_countpermon,
			SUM(pmt.amount) OVER (PARTITION BY cmr.customer_id, DATE_TRUNC('month', pmt.payment_date)) AS pay_amount
	FROM payment AS pmt
	JOIN customer AS cmr
		ON cmr.customer_id = pmt.customer_id
	WHERE DATE_PART('year', pmt.payment_date) = 2007 AND cmr.customer_id IN 
	(
		/* this query select customer ID of top 10 paid customers */
		SELECT cust_id
		FROM TOP_10_CUSTOMERS
	)
ORDER BY cust_id
) T2
ORDER BY fullname