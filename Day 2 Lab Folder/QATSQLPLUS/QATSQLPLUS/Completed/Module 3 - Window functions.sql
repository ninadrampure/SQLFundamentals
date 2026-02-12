--Ex 1 Task 1:
SELECT ProductID, TransferDate, TransferAmount
	FROM dbo.BookTransfers

--Ex 1 Task 2:
SELECT ProductID, SUM(TransferAmount) AS Stock	
	FROM dbo.BookTransfers
	GROUP BY ProductID

--Ex 1 Task 3:
SELECT ProductID, TransferDate, TransferAmount, 
	SUM(TransferAmount) OVER 
	(PARTITION BY ProductID ORDER BY TransferDate)
		AS RunningStock
		FROM dbo.BookTransfers

--Ex 2 Task 1a:
SELECT *
	FROM dbo.VendorCourseDelegateCount

--Ex 2 Task 1b:
SELECT *, 
	RANK() OVER (ORDER BY NumberDelegates DESC) 
		AS LeaguePos_Rank,
	DENSE_RANK() OVER (ORDER BY NumberDelegates DESC) 
		AS LeaguePos_DenseRank,
	ROW_NUMBER() OVER (ORDER BY NumberDelegates DESC) 
		AS LeaguePos_Row,
	NTILE(3) OVER (ORDER BY NumberDelegates DESC) 
		AS LeaguePos_Ntile
	FROM dbo.VendorCourseDelegateCount
GO

--Ex 2 Task 2a:
SELECT *
	FROM dbo.VendorCourseDelegateCount
GO

--Ex 2 Task 2b:
SELECT *, RANK() OVER (PARTITION BY Vendorname ORDER BY NumberDelegates DESC)
	FROM dbo.VendorCourseDelegateCount
GO

--Ex 2 Task 2c:
-- Using CTE
WITH Ranked_Courses AS (
	SELECT *, 
		RANK() OVER (PARTITION BY VendorName 
			ORDER BY NumberDelegates DESC) AS LeaguePos
		FROM dbo.VendorCourseDelegateCount
)
SELECT VendorName, CourseName, NumberDelegates 
	FROM Ranked_Courses
	WHERE LeaguePos = 1
GO

-- Using Derived Table
SELECT VendorName, CourseName, NumberDelegates 
	FROM (
		SELECT *, 
				RANK() OVER (PARTITION BY VendorName 
					ORDER BY NumberDelegates DESC) AS LeaguePos
				FROM dbo.VendorCourseDelegateCount
	) AS DT
	WHERE LeaguePos = 1
GO
