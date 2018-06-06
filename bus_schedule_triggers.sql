USE dkwiatkowski;
GO

CREATE TRIGGER delete_driver ON Drivers
AFTER DELETE AS
BEGIN
	BEGIN TRAN
	DELETE FROM Licenses WHERE id IN (SELECT licence_id FROM deleted);
	DELETE FROM Addresses WHERE id IN (SELECT address_id FROM deleted);
	IF @@ERROR = 0
	BEGIN 
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() as ErrorState,
			ERROR_LINE () as ErrorLine,
			ERROR_PROCEDURE() as ErrorProcedure,
			ERROR_MESSAGE() as ErrorMessage;
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
		ROLLBACK TRAN;
	END 
	COMMIT TRAN;
END
GO 

CREATE TRIGGER insert_licence ON Licenses
AFTER INSERT AS
BEGIN
	IF EXISTS (SELECT * FROM inserted WHERE expiration_date < creation_date)
	BEGIN
		RAISERROR('One of the drivers licenses were unappropriate', 16 , 0);
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

	IF EXISTS (SELECT * FROM inserted WHERE dbo.working_hours(driver_id) > '8:00')
	RAISERROR('One of the added drivers is going to work more than 8 hours in schedule', 16, 2);
END
GO

CREATE TRIGGER delete_station ON Station 
INSTEAD OF DELETE AS
BEGIN
	RAISERROR('Use procedure delete_station instead', 16, 1);
END
GO

CREATE TRIGGER add_to_routes ON [Line Routes]
INSTEAD OF INSERT AS
BEGIN
	DECLARE inserted_cursosr CURSOR LOCAL FOR SELECT * FROM [Line Routes];
	DECLARE @station_id INT,
			@line_id INT,
			@order_index INT,
			@delta_time INT;
	OPEN inserted_cursosr;
	FETCH NEXT FROM inserted_cursosr INTO @station_id, @line_id, @order_index, @delta_time;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC add_station_to_route @line_id, @station_id, @delta_time, @order_index;
		FETCH NEXT FROM inserted_cursosr INTO @station_id, @line_id, @order_index, @delta_time;
	END
	CLOSE inserted_cursosr;
	DEALLOCATE inserted_cursosr;
END
GO 






