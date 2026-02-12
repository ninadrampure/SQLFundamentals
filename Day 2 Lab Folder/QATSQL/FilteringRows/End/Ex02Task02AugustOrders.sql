USE Northwind

SELECT
	OrderID,
	CustomerID,
	OrderDate
FROM
	dbo.Orders
WHERE
	(CustomerID = 'ALFKI'
OR
	CustomerID = 'ERNSH'
OR
	CustomerID = 'SIMOB')
AND
	(OrderDate >= '1997/8/1'
AND
	OrderDate <= '1997/8/31')