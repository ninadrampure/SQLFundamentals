USE Northwind

SELECT
	ProductID,
	SUM(Quantity * UnitPrice) AS TotalValue
FROM
	dbo.[Order Details]
GROUP BY
	ProductID
HAVING
	SUM(Quantity * UnitPrice) <= 5000
ORDER BY
	TotalValue DESC