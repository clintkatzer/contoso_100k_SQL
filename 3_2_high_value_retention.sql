--High Value Customers Churned
WITH customer_last_purchase AS (
	SELECT
		customerkey,
		cleaned_name,
		orderdate,
		ROW_NUMBER() OVER(PARTITION BY customerkey ORDER BY orderdate DESC) AS rn,
		SUM(total_net_revenue) OVER (PARTITION BY customerkey) AS total_ltv,
		first_purchase_date,
		cohort_year
	FROM 
		cohort_analysis
), customer_segments AS (
	SELECT
		percentile_cont(.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
		percentile_cont(.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
	FROM customer_last_purchase
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
		CASE
			WHEN total_ltv < cs.ltv_25th_percentile
			THEN '1 - Low Value'
			WHEN total_ltv <= cs.ltv_75th_percentile 
			THEN '2 - Mid-Value'
			ELSE '3 - High Value'
		END AS customer_value,
		cohort_year
	FROM customer_last_purchase, customer_segments cs
	WHERE rn=1 AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 MONTHS'
), customers_final AS (
	SELECT 
		cohort_year,
		customer_status,
		customer_value,
		COUNT(customerkey) AS numb_customers,
		SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year, customer_value) AS total_customers,
		100* COUNT(customerkey)/SUM(COUNT(customerkey) ) OVER(PARTITION BY cohort_year, customer_value) AS status_percentage
	FROM churned_customers
	GROUP BY cohort_year, customer_status,customer_value  
)
SELECT 
	cohort_year,
	customer_status,
	numb_customers,
	total_customers,
	status_percentage
FROM customers_final
WHERE customer_value = '3 - High Value'