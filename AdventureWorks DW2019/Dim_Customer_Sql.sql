-- Cleaned Dim_Customer Table
SELECT 
c.CustomerKey AS CustomerKey,
--      ,[GeographyKey]
--      ,[CustomerAlternateKey]
--      ,[Title]
c.firstname AS [FirstName],
--      ,[MiddleName]
c.lastname AS  [LastName],
c.FirstName + ' ' + c.LastName AS [Full Name],
--      ,[NameStyle]
--      ,[BirthDate]
--      ,[MaritalStatus]
--      ,[Suffix]

CASE 
	c.gender 
	WHEN 'M'
	THEN 'Male'
	WHEN 'F'
	THEN 'Female'
	END AS Gender,
--     ,[EmailAddress]
--      ,[YearlyIncome]
--      ,[TotalChildren]
--      ,[NumberChildrenAtHome]
--      ,[EnglishEducation]
--      ,[SpanishEducation]
--      ,[FrenchEducation]
--      ,[EnglishOccupation]
--      ,[SpanishOccupation]
--     ,[FrenchOccupation]
--      ,[HouseOwnerFlag]
--      ,[NumberCarsOwned]
--      ,[AddressLine1]
--      ,[AddressLine2]
--      ,[Phone]
c.DateFirstPurchase AS DateFirstPurchase,
--      [CommuteDistance]
g.city AS [Customer City] -- Joined in Customer City from Geograpy Table
FROM 
	DimCustomer AS c
	LEFT JOIN DimGeography AS g ON g.geographykey = c.geographykey
ORDER BY 
	CustomerKey ASC  -- Ordered List by Customerkey