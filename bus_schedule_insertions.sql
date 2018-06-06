USE dkwiatkowski;
GO
EXEC add_driver 'Karol', 'Krawczyk', 'Okopowa 2/3', '13-3372', 'Poland', 'Warszawa', '2027-12-08', '2012-08-12'; 
EXEC add_driver 'Micha³', 'Kamieñ', 'Skrêtowa 2/3', '22-2234', 'Poland', 'Warszawa', '2022-12-08', '2017-08-12'; 
EXEC add_driver 'Krzysiek', 'Andrzej', 'Chata 2', '12-3456', 'Poland', 'Warszawa', '2012-12-08', '2011-08-12'; 
EXEC add_driver 'Bogus³aw', 'Linda', 'Skrêtowa 2/3', '82-1234', 'Poland', 'Warszawa', '2022-12-08', '2010-08-12'; 
EXEC add_driver 'Ewa', 'Dygant', 'Skrêtowa 2/3', '56-8763', 'Poland', 'Warszawa', '2012-12-08', '2009-08-12'; 
EXEC add_driver 'Magda', 'Gessler', 'Skrêtowa 2/3', '32-0972', 'Poland', 'Warszawa', '2018-12-08', '2016-08-12'; 

INSERT INTO Station VALUES
('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I'), ('J'), ('K'), ('L')
INSERT INTO Lines VALUES
('1'), ('2'), ('3'), ('4')

EXEC add_station_to_route 1, 1, 0;
EXEC add_station_to_route 1, 3, 10;
EXEC add_station_to_route 1, 7, 20;
EXEC add_station_to_route 1, 4, 20;

EXEC add_station_to_route 2, 1, 0;
EXEC add_station_to_route 2, 3, 10;
EXEC add_station_to_route 2, 8, 20;
EXEC add_station_to_route 2, 10, 5;
EXEC add_station_to_route 2, 7, 20;
EXEC add_station_to_route 2, 6, 5;
EXEC add_station_to_route 2, 11, 30;

EXEC add_station_to_route 3, 1, 0;
EXEC add_station_to_route 3, 6, 120;

EXEC add_station_to_route 4, 8, 0;
EXEC add_station_to_route 4, 7, 5;
EXEC add_station_to_route 4, 4, 20;
EXEC add_station_to_route 4, 3, 5;
EXEC add_station_to_route 4, 1, 30;

INSERT INTO [Bus Categories] VALUES 
('Niskopod³ogowy', 'Ten autobus jest dostosowany dla niepe³nosprawnych'),
('Wysokopod³ogowy', 'Ten autobus nie jest dostosowany dla niepe³nosprawnych')

INSERT INTO Buses VALUES
( 'Kacper', 'Volkswagen', (SELECT id FROM [Bus Categories] WHERE [name] = 'Niskopod³ogowy'), NULL),
( 'Maria', 'Ford', (SELECT id FROM [Bus Categories] WHERE [name] = 'Wysokopod³ogowy'), NULL),
( 'Stefan', 'Akcyza', (SELECT id FROM [Bus Categories] WHERE [name] = 'Niskopod³ogowy'), NULL),
( 'Kopiec', 'Kamieñ', (SELECT id FROM [Bus Categories] WHERE [name] = 'Niskopod³ogowy'), NULL),
( 'Mercedes', 'Damian', (SELECT id FROM [Bus Categories] WHERE [name] = 'Wysokopod³ogowy'), NULL)

INSERT INTO Schedule (driver_id, line_id, bus_id, start_time) VALUES
(1, 1, 1, '7:30'), (2, 2, 3, '8:10'), (1, 2, 3, '18:40')


INSERT INTO Schedule (driver_id, line_id, bus_id, start_time) VALUES
 (1, 2, 3, '10:40')

 INSERT INTO Breakdowns (description, type) VALUES
 ('Spali³ siê', 'bardzo Ÿle'), ('Podwozie uszkodzone', 'mo¿e byæ')

 UPDATE Buses SET breakdown_id = 1 WHERE id = 5 








