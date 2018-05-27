USE dkwiatkowski;
GO
CREATE VIEW [Active Schedule] AS
SELECT * FROM Schedule S JOIN Buses B ON B.id = S.bus_id WHERE B.breakdown_id IS NULL
GO

CREATE VIEW [Licenses Warnings] AS
SELECT D.id, D.name, D.surname, L.expiration_date FROM Drivers D JOIN Licenses L ON D.licence_id = L.id WHERE DATEPART(year, L.expiration_date) = DATEPART(year, GETDATE())
GO