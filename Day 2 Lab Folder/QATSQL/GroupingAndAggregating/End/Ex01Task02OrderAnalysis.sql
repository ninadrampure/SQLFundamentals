USE Northwind

SELECT
	COUNT(*) as NumberOfOrders,
	MIN(OrderDate) as EarliestOrder,
	MAX(OrderDate) as LatestOrder
FROM
	dbo.Orders