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
WHERE
	(UnitsInStock + UnitsOnOrder) * UnitPrice > 2000