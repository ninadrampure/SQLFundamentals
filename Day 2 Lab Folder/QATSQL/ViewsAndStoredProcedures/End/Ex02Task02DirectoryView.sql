USE Northwind;
GO

CREATE VIEW dbo.ContactDirectory
AS
SELECT
	CompanyName,
	ContactName,
	Phone
FROM
	dbo.Customers

UNION ALL

SELECT
	CompanyName,
	ContactName,
	Phone
FROM
	dbo.Suppliers

UNION ALL

SELECT
	'Northwind Traders',
	FirstName + ' ' + LastName,
	Extension
FROM
	dbo.Employees