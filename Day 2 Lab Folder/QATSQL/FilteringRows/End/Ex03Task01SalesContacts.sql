USE Northwind

SELECT
	CustomerID,
	CompanyName,
	ContactName,
	ContactTitle,
	Phone
FROM
	dbo.Customers
WHERE
	ContactTitle LIKE 'sales%'