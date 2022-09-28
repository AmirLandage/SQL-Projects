--Inspecting data
SELECT *
FROM [dbo].[sales_data_sample]

-- Checking unique values 

SELECT DISTINCT status FROM [dbo].[sales_data_sample]

SELECT DISTINCT year_id FROM [dbo].[sales_data_sample]

SELECT DISTINCT PRODUCTLINE FROM [dbo].[sales_data_sample]

SELECT DISTINCT COUNTRY FROM [dbo].[sales_data_sample]

SELECT DISTINCT DEALSIZE FROM [dbo].[sales_data_sample]

SELECT DISTINCT TERRITORY FROM [dbo].[sales_data_sample]

--ANALYSIS 
--Let's start by grouping sales by productline

SELECT 
	PRODUCTLINE, 
	SUM(sales) AS Revenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY Revenue DESC

SELECT 
	YEAR_ID,
	SUM(sales) AS Revenue
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY Revenue DESC

-- 2005 sales is low. why?

SELECT DISTINCT MONTH_ID 
FROM sales_data_sample
WHERE year_id = 2005

-- Operated only 5 months in the year that's why the sale is low.

SELECT 
	DEALSIZE, 
	SUM(sales) AS Revenue 
FROM sales_data_sample
GROUP BY DEALSIZE
ORDER BY Revenue DESC

-- What was the best month for sale in a specific year ? How much was earned that month ?

SELECT 
	MONTH_ID,
	SUM(sales) AS Revenue,
	COUNT(ORDERNUMBER) as Frequency
FROM sales_data_sample
WHERE YEAR_ID = 2003 -- Change the year to see the rest
GROUP BY MONTH_ID
ORDER BY Revenue DESC

-- November seems to be the highest selling month, what products do the company sell in November ?

SELECT
	MONTH_ID,
	PRODUCTLINE,
	SUM(sales) AS Revenue,
	COUNT(ORDERNUMBER) AS Frequency
FROM sales_data_sample
WHERE YEAR_ID = 2004 AND MONTH_ID = 11 -- Change the year to see the rest
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY Revenue DESC


-- Who is our best customer (this could be best answered with RFM )

DROP TABLE IF EXISTS #rfm
;WITH rfm as 
(
	SELECT 
		CUSTOMERNAME,
		SUM(sales) AS MonetaryValue,
		AVG(sales) AS AvgMonetaryValue,
		COUNT(ORDERNUMBER) AS Frequency,
		MAX(ORDERDATE) AS last_order_date,
		(SELECT MAX(ORDERDATE) FROM sales_data_sample) as max_oreder_date,
		DATEDIFF(DD,MAX(ORDERDATE), (SELECT MAX(ORDERDATE) FROM sales_data_sample)) AS Recency
	FROM sales_data_sample
	GROUP BY CUSTOMERNAME
),

rfm_calc AS 
(

SELECT r.*,
	NTILE(4) OVER (ORDER BY Recency DESC ) AS rfm_recency,
	NTILE(4) OVER (ORDER BY Frequency ) AS rfm_frequency,
	NTILE(4) OVER (ORDER BY MonetaryValue) AS rfm_monetary
FROM rfm AS r
)

SELECT 
	c.*,
	rfm_recency + rfm_frequency + rfm_monetary AS rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary as varchar) AS rfm_cell_string
INTO #rfm
FROM rfm_calc AS c

SELECT *
FROM #rfm

SELECT 
	CUSTOMERNAME,
	rfm_recency,
	rfm_frequency,
	rfm_monetary,
	CASE
		WHEN rfm_cell_string in (111,112,121,122,123,132,211,212,114,141) THEN 'lost_customers' -- lost customers
		WHEN rfm_cell_string in (133,134,143,244,334,343,344,234,144) then 'slipping away, cannot lose' --(big spenders who haven't purchased lately) slipping away
		WHEN rfm_cell_string in (311,411,331) then 'new customers'
		WHEN rfm_cell_string in (222,223,233,332,322,233,221,232) then 'potential churners'
		WHEN rfm_cell_string in (323,333,321,422,332,432,423,412,311,421) then 'active' -- (customers who buy & recently, but at low price points)
		WHEN rfm_cell_string in (433,434,443,444) then 'loyal'
	END  AS rfm_segment
FROM #rfm

-- What products are most often sold together ?

SELECT DISTINCT OrderNumber,  STUFF(
	(
	SELECT 
			',' + PRODUCTCODE
	FROM sales_data_sample as P
	WHERE ORDERNUMBER IN
		
			(
			SELECT ORDERNUMBER
			FROM
			(SELECT ORDERNUMBER,
					COUNT(*) AS rn
			FROM sales_data_sample 
			WHERE STATUS = 'Shipped'
			GROUP BY ORDERNUMBER
			) AS m
			WHERE rn = 3
			)
			and p.ORDERNUMBER = s.ORDERNUMBER
			for xml path ('')
			)
			,1,1,'') AS ProductCode
FROM sales_data_sample AS s
ORDER BY 2 DESC