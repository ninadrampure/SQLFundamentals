USE Northwind

SELECT
	ProductID,
	ProductName,
	CategoryID,
	Discontinued,
	UnitPrice
FROM
	dbo.Products
WHERE
	Discontinued = 0
ORDER BY
	CategoryID