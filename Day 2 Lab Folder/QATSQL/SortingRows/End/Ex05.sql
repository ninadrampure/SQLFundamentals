USE Northwind

SELECT TOP 10
	ProductID,
	ProductName,
	UnitPrice,
	UnitsInStock,
	UnitsOnOrder,
	UnitPrice * UnitsInStock AS CurrentStockValue,
	(UnitsInStock + UnitsOnOrder) * UnitPrice AS FutureStockValue
FROM
	dbo.Products
ORDER BY
	CurrentStockValue DESC