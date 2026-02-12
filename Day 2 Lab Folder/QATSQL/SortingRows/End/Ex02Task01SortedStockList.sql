USE Northwind

SELECT
	ProductID,
	ProductName,
	UnitPrice,
	UnitsInStock,
	UnitsOnOrder,
	UnitPrice * UnitsInStock AS CurrentStockValue,
	(UnitsInStock + UnitsOnOrder) * UnitPrice AS FutureStockValue
FROM
	dbo.Products