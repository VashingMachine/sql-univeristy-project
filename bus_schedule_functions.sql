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

