/*
QATSQLPLUS - Module 6 Exercise 3 Task 2
*/

USE QATSQLPLUS
GO

DECLARE @Vendor VARCHAR(30) = 'QA'
UPDATE dbo.Vendor
	SET VendorName = @Vendor
	WHERE VendorID = 1
