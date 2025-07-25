WITH customer_last_purchase AS (
SELECT
	customerkey,
	cleaned_name,
	orderdate,
	ROW_NUMBER() OVER(PARTITION BY customerkey ORDER BY orderdate DESC) AS rn,
	first_purchase_date,
	cohort_year
FROM 
	cohort_analysis
), churned_customers AS (

	SELECT 
		customerkey,
		cleaned_name,
		orderdate AS last_purchase_date,
		CASE 
			WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 MONTHS'
			THEN 'Churned'
			ELSE 'Active'
		END AS customer_status,
		cohort_year
	FROM customer_last_purchase 
	WHERE rn=1 AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 MONTHS'
)

SELECT 
	cohort_year,
	customer_status,
	COUNT(customerkey) AS numb_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) AS total_customers,
	100* COUNT(customerkey)/SUM(COUNT(customerkey) ) OVER(PARTITION BY cohort_year) AS status_percentage
FROM churned_customers
GROUP BY cohort_year, customer_status   