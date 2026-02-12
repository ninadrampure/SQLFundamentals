--Ex 1 Task 1 :
SELECT ContactName, PhoneNumber
	FROM dbo.Vendor

--Ex 1 Task 2 :
SELECT TrainerName, PhoneNumber
	FROM dbo.Trainer

--Ex 1 Task 3 (1a) :
SELECT ContactName, PhoneNumber
	FROM dbo.Vendor
UNION 
SELECT TrainerName, PhoneNumber
	FROM dbo.Trainer

--Ex 1 Task 3 (1b) :
SELECT ContactName, PhoneNumber
	FROM dbo.Vendor
UNION ALL
SELECT TrainerName, PhoneNumber
	FROM dbo.Trainer

--Ex 1 Task 3 (3) :
SELECT 'Vendor' AS ContactType,ContactName, PhoneNumber
	FROM dbo.Vendor
UNION
SELECT 'Trainer' AS ContactType,TrainerName, PhoneNumber
	FROM dbo.Trainer

----Ex 2	

USE QATSQLPLUS
GO

--Ex 2 Task 1:
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQL'
--Ex 2 Task 2:
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQLPLUS'

--Ex 2 Task 3:
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQL'
INTERSECT
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQLPLUS'
GO

--Ex 3 Task 1:
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQL'
EXCEPT
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQLPLUS'
--Ex 3 Task 2:
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQLPLUS'
EXCEPT
SELECT DelegateID
	FROM dbo.DelegateAttendance AS DA
		INNER JOIN dbo.CourseRun AS CR
			ON DA.CourseRunID = CR.CourseRunID
		INNER JOIN dbo.Course AS C
			ON C.CourseID = CR.CourseID
	WHERE C.CourseName = 'QATSQL'

