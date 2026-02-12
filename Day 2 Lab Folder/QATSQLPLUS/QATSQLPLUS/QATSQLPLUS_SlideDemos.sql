
-- QATSQL Demonstration on slides

------------------------------------------------- Module 1
--slide 4
USE Northwind
GO

CREATE VIEW dbo.Top50Rows AS
	SELECT TOP 50 *
	FROM dbo.Products
GO

SELECT * FROM dbo.Top50Rows
GO

DROP VIEW dbo.Top50Rows
GO

CREATE VIEW dbo.Top50Rows AS
	SELECT TOP 50 *
	FROM dbo.Products
	ORDER BY UnitPrice DESC
GO

SELECT * FROM dbo.Top50Rows
GO

DROP VIEW dbo.Top50Rows
GO

--slide 5
USE AdventureWorks
GO

CREATE VIEW dbo.SaleableProducts AS
	SELECT PSC.name AS Subcategory, P.Name, ListPrice, Color, Weight
	FROM Production.Product AS P
		INNER JOIN Production.ProductSubcategory AS PSC
			ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
GO

SELECT * FROM dbo.SaleableProducts
GO

DROP VIEW dbo.SaleableProducts
GO

--slide 6
CREATE FUNCTION dbo.GetProductsByColour(@Colour varchar(20))
	RETURNS TABLE AS
	RETURN(
		SELECT PSC.Name AS Subcategory, P.Name
			FROM Production.Product AS P
				INNER JOIN Production.ProductSubcategory AS PSC
					ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
			WHERE Color = @Colour
	)
GO

SELECT * FROM dbo.GetProductsByColour('Red')
GO

DROP FUNCTION dbo.GetProductsByColour
GO

-- slide 8
CREATE FUNCTION dbo.GetProductsByColour2(@Colour varchar(20))
	RETURNS @A TABLE(Subcategory varchar(100),Name varchar(100)) 
	AS
	BEGIN
		IF @Colour LIKE '%,%' 
			RETURN
		INSERT INTO @A	
			SELECT PSC.Name AS Subcategory, P.Name
				FROM Production.Product AS P
				INNER JOIN Production.ProductSubcategory AS PSC
					ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
				WHERE Color = @Colour
		RETURN
	END
GO

SELECT * FROM dbo.GetProductsByColour2('Blue')  
GO

DROP FUNCTION dbo.GetProductsByColour2
GO

-- slide 10
SELECT *
	FROM (
		SELECT ProductSubcategoryID, avg(ListPrice) AS AvgPrice
			FROM Production.Product
			GROUP BY ProductSubCategoryID 
	) AS Derivedtable
GO

SELECT *
	FROM (
		SELECT ProductSubcategoryID, avg(ListPrice)
			FROM Production.Product
			GROUP BY ProductSubCategoryID 
	) AS Derivedtable (SubcategoryID, AvgPrice)
GO

-- slide 11
SELECT P.ProductID, P.Name, P.ListPrice, DT.AvgPrice
	FROM Production.Product AS P
	INNER JOIN 
	(
		SELECT ProductSubcategoryID, avg(ListPrice) AS AvgPrice
			FROM Production.Product
			GROUP BY ProductSubcategoryID 
	) AS DT
	ON P.ProductSubcategoryID = DT.ProductSubcategoryID
	WHERE P.ListPrice >= DT.AvgPrice
GO

SELECT P.ProductID, P.Name, P.ListPrice
	FROM  Production.Product AS P
	WHERE P.ListPrice >= (
		SELECT avg(ListPrice) AS AvgPrice
			FROM Production.Product AS P2
			WHERE P.ProductSubcategoryID = P2.ProductSubcategoryID
	)
GO

-- slide 13
WITH Averages AS (
	SELECT ProductSubcategoryID, avg(ListPrice) AS AvgPrice
		FROM Production.Product
		GROUP BY ProductSubcategoryID
)
SELECT P.ProductID, P.Name, P.ListPrice, A.AvgPrice
	FROM Production.Product AS P
		INNER JOIN Averages AS A
			ON P.ProductSubcategoryID = A.ProductSubcategoryID
	WHERE P.ListPrice >= A.AvgPrice
GO

--slide 14
WITH 
Top3Products AS (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY ProductSubcategoryID 
		ORDER BY ListPrice DESC) AS RN
		FROM Production.Product),
