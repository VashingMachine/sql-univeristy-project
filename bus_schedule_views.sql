USE dkwiatkowski;
GO
CREATE VIEW [Active Schedule] AS
SELECT S.* FROM Schedule S JOIN Buses B ON B.id = S.bus_id WHERE B.breakdown_id IS NULL
GO

CREATE VIEW [Licenses Warnings] AS
SELECT D.id, D.name, D.surname, L.expiration_date FROM Drivers D JOIN Licenses L ON D.licence_id = L.id WHERE DATEPART(year, L.expiration_date) = DATEPART(year, GETDATE())
GO

CREATE VIEW [Drivers Working Hours] AS
SELECT name, surname, COALESCE( dbo.working_hours(id), '0:00' ) AS hours FROM Drivers;

