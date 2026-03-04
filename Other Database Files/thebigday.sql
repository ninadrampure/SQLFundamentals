USE Wedding

CREATE TABLE returns(
	Item varchar(20),
	[Desc] varchar(50)
)

CREATE TABLE complaints(
	Item varchar(20),
	[Desc] varchar(50)
)

INSERT INTO [returns](Item, [Desc])
VALUES
('Dinner Jacket', 'Worn and dry cleaned.'),
('Napkins', 'Unopened'),
('Silver Cutlery', 'Used and cleaned.')

INSERT INTO complaints(Item, [Desc])
VALUES
('Band', 'They sucked.'),
('Napkins', 'Name of bride incorrect.'),
('Food', 'All of the guests were sick.')