AveragePrice AS (
	SELECT ProductSubcategoryID, avg(ListPrice) AS AvgListPrice
		FROM Top3Products
		WHERE RN<=3
		GROUP BY ProductSubcategoryID
	)
SELECT *
	FROM AveragePrice
GO

--slide 15
WITH MakeUp AS (
	SELECT ComponentID, convert(varchar(1000),ComponentID) as APath, PerAssemblyQty
		FROM [Production].[BillOfMaterials]
		WHERE ProductAssemblyID IS NULL AND EndDate IS NULL
UNION ALL
	SELECT B.ComponentID, convert(varchar(1000),MakeUp.APath +'<-'+ convert(varchar(5),B.ComponentID)) ,
		B.PerAssemblyQty
		FROM MakeUp
			INNER JOIN [Production].[BillOfMaterials] AS B
				ON MakeUp.ComponentID = B.ProductAssemblyID
		WHERE B.EndDate IS NULL
)
SELECT DISTINCT M.*, P.Name
	FROM MakeUp AS M
		INNER JOIN Production.Product AS P
			ON M.ComponentID = P.ProductID
	ORDER BY APath
GO

---- slide 15 text
SELECT ComponentID, convert(varchar(1000),ComponentID) as APath, PerAssemblyQty
		FROM [Production].[BillOfMaterials]
		WHERE ProductAssemblyID IS NULL AND EndDate IS NULL
GO

------------------------------------------------- Module 2
--slide 5
SELECT  'Product' as LineType, Name, ProductSubcategoryID, ProductID, ListPrice
	FROM Production.Product
	WHERE ProductSubcategoryID IS NOT NULL
UNION 
SELECT 'Subcategory',Name,ProductSubcategoryID,NULL,NULL
	FROM Production.ProductSubcategory
ORDER BY ProductSubcategoryID, ProductID 
GO

--slide 7
SELECT ProductID, Name, ListPrice
	FROM Production.Product
	WHERE Listprice > 1000
INTERSECT
SELECT ProductID, Name, ListPrice
	FROM Production.Product AS P
	WHERE EXISTS(
		SELECT SUM(OrderQty)
		FROM Sales.SalesOrderDetail AS SOD
		WHERE P.ProductID = SOD.ProductID
		GROUP BY SOD.ProductID
		HAVING SUM(OrderQty) > 1000
	)
GO

--slide 9
SELECT ProductID, Name, ListPrice
	FROM Production.Product
	WHERE Listprice > 2000
EXCEPT
SELECT ProductID, Name, ListPrice
	FROM Production.Product AS P
	WHERE EXISTS(
		SELECT SUM(OrderQty)
		FROM Sales.SalesOrderDetail AS SOD
		WHERE P.ProductID = SOD.ProductID
		GROUP BY SOD.ProductID
		HAVING SUM(OrderQty) > 1000
	)
GO

--slide 11
SELECT PS.Name, TS.NumberOfProducts
	FROM Production.ProductSubcategory AS PS
		CROSS APPLY (
			SELECT COUNT(*) AS NumberOfProducts
			FROM Production.Product AS P
			WHERE P.ProductSubcategoryID = PS.ProductSubcategoryID
			GROUP BY P.ProductSubcategoryID
			HAVING COUNT(*) > 10
		) AS TS
GO

------------------------------------------------- Module 3
--slide 3 text
USE Northwind
GO

CREATE VIEW dbo.CountrySales AS
	SELECT IIF(C.Country ='USA' OR C.Country = 'Canada','North America','Rest of the World')
			AS RegionName
		, C.Country AS CountryName, SUM(OD.UnitPrice*OD.Quantity) AS Sales
		FROM dbo.[Order Details] AS OD
			INNER JOIN dbo.Orders AS O
				ON OD.OrderID = O.OrderID
			INNER JOIN dbo.Customers AS C
				ON O.CustomerID = C.CustomerID
		GROUP BY C.Region, C.Country
GO

SELECT C.* , C.Sales / R.RegionSales AS PercentageSales
    FROM dbo.CountrySales AS C
        INNER JOIN
        ( SELECT RegionName, SUM(Sales) AS RegionSales
            FROM dbo.CountrySales
            GROUP BY RegionName) AS R
        ON C.RegionName = R.RegionName
GO

