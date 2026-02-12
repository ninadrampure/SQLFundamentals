USE Northwind;

SELECT
	c.CompanyName,
	COUNT(o.OrderID) AS NumOrders,
	MIN(o.OrderDate) AS MinDate
FROM
	dbo.Customers AS c
LEFT OUTER JOIN
	dbo.Orders AS o
ON
	o.CustomerID = c.CustomerID
WHERE
	YEAR(o.OrderDate) = 1996
GROUP BY
	c.CompanyName
ORDER BY
	NumOrders
