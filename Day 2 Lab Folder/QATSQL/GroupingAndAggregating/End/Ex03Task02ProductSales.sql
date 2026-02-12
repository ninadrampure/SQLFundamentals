USE Northwind

SELECT
	ProductID,
	SUM(Quantity * UnitPrice) AS TotalValue
FROM
	dbo.[Order Details]
GROUP BY
	ProductID
ORDER BY
	TotalValue DESC