-- slide 4 text
WITH RegionSales AS (
	 SELECT RegionName, SUM(Sales) AS RegionSales
            FROM dbo.CountrySales
            GROUP BY RegionName
)
SELECT C.* , C.Sales / R.RegionSales AS PercentageSales
    FROM dbo.CountrySales AS C
        INNER JOIN RegionSales AS R
        ON C.RegionName = R.RegionName
GO

SELECT C.* , C.Sales / SUM(Sales) OVER (PARTITION BY RegionName) AS PercentageSales
    FROM dbo.CountrySales AS C
GO

--slide 8
CREATE TABLE dbo.account_transactions(
	PersonRef char(5) not null,
	PayDT date not null,
	TransactionValue money not null
)
INSERT INTO dbo.account_transactions VALUES
	('AAAAA','2019/01/20',400),
	('BBBBB','2019/01/21',200),
	('CCCCC','2019/01/22',300),
	('BBBBB','2019/01/23',400),
	('AAAAA','2019/01/24',100),
	('CCCCC','2019/01/25',200),
	('AAAAA','2019/01/26',400),
	('CCCCC','2019/01/27',500),
	('AAAAA','2019/01/28',100)
SELECT * FROM dbo.account_transactions
GO

SELECT *
	,sum(TransactionValue) OVER () AS TotalAll
	,sum(TransactionValue) OVER (PARTITION BY PersonRef) AS TotalPerson
	,sum(TransactionValue) OVER (PARTITION BY PersonRef ORDER BY PayDT) AS RunningTotalPerson
	,avg(TransactionValue) OVER (PARTITION BY PersonRef ORDER BY PayDT ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AvgLast3Person
	FROM account_transactions
	ORDER BY PersonRef, PayDT
GO
-- keep table for later query

-- slide 10
CREATE TABLE dbo.rank_data(
	Name varchar(30),
	score decimal(5,2)
)
GO

INSERT INTO dbo.rank_data VALUES
	('Alpha',10.0),('Beta',5.5),('Gamma',4.3),('Delta',4.2),
	('Epsilon',9.3),('Zeta',5.9),('Eta',5.9)

SELECT *
	,rank() OVER (ORDER BY score DESC) AS Rank
	,dense_rank() OVER (ORDER BY score DESC) AS Dense_Rank
	,row_number() OVER (ORDER BY score DESC) AS Row_Number
	,ntile(3) OVER (ORDER BY score DESC) AS Ntile
	,convert(decimal(5,4), percent_rank() OVER (ORDER BY score DESC)) AS Percent_Rank
	,convert(decimal(5,4), cume_dist() OVER (ORDER BY score DESC)) AS Cume_Dist
	FROM rank_data
GO

DROP TABLE rank_data
GO

-- slide 14
SELECT *
	, lag(PayDT,1,NULL) OVER (PARTITION BY PersonRef ORDER BY PayDT) AS PrevDT
	, lead(PayDT,1,NULL) OVER (PARTITION BY PersonRef ORDER BY PayDT) AS NextDT
	, first_value(PayDT) OVER (PARTITION BY PersonRef ORDER BY PayDT) AS FirstDT
	, last_value(PayDT) OVER (PARTITION BY PersonRef ORDER BY PayDT
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LastDT
	FROM account_transactions
	ORDER BY PersonRef, PayDT

-- slide 15 text
CREATE TABLE dbo.DemoValues(
	Name VARCHAR(30),
	Value DECIMAL(5,2)
)

INSERT INTO dbo.DemoValues
	VALUES ('A',100),('B',80),('C',40),('D',20),('E',10)

SELECT *
	,convert(decimal(5,4), percent_rank() OVER (ORDER BY Value DESC)) AS Percent_Rank
	,convert(decimal(5,4), cume_dist() OVER (ORDER BY Value DESC)) AS Cume_Dist
	FROM dbo.DemoValues

SELECT DISTINCT Percentile_Cont(0.6) WITHIN GROUP (ORDER BY Value DESC) OVER () AS PC     
	FROM DemoValues

SELECT DISTINCT Percentile_Disc(0.45) WITHIN GROUP (ORDER BY Value DESC) OVER () AS PC     
	FROM DemoValues

-- slide 16 - alternative demo
SELECT DISTINCT 
	AVG(UnitPrice) OVER () AS Mean,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY UnitPrice ASC) OVER () AS Centile25,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY UnitPrice ASC) OVER () AS Median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY UnitPrice ASC) OVER () AS Centile75,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY UnitPrice ASC) OVER () AS NextLowestToMedian
	FROM dbo.Products

