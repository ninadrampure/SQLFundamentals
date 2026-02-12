USE Northwind

SELECT TOP 10
	ProductID,
	ProductName,
	UnitPrice
FROM
	dbo.Products
ORDER BY
	UnitPrice DESC