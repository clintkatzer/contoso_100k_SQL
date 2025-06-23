WITH us_customer_ages AS (
  SELECT 
  cohort_year,
  EXTRACT(YEAR FROM orderdate) AS order_year,
  COUNT(DISTINCT customerkey) AS customer_count,
  CASE 
    WHEN age <25 THEN '1 Under 25'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    else '65+'
  END AS age_group,
  SUM(total_net_revenue) AS net_rev
  
FROM cohort_analysis ca 
WHERE countryfull = 'United States'
GROUP BY order_year, age_group, cohort_year 
)

SELECT DISTINCT
order_year,
cohort_year,
age_group,
SUM(customer_count) OVER (PARTITION BY age_group, order_year, cohort_year) as customer_total,
SUM(net_rev) OVER (PARTITION BY age_group, order_year, cohort_year) as age_revenue
FROM us_customer_ages
WHERE age_group = '65+'
ORDER BY order_year, cohort_year, age_group