USE dkwiatkowski;
GO

CREATE TRIGGER delete_driver ON Drivers
AFTER DELETE AS
BEGIN
	DELETE FROM Licenses WHERE id IN (SELECT licence_id FROM deleted);
	DELETE FROM Addresses WHERE id IN (SELECT address_id FROM deleted);
	IF @@ERROR = 0
	BEGIN 
		RAISERROR('Something went wrond with deleting driver',16,1); 
		ROLLBACK;
	END 
END
GO 

CREATE TRIGGER insert_schedule ON Schedule
AFTER INSERT AS
BEGIN
	IF EXISTS (SELECT * FROM inserted WHERE dbo.is_driver_busy(driver_id, start_time) = 1)
	BEGIN
		RAISERROR('One of the added drivers is actualy busy in given time', 16, 1);
		ROLLBACK;
	END
END
GO

CREATE TRIGGER delete_station ON Station 
INSTEAD OF DELETE AS
BEGIN
	RAISERROR('Use procedure delete_station instead', 16, 1);
END



