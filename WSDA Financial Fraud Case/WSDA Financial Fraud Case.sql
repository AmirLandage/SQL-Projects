/*
The manager of WSDA Music has been unable to account for a discrepancy in his company's finances.
The closest he is gotten in hin attempts to analyze the data is figuring out that discrepancy occurred 
between the years 2011 and 2012. Get a list of suspects.
*/

-- How manytransactionsn tookplace betweenyearsr 2011-201 ?

SELECT
	COUNT(*)
FROM
	Invoice
WHERE
	InvoiceDate >= "2011-01-01" AND InvoiceDate <= "2012-12-31"
	
-- How much money does WSDA make during this yea ?

SELECT
	SUM(total)
FROM 
	Invoice
WHERE
	InvoiceDate >= "2011-01-01" AND InvoiceDate <= "2012-12-31"

-- Get a list of customers who made purchase betweenn 2011-201 ?

SELECT
    c.CustomerId,
	c.FirstName,
	c.LastName,
	i.total
FROM
	Customer AS c
INNER JOIN
	Invoice AS i
ON c.CustomerId = i.CustomerId
WHERE
	i.InvoiceDate >= "2011-01-01" AND i.InvoiceDate <= "2012-12-31"
ORDER BY
	i.total DESC
	
	
--Get a list of customers, sales reps, and the total transaction amount for each customer between 2011-2012.
SELECT
	c.FirstName AS "Customer FN",
	c.LastName AS "Customer LN",
	e.FirstName AS "Employee FN",
	e.LastName AS "Employee LN",
	i.total
FROM
	Customer AS c
INNER JOIN
	Employee AS e
ON
	c.SupportRepId = e.EmployeeId
INNER JOIN
	Invoice AS i
ON
	c.CustomerId = i.CustomerId
WHERE 
	i.InvoiceDate >= "2011-01-01" AND i.InvoiceDate <= "2012-12-31"
ORDER BY 
	i.total DESC
	
	
--How many transactions are above the average transaction amount during the same time?
SELECT
	c.FirstName AS "Customer FN",
	c.LastName AS "Customer LN",
	e.FirstName AS "Employee FN",
	e.LastName AS "Employee LN",
	i.total
FROM
	Customer AS c
INNER JOIN
	Employee AS e
ON
	c.SupportRepId = e.EmployeeId
INNER JOIN
	Invoice AS i
ON
	c.CustomerId = i.CustomerId
WHERE 
	(i.InvoiceDate >= "2011-01-01" AND i.InvoiceDate <= "2012-12-31") AND i.total >
																			(SELECT
																				 avg(total) 
																			 FROM
																				 Invoice
																			  WHERE
																	InvoiceDate >= "2011-01-01" AND InvoiceDate <= "2012-12-31")
ORDER BY 
	i.total DESC
	
	
--What is the average transaction amount for each year that WSDA has been in a business?

SELECT
	strftime('%Y',InvoiceDate) AS "Year",
	round(avg(total),2)
FROM
	Invoice
GROUP by
	strftime('%Y',InvoiceDate)
	
--Get a list of employees who exceeded the average transaction amount from sales they generated during 2011-2012?


SELECT
	e.FirstName,
	e.LastName,
	sum(i.total) AS "Total Sales"
FROM
	Employee AS e
INNER JOIN
	Customer AS c
ON
	c.SupportRepId = e.EmployeeId
INNER JOIN
	Invoice AS i
ON
	c.CustomerId = i.CustomerId
WHERE 
	(i.InvoiceDate >= "2011-01-01" AND i.InvoiceDate <= "2012-12-31") AND i.total > 11.66
GROUP BY
e.FirstName,
e.LastName															
ORDER BY 
	e.LastName

	
-- Create a commission Payout column that displays each employee's commission based on 15% of the sales transaction amount

SELECT
	e.FirstName,
	e.LastName,
	sum(i.total) AS "Total Sales",
	round((sum(i.total))*15/100,2) AS "Commission Payout"
FROM
	Employee AS e
INNER JOIN
	Customer AS c
ON
	c.SupportRepId = e.EmployeeId
INNER JOIN
	Invoice AS i
ON
	c.CustomerId = i.CustomerId
WHERE 
	(i.InvoiceDate >= "2011-01-01" AND i.InvoiceDate <= "2012-12-31")
GROUP BY
e.FirstName,
e.LastName															
ORDER BY 
	e.LastName
	
-- Which Employee made the highest commission?
-- Jane Peacock $ 199.77


-- List of the customers that James Peacock Supported


SELECT
	c.FirstName AS "Customer FN",
	c.LastName AS "Customer LN",
	e.FirstName AS "Employee FN",
	e.LastName AS "Employee FN",
	sum(i.total) AS "Total Sales",
	round((sum(i.total))*15/100,2) AS "Commission Payout"
FROM
	Employee AS e
INNER JOIN
	Customer AS c
ON
	c.SupportRepId = e.EmployeeId
INNER JOIN
	Invoice AS i
ON
	c.CustomerId = i.CustomerId
WHERE 
	(i.InvoiceDate >= "2011-01-01" AND i.InvoiceDate <= "2012-12-31") AND e.EmployeeId = 3
GROUP BY
	c.FirstName,
	c.LastName,
	e.FirstName,
	e.LastName
ORDER BY 
	"Total Sales" DESC

	
-- Take a look at the customer who has the highest sales, Does it look suspicious?

SELECT 
	*
FROM
	Customer
WHERE
	LastName = "Doeein"

	
-- Who can be concluded is our primary person of interest?
-- Jane Peacock

