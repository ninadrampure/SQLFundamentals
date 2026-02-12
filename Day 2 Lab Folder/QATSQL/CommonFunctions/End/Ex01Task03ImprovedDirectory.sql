USE Northwind;

SELECT
	CompanyName,
	LEFT(ContactName, CHARINDEX(' ', ContactName)) AS FirstName,
	SUBSTRING(ContactName, CHARINDEX(' ', ContactName) + 1, 50) AS LastName,
	Phone
FROM
	dbo.Customers

UNION ALL

SELECT
	CompanyName,
	LEFT(ContactName, CHARINDEX(' ', ContactName)) AS FirstName,
	SUBSTRING(ContactName, CHARINDEX(' ', ContactName) + 1, 50) AS LastName,
	Phone
FROM
	dbo.Suppliers
	
UNION ALL

SELECT
	'Northwind Traders',
	FirstName,
	LastName,
	Extension
FROM
	dbo.Employees
	
ORDER BY LastName