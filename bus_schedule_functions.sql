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
	@route_name nvarchar(10),
	@station nvarchar(45),
	@delta_time INT,
	@order_index INT = NULL
AS
BEGIN
	DECLARE @index INT;
	DECLARE @line_id INT;
	DECLARE @station_id INT;

	SET @index = COALESCE(@order_index, (SELECT MAX( LR.order_index ) + 1 FROM [Line Routes] LR JOIN Lines L ON L.id = LR.line_id WHERE @route_name = L.name), 0)
	SET @line_id = (SELECT id FROM Lines WHERE @route_name = name)
	SET @station_id = (SELECT id FROM Station WHERE @station = name)

	UPDATE [Line Routes] SET order_index = order_index + 1 WHERE order_index >= @order_index
	INSERT INTO [Line Routes] VALUES (@station_id, @line_id, @index, @delta_time)
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




   

