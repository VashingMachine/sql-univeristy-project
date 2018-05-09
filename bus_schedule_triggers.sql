USE dkwiatkowski;
GO

CREATE TRIGGER delete_driver ON Drivers
AFTER DELETE AS
BEGIN
	DELETE FROM Licenses WHERE id IN (SELECT licence_id FROM deleted);
	DELETE FROM Addresses WHERE id IN (SELECT address_id FROM deleted);
END
GO 

CREATE TRIGGER insert_schedule ON Schedule
INSTEAD OF INSERT AS
BEGIN
	IF NOT EXISTS (SELECT * FROM inserted WHERE dbo.is_driver_busy(driver_id, start_time) = 1)
		INSERT Schedule SELECT * FROM inserted
	ELSE
		PRINT 'Conajmniej jeden z dodanych kierowców jest zajêty w tym czasie'
END
