--Online Revenue Country

	SELECT	
		COUNT(s.customerkey) AS customer_count, 
		c.countryfull,
		SUM(s.quantity*s.netprice/exchangerate) AS net_rev,
		EXTRACT(YEAR FROM s.orderdate) AS order_year,
		AVG(EXTRACT(DAY FROM AGE(s.deliverydate,s.orderdate))) AS processing_time	
	FROM sales s
	LEFT JOIN customer c ON c.customerkey = s.customerkey
	WHERE s.storekey = 999999
	GROUP BY c.countryfull, order_year;

--Store Revenue Country
	SELECT	
		EXTRACT(YEAR FROM s.orderdate) AS order_year,
		c.countryfull,
		COUNT(s.orderkey) AS order_count,
		COUNT(s.customerkey) AS customer_count, 
		SUM(s.quantity*s.netprice/exchangerate) AS net_rev	
	FROM sales s
	LEFT JOIN customer c ON c.customerkey = s.customerkey
	WHERE s.storekey != 999999
	GROUP BY c.countryfull, order_year
	ORDER BY order_year, c.countryfull;