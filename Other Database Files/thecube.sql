CREATE TABLE SalesSource(
    Cat varchar(20),
	Sub varchar(20),
    Qtr varchar(20),
    Sale decimal
)

INSERT INTO SalesSource(Cat, Sub, Qtr, Sale)
VALUES
('Accessories','Tyres','Q1',230),
('Accessories','Tyres','Q2',250),
('Accessories','Tyres','Q3',275),
('Accessories','Lights','Q1',1000),
('Accessories','Lights','Q2',1200),
('Bikes','Road Bikes','Q1',90),
('Bikes','Road Bikes','Q2',82),
('Bikes','Mountain Bikes','Q1',120),
('Bikes','Mountain Bikes','Q2',124),
('Bikes','Touring Bikes','Q1',102),
('Bikes','Touring Bikes','Q2',99)

SELECT Cat, Qtr, SUM(Sale) AS Sale,
Grouping_ID(cat, Qtr)
AS G_ID
FROM SalesSource
GROUP BY Cat, Qtr
WITH CUBE