------------------------------------------------- Mod 4
-- slide 3
CREATE TABLE dbo.SalesSource(
	Category VARCHAR(20),
	Subcategory VARCHAR(20),
	Quarter char(2),
	Sales int
)
INSERT INTO dbo.SalesSource VALUES
	('Accessories','Tyres','Q1',230),('Accessories','Tyres','Q2',250),
	('Accessories','Tyres','Q3',275),
	('Accessories','Lights','Q1',1000),('Accessories','Lights','Q2',1200),
	('Bikes','Road Bikes','Q1',90),('Bikes','Road Bikes','Q2',82),
	('Bikes','Mountain Bikes','Q1',120),('Bikes','Mountain Bikes','Q2',124),
	('Bikes','Touring Bikes','Q1',102),('Bikes','Touring Bikes','Q2',99)
SELECT * FROM dbo.SalesSource

SELECT *
	FROM (SELECT Category, Quarter, Sales FROM SalesSource) AS A PIVOT
	(SUM(Sales) FOR Quarter IN ([Q1],[Q2],[Q3])) AS B

-- Slide 6
SELECT Category, Quarter, SUM(Sales) AS TotalSales
	FROM SalesSource
	GROUP BY Category, Quarter
		WITH ROLLUP 

-- Slide 7
SELECT Category, Quarter, SUM(Sales) AS Sales
	FROM SalesSource
	GROUP BY Category, Quarter
		WITH CUBE

-- Slide 8
SELECT Category, Quarter, SUM(Sales) AS Sales
	FROM SalesSource
	GROUP BY 
		GROUPING SETS ( (Category) , (Quarter) , () )

-- Slide 10
SELECT Category, Grouping(Category) AS GC, Quarter, 
		Grouping(Quarter) AS GQ, SUM(Sales) AS Sales
	FROM SalesSource
	GROUP BY Category, Quarter
		WITH CUBE

-- Slide 11
SELECT Category, Quarter, SUM(Sales) AS Sales, 
		Grouping_ID(category, Quarter) AS G_ID
	FROM SalesSource
	GROUP BY Category, Quarter
		WITH CUBE
GO

------------------------------------------------- Module 5
-- Slide 4 text

--Batch 1
	PRINT '1'
	GO
--Batch 2
	PRINT '2'
	PRINT @X
	PRINT '3'
	GO
--Batch 3
	PRINT '4'
	GO
GO

-- Slide 5
-- print 50

DECLARE @MyVar INT = 5
PRINT @MyVar * 10
GO

-- print Reset value five times
DECLARE @MyVar VARCHAR(40) = 'Reset value'
PRINT @MyVar
GO 5
GO

-- Slide 6
CREATE VIEW dbo.SalesCategorySummary AS
	SELECT Category, Quarter, SUM(Sales) AS TotalSales
		FROM SalesSource
		GROUP BY Category, Quarter
			WITH CUBE
--GO
CREATE VIEW dbo.PivotQuarters AS
	SELECT *
		FROM (SELECT Category, Quarter, Sales FROM SalesSource) AS A
		PIVOT
		(SUM(Sales) FOR Quarter IN ([Q1],[Q2],[Q3])) AS B
GO

-- Slide 7
CREATE TABLE dbo.DestinationTable(
	ID int,
	TextString VARCHAR(40)
)

-- DestinationTable has two columns (ID INT, TextString VARCHAR(40)) 
INSERT INTO DestinationTable VALUES (1,'One')
INSERT INTO DestinationTable VALUES (2,'Two','Another Value')  -- batch rejected due to 3 columns being presented
SELECT * FROM DestinationTable 

-- DestinationTable has two columns (ID INT, TextString VARCHAR(40)) 
INSERT INTO DestinationTable VALUES (1,'One')
INSERT INTO DestinationTable VALUES ('Two','Minutes') -- batch fails at this step at runtime but steps before ran
SELECT * FROM DestinationTable 
GO

-- Slide 8
USE QATSQLPLUS
GO

DECLARE @NumberOfVendors INT
SELECT @NumberOfVendors = COUNT(*)
    FROM dbo.Vendor
PRINT @NumberOfVendors
GO

-- Slide 10
DECLARE @Today DATETIME
DECLARE @Name VARCHAR(30)
DECLARE @Age INT
DECLARE @Salary MONEY
GO

