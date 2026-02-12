---- Ex 1 Task 1	

--TASK 1:
EXEC sp_addmessage 50003,16,'Vendor %s cannot be found'
GO

---- Ex 1 Task 2	

--TASK 2:
RAISERROR(50003,16,1,'Red Hat')
GO

-- Ex 2 Task 1	--TASK 1:
DECLARE @Vendor VARCHAR(100)
SET @Vendor = 'QA'

IF @Vendor IS NULL
	BEGIN
		PRINT 'Vendor must not be NULL'
		RETURN
	END

IF NOT EXISTS (SELECT * FROM dbo.Vendor WHERE VendorName = @Vendor)
	BEGIN
		PRINT 'Vendor ' + @Vendor + ' does not exist'
		RETURN
	END

SELECT *
	FROM dbo.Course AS C
		INNER JOIN dbo.Vendor AS V
			ON C.VendorID = V.VendorID
	WHERE VendorName = @Vendor	
GO

---- Ex 2 Task 2	

--TASK 2:
DECLARE @Vendor VARCHAR(100)
SET @Vendor = 'QA'

IF @Vendor IS NULL
	BEGIN;
		THROW 54000,'Vendor must not be NULL',1
		RETURN
	END

IF NOT EXISTS (SELECT * FROM dbo.Vendor WHERE VendorName = @Vendor)
	BEGIN;
		THROW 54000,'Vendor cannot be found',1
		RETURN
	END

SELECT *
	FROM dbo.Course AS C
		INNER JOIN dbo.Vendor AS V
			ON C.VendorID = V.VendorID
	WHERE VendorName = @Vendor	
GO

Ex 2 Task 3	--TASK 3:
DECLARE @Vendor VARCHAR(100)
SET @Vendor = 'AQ'

IF @Vendor IS NULL
	BEGIN;
		THROW 54000, 'Vendor must not be NULL',1
		RETURN
	END

IF NOT EXISTS (SELECT * FROM dbo.Vendor WHERE VendorName = @Vendor)
	BEGIN
		DECLARE @msg VARCHAR(100)
		SET @msg = FORMATMESSAGE('Vendor %s cannot be found.',@Vendor);
		THROW 54000,@msg ,1
		RETURN
	END

SELECT *
	FROM dbo.Course AS C
		INNER JOIN dbo.Vendor AS V
			ON C.VendorID = V.VendorID
	WHERE VendorName = @Vendor

-- Ex 3 Task 2	

BEGIN TRY
	UPDATE dbo.Vendor
		SET VendorName = NULL
		WHERE VendorID = 1
END TRY
BEGIN CATCH
	THROW 60000,'Error occurred within the procedure',1
END CATCH
GO
