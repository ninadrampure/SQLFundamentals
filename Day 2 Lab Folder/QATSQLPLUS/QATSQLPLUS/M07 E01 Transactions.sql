/*
QATSQLPLUS - Module 7 Exercise 1 Task 2
*/

USE QATSQLPLUS
GO

DECLARE @ProductID INT = 1
DECLARE @Amount INT = 20

INSERT INTO dbo.BookTransfers VALUES 				                
		(@ProductID,getdate(),'Transfer Out',-@Amount)
UPDATE dbo.BookStock
	SET StockAmount = StockAmount - @Amount
	WHERE ProductID = @ProductID	

