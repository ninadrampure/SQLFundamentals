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
AND
	CategoryID = 1
AND
	UnitPrice >= 40