USE Northwind

SELECT
	ProductID,
	SUM(Quantity) AS TotalSold
FROM
	dbo.[Order Details]
GROUP BY
	ProductID