-- Slide 11 text
USE AdventureWorks
GO

DECLARE @HighestPricedProduct MONEY = 0
SELECT @HighestPricedProduct = MAX(ListPrice)
    FROM production.Product
PRINT @HighestPricedProduct
GO

-- Slide 12 text
DECLARE @Counter INT = 1
SET @Counter = @Counter + 1
SELECT @Counter = @Counter + 1
PRINT @Counter
GO

CREATE PROC dbo.CheckExists @ProductID INT AS
    BEGIN
        IF EXISTS (SELECT * FROM Production.Product WHERE ProductID = @ProductID)
            RETURN 1
        ELSE
            RETURN 0
    END
GO

DECLARE @Exists INT
EXEC @Exists = dbo.CheckExists 3
PRINT @Exists
GO

DROP PROC dbo.CheckExists
GO

-- slide 13 text
CREATE PROC dbo.CheckRating @R INT ASBEGIN
        IF (@R IS NULL)
            RETURN 0
        ELSE
            RETURN @R
    END
GO

DROP PROC dbo.CheckRating
GO

-- slide 14 text
CREATE PROC dbo.CheckExists @ProductID INT AS
    BEGIN
        IF EXISTS (SELECT * FROM Production.Product WHERE ProductID = @ProductID)
            RETURN 1
        ELSE
            RETURN 0
    END
GO

DECLARE @Exists INT
EXEC @Exists = dbo.CheckExists 3
PRINT @Exists
GO

CREATE PROC dbo.ProductSearch @ProductID INT = NULL, @NameSearch VARCHAR(30) = NULL AS
    BEGIN
        DECLARE @SearchString VARCHAR(30) = NULL

        IF (@ProductID IS NOT NULL) 
	BEGIN
                SELECT * FROM Production.Product WHERE ProductID = @ProductID
                RETURN
            END

        IF (@NameSearch IS NOT NULL)
	BEGIN
                SELECT * FROM Production.Product WHERE Name LIKE ('%' +  @NameSearch + '%')
                RETURN
            END

        SELECT * FROM Production.Product
    END
GO

EXEC dbo.ProductSearch @ProductID = 1	-- returns ProductID = 1
EXEC dbo.ProductSearch @NameSearch = 'Ball'	-- returns all rows where Ball is in the name
EXEC dbo.ProductSearch		-- returns all rows
GO

-- Slide 15 -> procedure made to test

CREATE PROC dbo.AddNewcategory @NewSubcategory int, @NewName NVARCHAR(50)
AS
BEGIN
	--- as per slide
	IF EXISTS (SELECT * FROM Production.ProductSubcategory WHERE ProductSubcategoryID=@NewSubcategory)
		PRINT 'That Subcategory ID already exists'
	ELSE
		INSERT INTO Production.ProductSubcategory(ProductSubcategoryID,Name) 
					 VALUES (@NewSubcategory,@NewName)
	-- end as per slide
END
GO

EXEC dbo.AddNewcategory 1,'Already existing subcat'
EXEC dbo.AddNewcategory 99,'New subcat'
GO

-- Slide 16 ---> below intentionally has errors
DECLARE @NewSubcategory INT = 2
DECLARE @NewName NVARCHAR(50) = 'New Subcat'

IF EXISTS (SELECT * FROM Production.ProductSubcategory WHERE ProductSubcategoryID=@NewSubcategory)
	PRINT 'That Subcategory ID already exists'
	SET @result = 0
ELSE -- returns an error as more than one line of code between IF and ELSE
	INSERT INTO Production.ProductSubcategory(ProductSubcategoryID,Name) 
                VALUES (@NewSubcategory,@NewName)
GO

-- Slide 17
DECLARE @NewSubcategory INT = 2
DECLARE @NewName NVARCHAR(50) = 'New Subcat'
DECLARE @ReturnValue INT 

IF EXISTS (SELECT * FROM Production.ProductSubcategory WHERE ProductSubcategoryID=@NewSubcategory)
	BEGIN
		PRINT 'That Subcategory ID already exists'
		SET @ReturnValue = 0
	END
ELSE
	INSERT INTO Production.ProductSubcategory(ProductSubcategoryID,Name) 
                   VALUES (@NewSubcategory,@NewName)
GO

