USE dkwiatkowski;
GO
CREATE PROCEDURE add_driver 
	@name NVARCHAR(45),
	@surname NVARCHAR(45),
	@street nvarchar(100),
	@postcode nvarchar(20),
	@country nvarchar(45),
	@city nvarchar(45),
	@expiration_date date,
	@creation_date date
AS
BEGIN
	INSERT INTO Licenses VALUES (@expiration_date, @creation_date);
	DECLARE @license_id INT;
	SET @license_id = @@IDENTITY;

	INSERT INTO Addresses VALUES (@street, @postcode, @country, @city);
	DECLARE @address_id INT;
	SET @address_id = @@IDENTITY;

	INSERT INTO Drivers VALUES (@name, @surname, @license_id, @address_id);
END
GO
CREATE PROCEDURE add_station_to_route
	@line_id INT,
	@station_id INT,
	@delta_time INT,
	@order_index INT = NULL
AS
BEGIN
	DECLARE @index INT;
	SET @index = COALESCE(@order_index, (SELECT MAX( LR.order_index ) + 1 FROM [Line Routes] LR JOIN Lines L ON L.id = LR.line_id WHERE @line_id = L.id), 0)

	UPDATE [Line Routes] SET order_index = order_index + 1 WHERE order_index >= @order_index
	INSERT INTO [Line Routes] VALUES (@station_id, @line_id, @index, @delta_time)
END
GO

CREATE PROCEDURE delete_station_proc
	@station_id INT
AS
BEGIN
	EXEC('DISABLE TRIGGER delete_station ON Station');

	WITH CTE AS (
		SELECT * FROM [Line Routes] LR WHERE line_id in (SELECT DISTINCT line_id FROM [Line Routes] WHERE station_id = @station_id)
		AND order_index > (SELECT order_index FROM [Line Routes] LRR WHERE LRR.line_id = LR.line_id AND station_id = @station_id)
	)
	UPDATE CTE SET order_index = order_index - 1;

	DELETE FROM [Line Routes] WHERE station_id = @station_id;

	DELETE FROM Station WHERE id = @station_id;

	EXEC('ENABLE TRIGGER delete_station ON Station');
END
GO

CREATE PROCEDURE breakdown_check
AS
BEGIN
	SELECT COUNT(*) as [Broken Buses], (SELECT COUNT(*) FROM Buses WHERE category_id = B.category_id) as [All of the Category], category_id FROM Buses B JOIN [Bus Categories] BS ON BS.id = B.category_id WHERE breakdown_id IS NOT NULL GROUP BY category_id
	SELECT BR.type as Type, COUNT(*) AS Broken FROM Buses BS JOIN Breakdowns BR ON BR.id = BS.breakdown_id GROUP BY BR.type
END
GO

CREATE FUNCTION route_from_a_to_b
(@station_a nvarchar(45), @station_b nvarchar(45))
RETURNS @traces TABLE 
(
	distance INT NOT NULL,
	line_id INT NOT NULL
) AS
BEGIN

	DECLARE @a INT;
	DECLARE @b INT;
	SET @a = (SELECT id FROM Station WHERE @station_a = name)
	SET @b = (SELECT id FROM Station WHERE @station_b = name)
	
	INSERT @traces(distance, line_id)
	SELECT SUM(delta_time) as distance, line_id FROM [Line Routes] LR WHERE line_id IN 
	(
		SELECT line_id FROM [Line Routes] WHERE line_id IN 
		(SELECT line_id FROM [Line Routes] WHERE @a = station_id)
		AND @b = station_id
	) 
	AND order_index > (SELECT order_index FROM [Line Routes] LRI WHERE @a = station_id AND LRI.line_id = LR.line_id )
	AND order_index <= (SELECT order_index FROM [Line Routes] LRII WHERE @b = station_id AND LRII.line_id = LR.line_id)
	GROUP BY line_id RETURN

END
GO

CREATE FUNCTION route_distance (@line_id INT)
RETURNS INT
BEGIN
	RETURN (SELECT SUM(delta_time) FROM [Line Routes] WHERE @line_id = line_id)
END
GO

CREATE FUNCTION is_driver_busy
(@driver_id INT, @time TIME)
RETURNS BIT
BEGIN
	DECLARE @last_route_time TABLE (line_id INT NOT NULL, end_time TIME NOT NULL, start_time TIME NOT NULL);
	INSERT @last_route_time SELECT TOP(1) line_id, DATEADD(minute, dbo.route_distance(line_id), start_time) AS end_time, start_time FROM [Active Schedule] WHERE start_time < @time AND driver_id = @driver_id ORDER BY start_time DESC;
	IF EXISTS (SELECT * FROM @last_route_time WHERE @time >= start_time AND @time <= end_time) RETURN 1
	ELSE RETURN 0 
	RETURN 0
END
GO

CREATE FUNCTION is_driver_license_active
(@driver_id INT, @time DATE)
RETURNS BIT
BEGIN
	IF EXISTS (SELECT * FROM Drivers D JOIN Licenses L ON D.licence_id = L.id WHERE D.id = @driver_id AND L.expiration_date > @time) RETURN 1;
	RETURN 0;
END
GO

CREATE FUNCTION schedule_for_station (@station_id INT)
RETURNS @schedule TABLE
(
	line_id INT NOT NULL,
	arrival_time TIME NOT NULL
) AS
BEGIN
	INSERT @schedule
	SELECT S.line_id, 
	DATEADD(minute, (SELECT SUM(delta_time) FROM [Line Routes] WHERE line_id = S.line_id AND order_index <= (SELECT order_index FROM [Line Routes] WHERE line_id = S.line_id AND station_id = @station_id)), start_time) as arrival_time
	FROM Schedule S WHERE line_id IN (SELECT DISTINCT line_id FROM [Line Routes] WHERE station_id = @station_id) RETURN
	
END
GO

CREATE FUNCTION working_hours (@driver_id INT)
RETURNS TIME
BEGIN
	RETURN (SELECT DATEADD(minute,  SUM(dbo.route_distance(line_id)), '0:00' ) FROM [Active Schedule] WHERE @driver_id = driver_id)
END
GO

CREATE FUNCTION schedule_for_line (@line_id INT, @start_time TIME)
RETURNS @schedule TABLE
(
	station_id INT NOT NULL,
	arrival_time TIME
) AS 
BEGIN
	INSERT @schedule
	SELECT station_id, DATEADD(minute,  (SELECT SUM(delta_time) FROM [Line Routes] LRR WHERE LRR.line_id = LR.line_id AND LRR.order_index <= LR.order_index), 
	(SELECT TOP 1 start_time FROM Schedule WHERE @line_id = line_id AND start_time >= @start_time) ) 
	FROM [Line Routes] LR WHERE line_id = @line_id AND EXISTS (SELECT * FROM Schedule WHERE start_time >= @start_time AND line_id = @line_id) RETURN
END
GO







   

