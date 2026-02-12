USE Northwind;

SELECT
	c.CompanyName,
	COUNT(o.OrderID) AS NumOrders,
	MIN(o.OrderDate) AS MinDate
FROM
	dbo.Customers AS c
LEFT JOIN
	dbo.Orders AS o
ON
	o.CustomerID = c.CustomerID
GROUP BY
	c.CompanyName
ORDER BY
	NumOrders