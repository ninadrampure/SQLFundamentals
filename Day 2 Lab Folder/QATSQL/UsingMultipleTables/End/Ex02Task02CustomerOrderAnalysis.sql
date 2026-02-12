USE Northwind;

--SELECT COUNT(*) FROM dbo.Customers

SELECT
	c.CompanyName,
	COUNT(o.OrderID) AS NumOrders
FROM
	dbo.Customers AS c
JOIN
	dbo.Orders AS o
ON
	o.CustomerID = c.CustomerID
GROUP BY
	c.CompanyName
ORDER BY
	NumOrders