-- Slide 19
DECLARE @Subcategory INT = 9388
DECLARE @NewName NVARCHAR(50) = 'NewProduct'
DECLARE @NewID INT = 1000
DECLARE @ReturnValue INT
IF NOT EXISTS (SELECT ProductSubcategoryID FROM Production.ProductSubcategory WHERE productSubcategoryID = @Subcategory)
	BEGIN
		PRINT 'Subcategory not found'
		RETURN
	END
INSERT INTO Production.Product(ProductID, Name, ProductSubcategoryID)
	VALUES (@NewID, @NewName, @Subcategory)
GO

-- Slide 20
DECLARE @ID INT = 1
WHILE @ID <= 100
    BEGIN
        UPDATE Production.Product
            SET ListPrice = ListPrice * IIF(ListPrice < 1000, 1.10, 1.05)
            WHERE ProductID = @ID
        SET @ID = @ID + 1
    END
GO

-- Slide 21
UPDATE Production.Product
            SET ListPrice = ListPrice * IIF(ListPrice < 1000, 1.10, 1.05)
	
-- Slide 22
DECLARE @SQL VARCHAR(2000)
DECLARE @tableName VARCHAR(50) = 'Production.Product'
SET @SQL = 'SELECT * FROM ' + @tableName
EXECUTE(@SQL)
GO

-- Slide 22 text
DECLARE @DatabaseName VARCHAR(255) = 'Adventureworks'
DECLARE @SQL VARCHAR(2000)
SET @SQL = 'select '+''''+ @DatabaseName + '''' + ', name from ' + @DatabaseName + '.sys.objects where type=''U'' '
EXEC (@SQL)
GO

-- Slide 23 text
CREATE PROC dbo.getProductByName @ProductName VARCHAR(50) AS
    BEGIN
        DECLARE @SQL VARCHAR(300) = 'SELECT * FROM Production.Product'
        IF (@ProductName IS NOT NULL)
            SET @SQL = @SQL + ' WHERE Name = ' + '''' + @ProductName + ''''
        PRINT @SQL
        EXEC (@SQL)
   END
GO
EXEC dbo.getProductByName NULL	-- all rows
EXEC dbo.getProductByName 'Bearing Ball'	-- Bearing ball row
EXEC dbo.getProductByName 'Any old rubbish'	-- no rows
EXEC dbo.getProductByName ''' some thing '	-- error as extra quote in string
GO

DROP PROC dbo.getProductByName
GO

CREATE PROC dbo.getProductByName @ProductName VARCHAR(50) AS
    BEGIN
        IF (@ProductName IS NULL)
            SELECT * FROM Production.Product        
        ELSE
	SELECT * FROM Production.Product WHERE Name = @ProductName
   END
GO

-- trials with parameters
EXEC dbo.getProductByName NULL				-- all rows
EXEC dbo.getProductByName 'Bearing Ball'	-- Bearing ball row
EXEC dbo.getProductByName 'Any old rubbish'	-- no rows
EXEC dbo.getProductByName ''' some thing '	-- no rows
GO

-- Slide 26
DECLARE @DBName VARCHAR(100)
DECLARE @SQL VARCHAR(2000)
DECLARE @Results TABLE (DBName VARCHAR(100), TableName VARCHAR(200))
DECLARE DBCursor CURSOR FOR SELECT Name FROM sys.databases 
OPEN DBCursor
FETCH NEXT FROM DBCursor INTO @DBName
WHILE @@Fetch_Status = 0
	BEGIN
	SET @SQL = 'SELECT ' + '''' + @DBName + '''' + ', Name FROM [' + @DBName +'].sys.tables'
	INSERT INTO @Results
		EXEC(@SQL)
	FETCH NEXT FROM DBCursor INTO @DBName
	END
CLOSE DBCursor
DEALLOCATE DBCursor
SELECT * FROM @Results
GO

------------------------------------------------- Module 6
-- Slide 4
USE MSDB
GO
EXEC sp_addmessage 50200,16,'Customer %d has been deleted by %s.'
SELECT * FROM sys.messages
DECLARE @msg VARCHAR(100) = FORMATMESSAGE(50200, 2345, 'Fred Jones')
PRINT @msg
GO

-- Slide 5 text
EXEC sp_addmessage 50003,16,'An error has been found in the %s column'
GO

DECLARE @ErrorMsg VARCHAR(100);
SET @ErrorMsg = FORMATMESSAGE(50003,'ProductID');
THROW 50003,@ErrorMsg,1
GO

