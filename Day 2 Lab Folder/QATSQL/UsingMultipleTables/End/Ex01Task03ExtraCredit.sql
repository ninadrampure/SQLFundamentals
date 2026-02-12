USE Northwind;

SELECT
	c.CustomerID,
	c.CompanyName,
	c.ContactName,
	o.OrderID,
	o.OrderDate,
	od.ProductID,
	p.ProductName,
	cat.CategoryName,
	od.Quantity
FROM
	dbo.Customers AS c
JOIN
	dbo.orders AS o
ON
	c.CustomerID = o.CustomerID
JOIN
	dbo.[Order Details] AS od
ON
	o.OrderID = od.OrderID
JOIN
	dbo.Products AS p
ON
	od.ProductID = p.ProductID
JOIN
	dbo.Categories as cat
ON
	p.CategoryID = cat.CategoryID
WHERE
	c.Country = 'UK'
AND
	p.CategoryID = 8
ORDER BY
	c.CompanyName, o.OrderDate
