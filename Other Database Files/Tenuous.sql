CREATE TABLE tenuous(
	C1 varchar(20),
	C2 varchar(20),
	C3 varchar(20),
	C4 varchar(20)
)

INSERT INTO tenuous(C1,C2,C3,C4)
VALUES
	('Blancmange', 'Meringue', 'Sorbet', 'Yoghurt'),
	(Null, 'Meringue', 'Sorbet', 'Yoghurt'),
	(Null, Null, 'Sorbet', 'Yoghurt'),
	(Null, Null, Null, 'Yoghurt'),
	(Null, Null, Null, Null)

SELECT coalesce(C1,C2,C3,C4, 'No pudding')
FROM tenuous