USE dkwiatkowski;
GO
EXEC add_driver 'Karol', 'Krawczyk', 'Okopowa 2/3', '13-3372', 'Poland', 'Warszawa', '2027-12-08', '2012-08-12'; 
EXEC add_driver 'Micha³', 'Kamieñ', 'Skrêtowa 2/3', '22-2234', 'Poland', 'Warszawa', '2022-12-08', '2017-08-12'; 
EXEC add_driver 'Krzysiek', 'Andrzej', 'Chata 2', '12-3456', 'Poland', 'Warszawa', '2012-12-08', '2011-08-12'; 
EXEC add_driver 'Bogus³aw', 'Linda', 'Skrêtowa 2/3', '82-1234', 'Poland', 'Warszawa', '2022-12-08', '2010-08-12'; 
EXEC add_driver 'Ewa', 'Dygant', 'Skrêtowa 2/3', '56-8763', 'Poland', 'Warszawa', '2012-12-08', '2009-08-12'; 
EXEC add_driver 'Magda', 'Gessler', 'Skrêtowa 2/3', '32-0972', 'Poland', 'Warszawa', '2018-12-08', '2016-08-12'; 

SELECT * FROM Drivers;
SELECT * FROM Licenses;

DELETE FROM Drivers WHERE id = 1;



