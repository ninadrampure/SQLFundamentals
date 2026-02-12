
-- Ex 1 Task 1	
SELECT V.VendorName, C.CourseName, C.CourseID
	FROM dbo.Vendor AS V
		INNER JOIN dbo.Course AS C
			ON V.VendorID = C.VendorID
-- Ex 1 Task 2	
CREATE VIEW dbo.CourseList AS
	SELECT V.VendorName, C.CourseName, C.CourseID
		FROM dbo.Vendor AS V
			INNER JOIN dbo.Course AS C
				ON V.VendorID = C.VendorID
GO

SELECT * FROM dbo.CourseList

-- Ex 2 Task 1	
SELECT D.DelegateID, 
	SUM(CR.DurationDays) AS DelegateDays,
	COUNT(*) AS DelegateCourses
	FROM dbo.Delegate AS D
		INNER JOIN dbo.DelegateAttendance AS DA
			ON D.DelegateID = DA.DelegateID
		INNER JOIN dbo.CourseRun AS CR
			ON CR.CourseRunID = DA.CourseRunID
	GROUP BY D.DelegateID

-- Ex 2 Task 2	
CREATE FUNCTION udf_DelegateDays()
	RETURNS TABLE
	AS 
	RETURN (
		SELECT D.DelegateID, SUM(CR.DurationDays) AS DelegateDays,
				COUNT(*) AS DelegateCourses
			FROM dbo.Delegate AS D
				INNER JOIN dbo.DelegateAttendance AS DA
					ON D.DelegateID = DA.DelegateID
				INNER JOIN dbo.CourseRun AS CR
					ON CR.CourseRunID = DA.CourseRunID
			GROUP BY D.DelegateID
	)
GO 
SELECT * FROM dbo.udf_DelegateDays()

-- Ex 2 Task 3	
CREATE FUNCTION dbo.udf_IndividualDelegateDays(@DelegateID INT)
	RETURNS TABLE 
	AS
	RETURN(
		SELECT @DelegateID AS DelegateID, 
				SUM(CR.DurationDays) AS DelegateDays,
				COUNT(*) AS DelegateCourses
			FROM dbo.Delegate AS D
				INNER JOIN dbo.DelegateAttendance AS DA
					ON D.DelegateID = DA.DelegateID
				INNER JOIN dbo.CourseRun AS CR
					ON CR.CourseRunID = DA.CourseRunID
			WHERE D.DelegateID = @DelegateID
	)
GO
SELECT * FROM dbo.udf_IndividualDelegateDays(1)

-- Ex 3 Task 1	
SELECT CourseRunID, StartDate
	FROM dbo.Trainer AS T
		INNER JOIN dbo.CourseRun AS CR
			ON T.TrainerID = CR.TrainerID
	WHERE TrainerName = 'Jason Bourne'

-- Ex 3 Task 2	
SELECT D.DelegateID, D.DelegateName, D.CompanyName, JB.StartDate
	FROM dbo.Delegate AS D
		INNER JOIN dbo.DelegateAttendance AS DA
			ON D.DelegateID = DA.DelegateID
		INNER JOIN (
			SELECT CourseRunID, StartDate
				FROM dbo.Trainer AS T
					INNER JOIN dbo.CourseRun AS CR
						ON T.TrainerID = CR.TrainerID
				WHERE TrainerName = 'Jason Bourne'
			) AS JB
			ON DA.CourseRunID = JB.CourseRunID

-- Ex 4 Task 1	
SELECT CourseRunID, StartDate
	FROM dbo.Trainer AS T
		INNER JOIN dbo.CourseRun AS CR
			ON T.TrainerID = CR.TrainerID
	WHERE TrainerName = 'Jason Bourne'

-- Ex 4 Task 2	
WITH BourneCourses AS (
	SELECT CourseRunID, StartDate
		FROM dbo.Trainer AS T
			INNER JOIN dbo.CourseRun AS CR
				ON T.TrainerID = CR.TrainerID
		WHERE TrainerName = 'Jason Bourne'
)
SELECT * 
	FROM BourneCourses

-- Ex 4 Task 3	
WITH BourneCourses AS (
	SELECT CourseRunID, StartDate
		FROM dbo.Trainer AS T
			INNER JOIN dbo.CourseRun AS CR
				ON T.TrainerID = CR.TrainerID
		WHERE TrainerName = 'Jason Bourne'
)
SELECT D.DelegateID, D.DelegateName, D.CompanyName, JB.StartDate
	FROM dbo.Delegate AS D
		INNER JOIN dbo.DelegateAttendance AS DA
			ON D.DelegateID = DA.DelegateID
		INNER JOIN BourneCourses AS JB
			ON DA.CourseRunID = JB.CourseRunID
-- Ex 5 Task 1	
SELECT *
	FROM dbo.Course
	WHERE VendorID = 2

-- Ex 5 Task 2	
SELECT * INTO #MicrosoftLocal
	FROM dbo.Course	WHERE VendorID = 2
SELECT * INTO ##MicrosoftGlobal
	FROM dbo.Course	WHERE VendorID = 2
GO

SELECT *
	FROM #MicrosoftLocal

SELECT *
	FROM ##MicrosoftGlobal
GO

