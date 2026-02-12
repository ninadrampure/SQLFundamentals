--Ex 1 Task 1	
SELECT *
	FROM dbo.VendorCourseDateDelegateCount

--Ex 1 Task 2
SELECT VendorName, StartDate, NumberDelegates
	FROM dbo.VendorCourseDateDelegateCount

--Ex 1 Task 2b:
SELECT *
	FROM (SELECT VendorName, StartDate, NumberDelegates
		FROM dbo.VendorCourseDateDelegateCount) AS BaseData

--Ex 1 Task 2c:
SELECT *
	FROM (SELECT VendorName, StartDate, NumberDelegates
		FROM dbo.VendorCourseDateDelegateCount) AS BaseData
	PIVOT
	(SUM(NumberDelegates) FOR VendorName IN (QA, Microsoft, Oracle)) 
		AS Pivotted

--Ex 2 Task 1
SELECT Vendorname, CourseName, StartDate, NumberDelegates
	FROM dbo.VendorCourseDateDelegateCount

--Ex 2 Task 1b:
SELECT Vendorname, CourseName, StartDate, 
		SUM(NumberDelegates) AS TotalDelegates
	FROM dbo.VendorCourseDateDelegateCount
	GROUP BY Vendorname, CourseName, StartDate
GO

--Ex 2 Task 1c:
SELECT Vendorname, CourseName, StartDate, 
		SUM(NumberDelegates) AS TotalDelegates
	FROM dbo.VendorCourseDateDelegateCount
	GROUP BY Vendorname, CourseName, StartDate
		WITH ROLLUP
GO
--Ex 2 Task 2
SELECT Vendorname, CourseName, StartDate, NumberDelegates
	FROM dbo.VendorCourseDateDelegateCount

--Ex 2 Task 2b:
SELECT Vendorname, CourseName, StartDate, 
		SUM(NumberDelegates) AS TotalDelegates
	FROM dbo.VendorCourseDateDelegateCount
	GROUP BY GROUPING SETS (
		(VendorName),
		(Vendorname, CourseName, StartDate)
	)
GO

--Ex 2 Task 2c:
SELECT Vendorname, CourseName, StartDate, 
		SUM(NumberDelegates) AS TotalDelegates,
		GROUPING_ID(VendorName, Coursename, StartDate) AS GroupingType
	FROM dbo.VendorCourseDateDelegateCount
	GROUP BY GROUPING SETS (
		(VendorName),
		(Vendorname, CourseName),
		(Vendorname, CourseName, StartDate)
	)
GO
