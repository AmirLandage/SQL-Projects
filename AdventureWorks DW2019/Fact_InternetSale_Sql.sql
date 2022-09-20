-- Cleaned Fact_InternaetSales Table
SELECT 
	   [ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
      ,[CustomerKey]
--      ,[PromotionKey]
--      ,[CurrencyKey]
--      ,[SalesTerritoryKey]
      ,[SalesOrderNumber]
--      ,[SalesOrderLineNumber]
--      ,[RevisionNumber]
--      ,[OrderQuantity]
--      ,[UnitPrice]
--      ,[ExtendedAmount]
--     ,[UnitPriceDiscountPct]
--      ,[DiscountAmount]
--      ,[ProductStandardCost]
--      ,[TotalProductCost]
      ,[SalesAmount]
--      ,[TaxAmt]
--      ,[Freight]
--      ,[CarrierTrackingNumber]
--      ,[CustomerPONumber]
--      ,[OrderDate]
--      ,[DueDate]
--      ,[ShipDate]
FROM 
	FactInternetSales
WHERE 
	LEFT (OrderDateKey,4) >= 2013
ORDER BY 
	OrderDateKey ASC