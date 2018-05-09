USE dkwiatkowski;
GO
CREATE VIEW [Active Schedule] AS
SELECT * FROM Schedule S JOIN Buses B ON B.id = S.bus_id WHERE B.breakdown_id IS NULL