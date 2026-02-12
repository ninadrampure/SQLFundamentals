USE Northwind

SELECT
	CustomerID,
	COUNT(OrderID) AS NumberOfOrders
FROM
	dbo.Orders
GROUP BY
	CustomerID