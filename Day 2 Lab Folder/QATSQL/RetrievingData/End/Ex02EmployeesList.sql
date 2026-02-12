USE Northwind

SELECT
	FirstName + ' ' + LastName AS FullName,
	Extension
FROM
	dbo.Employees