WITH customer_ltv AS(
	SELECT
		customerkey,
		cleaned_name,
		SUM(total_net_revenue) AS total_ltv
		
	FROM
		cohort_analysis ca
	GROUP BY
		customerkey, cleaned_name 
), customer_segments AS (
	SELECT
		
		percentile_cont(.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
		percentile_cont(.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
	FROM customer_ltv 
), segment_values AS (
	SELECT 
		c.*,
		CASE
			WHEN c.total_ltv < cs.ltv_25th_percentile
			THEN '1 - Low Value'
			WHEN c.total_ltv <= cs.ltv_75th_percentile 
			THEN '2 - Mid-Value'
			ELSE '3 - High Value'
		END AS customer_value
		
	FROM customer_ltv c,
		customer_segments cs
)
SELECT 
	customer_value,
	SUM(total_ltv) AS total_ltv,
	COUNT(customerkey ) AS customer_count,
	SUM(total_ltv)/COUNT(customerkey ) AS avg_ltv
FROM segment_values 
GROUP BY customer_value
ORDER BY customer_value DESC 