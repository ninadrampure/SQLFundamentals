---- Ex 1 Task 1	
DECLARE @StartDT datetime = GETDATE()
DECLARE @EndDT datetime --@EndDT was not declared
DECLARE @Vendor VARCHAR(50)
PRINT @StartDT
--GO (this GO is not required and stops the variables being
--used in the loop that follows)

DECLARE @X INT = 0
WHILE @X < 100
	BEGIN
		PRINT @X
		SET @X = @X + 1
	END
SET @EndDT = GETDATE()
SELECT @StartDT, @EndDT
GO --GO optional but good practice

IF EXISTS (SELECT * FROM sysobjects WHERE Name = 'NewView')
	DROP VIEW dbo.NewView
GO --GO required before the CREATE VIEW statement

CREATE VIEW dbo.NewView AS
	SELECT * FROM dbo.Delegate
GO --GO optional but good practice

---- Ex 2 Task 1	
--TASK 1:
DECLARE @TotalDelegates INT
SELECT @TotalDelegates = COUNT(*)
	FROM dbo.Delegate
PRINT @TotalDelegates

Ex 3 Task 1	--TASK 1(a):
DECLARE @Vendor VARCHAR(100)
SET @Vendor = 'QA'
SELECT *
	FROM dbo.Course AS C
		INNER JOIN dbo.Vendor AS V
			ON C.VendorID = V.VendorID
	WHERE 
		VendorName = @Vendor
GO

--TASK 1(b):
DECLARE @Vendor VARCHAR(100)
SET @Vendor = NULL
SELECT *
	FROM dbo.Course AS C
		INNER JOIN dbo.Vendor AS V
			ON C.VendorID = V.VendorID
	WHERE 
		VendorName = @Vendor
GO

---- Ex 3 Task 2	
--TASK 2:
DECLARE @Vendor VARCHAR(100)
SET @Vendor = NULL

IF @Vendor IS NULL
	PRINT 'Vendor cannot be NULL'
ELSE
	SELECT *
		FROM dbo.Course AS C
			INNER JOIN dbo.Vendor AS V
				ON C.VendorID = V.VendorID
		WHERE 
			VendorName = @Vendor
GO

---- Ex 3 Task 3	
--TASK 3:
DECLARE @Vendor VARCHAR(100)
SET @Vendor = 'AQ'

IF @Vendor IS NULL
	PRINT 'Vendor cannot be NULL'
ELSE
	IF NOT EXISTS (SELECT * FROM dbo.Vendor WHERE VendorName=@Vendor)
		PRINT 'Vendor name not found'
	ELSE
		SELECT *
			FROM dbo.Course AS C
				INNER JOIN dbo.Vendor AS V
					ON C.VendorID = V.VendorID
			WHERE 
				VendorName = @Vendor
GO

---- Ex 3 Task 4	
--TASK 4:
DECLARE @Vendor VARCHAR(100)
SET @Vendor = 'QA'

IF @Vendor IS NULL
	BEGIN
		PRINT 'Vendor cannot be NULL'
		RETURN
	END

IF NOT EXISTS (SELECT * FROM dbo.Vendor WHERE VendorName=@Vendor)
	BEGIN
		PRINT 'Vendor name not found'
		RETURN
	END

SELECT *
	FROM dbo.Course AS C
		INNER JOIN dbo.Vendor AS V
			ON C.VendorID = V.VendorID
	WHERE 
		VendorName = @Vendor
GO