DECLARE @ErrorMsg VARCHAR(100);
SET @ErrorMsg = FORMATMESSAGE('The table %s has been changed since the view %s was created','tbl_Source','tbl_ReadRows');
THROW 60000,@ErrorMsg,1
GO

-- Slide 8
DECLARE @numerator DECIMAL(5,2) =  5.8
DECLARE @denominator DECIMAL(5,2) = 0.0

BEGIN TRY
	SELECT @numerator / @denominator AS fraction
END TRY
BEGIN CATCH
	PRINT 'An error was caught : ' + error_message()
END CATCH
GO

-- Slide 9
USE QATSQLPLUS
GO

CREATE TABLE dbo.Customers(
	ID INT PRIMARY KEY,
	NewBalance MONEY CHECK (NewBalance >= 0)
)

INSERT INTO dbo.Customers VALUES (120,90) -- customer 120 has £90 in bank
GO

DECLARE @CustomerID INT = 120
DECLARE @Amount MONEY = 95.00

BEGIN TRY
	UPDATE dbo.Customers SET NewBalance = NewBalance - @Amount WHERE ID = @CustomerID
END TRY
BEGIN CATCH
	RAISERROR('The customer %d could not be updated', 16 , 1, @CustomerID)
END CATCH
GO

-- keep table as used later

-- Slide 10
EXEC sp_addmessage 50090,14,'Error : not enough stock for product %s (only %d available and sale requires %d)'

--RAISERROR using pre-created message ID:
RAISERROR (50090, 14, 1, 'Apples', 20, 100)

--RAISERROR using message text
RAISERROR ('Error : not enough stock for product %s (only %d available and sale requires %d)',14,1, 'Apples', 50, 59)
GO

-- Slide 11
EXEC sp_addmessage 50004,16,'Customer %d does not have the funds'
GO

DECLARE @CustomerID INT = 120
DECLARE @Amount MONEY = 95.00
BEGIN TRY
	UPDATE dbo.Customers SET NewBalance = NewBalance - @Amount WHERE ID = @CustomerID
END TRY
BEGIN CATCH
	DECLARE @msg VARCHAR(100) = FORMATMESSAGE(50004, @CustomerID);
	THROW 50004,@msg, 1
END CATCH
GO

DROP TABLE dbo.Customers
GO

-- Slide 12 text
EXEC sp_dropmessage 50090
GO
EXEC sp_addmessage 50090,14,'Error : not enough stock for product %s (only %d available and sale requires %d)'
GO

--THROW using pre-created message ID:
DECLARE @ErrMsg VARCHAR(300)
SET @ErrMsg = FORMATMESSAGE(50090, 'Apples', 20, 100);
THROW 50090, @Errmsg, 1
GO

--THROW using message text
DECLARE @ErrMsg VARCHAR(300)
SET @ErrMsg = FORMATMESSAGE('Error : not enough stock for product %s (only %d available and sale requires %d)','Apples'
	, 20, 100);
THROW 50090, @Errmsg, 1
GO

------------------------------------------------- Module 7
USE QATSQLPLUS
GO
-- drop table dbo.CurrentAccount
CREATE TABLE dbo.CurrentAccount(
	AcctNo INT PRIMARY KEY,
	Balance MONEY CHECK (Balance >= 0)
)

INSERT INTO dbo.CurrentAccount VALUES (12343422,45) -- customer 12343422 has £45 in bank
GO

CREATE TABLE dbo.CashPointTrans(
	AcctNo INT,
	TranDT DATETIME,
	MachineID INT,
	TranValue MONEY
)

SELECT * FROM dbo.CashPointTrans
SELECT * FROM dbo.CurrentAccount
GO

DECLARE @AccountNo INT = 12343422
DECLARE @Machine INT = 23321
DECLARE @Amount MONEY = 50.00
BEGIN TRY
	BEGIN TRAN
		INSERT INTO dbo.CashpointTrans(AcctNo, TranDT, MachineID, TranValue)
			VALUES (@AccountNo,getdate(),@Machine, @Amount)
		UPDATE dbo.CurrentAccount
			SET Balance = Balance - @Amount
			WHERE AcctNo = @AccountNo
	COMMIT TRAN
END TRY
BEGIN CATCH
	Print 'Error was caught';
	THROW
END CATCH
