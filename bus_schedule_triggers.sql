USE dkwiatkowski;
GO

CREATE TRIGGER delete_driver ON Drivers
AFTER DELETE AS
BEGIN
	DELETE FROM Licenses WHERE id IN (SELECT licence_id FROM deleted);
	DELETE FROM Addresses WHERE id IN (SELECT address_id FROM deleted);
END 