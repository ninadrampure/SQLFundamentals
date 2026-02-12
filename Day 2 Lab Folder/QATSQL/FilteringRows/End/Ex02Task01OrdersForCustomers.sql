USE Northwind

select * from customers 
WHERE
	CustomerID = 'ALFKI'
OR
	CustomerID = 'ERNSH'
OR
	CustomerID = 'SIMOB'
SELECT
	OrderID,
	CustomerID,
	OrderDate
FROM
	dbo.Orders
WHERE
	CustomerID = 'ALFKI'
OR
	CustomerID = 'ERNSH'
OR
	CustomerID = 'SIMOB'