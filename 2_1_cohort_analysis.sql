WITH purchase_days AS(
	SELECT
		ca.customerkey,
		ca.total_net_revenue,
		ca.orderdate - MIN(ca.orderdate) OVER (PARTITION BY ca.customerkey)
		AS days_since_first_purchase
	FROM cohort_analysis2 ca
)
/*Analysis Indicates ~ 62 percent of revenue from the customer cohort defined by date of first purchase
 occurs with the first purchase*/
SELECT
	days_since_first_purchase,
	SUM(total_net_revenue) AS total_rev,
	SUM(total_net_revenue) /(SELECT SUM(total_net_revenue) 
	FROM cohort_analysis2)*100 AS percent_of_total 
FROM purchase_days 
GROUP BY days_since_first_purchase
ORDER BY days_since_first_purchase;


/*Finding where orderdate = first purchase date 
to look at initial purchase cohort data where the majority of revenue is generated*/
SELECT 
	ca.cohort_year,
	SUM(ca.total_net_revenue ) AS total_rev,
	COUNT(DISTINCT ca.customerkey )AS total_customers,
	SUM(ca.total_net_revenue )/COUNT(DISTINCT ca.customerkey) AS rev_per_customer
FROM cohort_analysis2 ca
WHERE ca.orderdate = ca.first_purchase_date 
GROUP BY 
	ca.cohort_year
 