USE PaulsDB

CREATE TABLE suppliers(
	SupplierID varchar(4),
	SupplierName varchar(20)
)

CREATE TABLE orders(
	OrderID int,
	SupplierID varchar(4),
	OrderDate int
)

INSERT INTO suppliers(SupplierID, SupplierName)
VALUES
('S1', 'Bricks R Us'),
('S2', 'Roofs U Like'),
('S3', 'Floorboards4All'),
('S4', 'Henrietta Plumbers')

INSERT INTO orders(OrderID, SupplierID, OrderDate)
VALUES
(1001, 'S1', 2023),
(1002, 'S2', 2024),
(1003, 'S5', 2025)


