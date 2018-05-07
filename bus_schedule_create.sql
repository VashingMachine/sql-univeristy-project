USE dkwiatkowski;

CREATE TABLE Drivers (
	id INT PRIMARY KEY IDENTITY(1,1),
	name nvarchar(45) NOT NULL,
	surname nvarchar(45) NOT NULL,
	licence_id INT NOT NULL,
	address_id INT NOT NULL
)
GO

CREATE TABLE Licenses (
	id INT PRIMARY KEY IDENTITY(1,1),
	expiration_date date NOT NULL,
	creation_date date NOT NULL
)

GO
CREATE TABLE Addresses (
	id INT PRIMARY KEY IDENTITY(1,1),
	street nvarchar(100) NOT NULL,
	postcode nvarchar(20) NOT NULL,
	country nvarchar(45) NOT NULL,
	city nvarchar(45) NOT NULL
)
GO
CREATE TABLE Buses (
	id INT PRIMARY KEY IDENTITY(1,1),
	name nvarchar(45) NOT NULL,
	brand nvarchar(45) NOT NULL,
	category_id INT NOT NULL,
	breakdown_id INT NOT NULL
)
GO
CREATE TABLE Station (
	id INT PRIMARY KEY IDENTITY(1,1),
	name nvarchar(45) NOT NULL
)
GO
CREATE TABLE Lines (
	id INT PRIMARY KEY IDENTITY(1,1),
	name nvarchar(10) NOT NULL
)
GO
CREATE TABLE [Line Routes] (
	station_id INT NOT NULL,
	line_id INT NOT NULL,
	order_index INT NOT NULL,
	delta_time INT NOT NULL,
	PRIMARY KEY(station_id, line_id)
)
GO
CREATE TABLE Schedule (
	driver_id INT NOT NULL,
	line_id INT NOT NULL,
	bus_id INT NOT NULL,
	start_time time NOT NULL
)
GO
CREATE TABLE [Bus Categories] (
	id INT PRIMARY KEY IDENTITY(1,1),
	name nvarchar(45) NOT NULL,
	description nvarchar(200) NOT NULL
)
GO
CREATE TABLE Breakdowns (
	id INT PRIMARY KEY IDENTITY(1,1),
	description nvarchar(45) NOT NULL,
	type nvarchar(45) NOT NULL
)
GO

ALTER TABLE Drivers ADD FOREIGN KEY (licence_id) REFERENCES Licenses(id)
GO
ALTER TABLE Drivers ADD FOREIGN KEY (address_id) REFERENCES Addresses(id)
GO


ALTER TABLE Buses ADD FOREIGN KEY (category_id) REFERENCES [Bus Categories](id)
GO
ALTER TABLE Buses ADD FOREIGN KEY (breakdown_id) REFERENCES Breakdowns(id)
GO


ALTER TABLE [Line Routes] ADD FOREIGN KEY (station_id) REFERENCES Station(id)
GO
ALTER TABLE [Line Routes] ADD FOREIGN KEY (line_id) REFERENCES Lines(id)
GO

ALTER TABLE Schedule ADD FOREIGN KEY (driver_id) REFERENCES Drivers(id)
GO
ALTER TABLE Schedule ADD FOREIGN KEY (line_id) REFERENCES [Lines](id)
GO
ALTER TABLE Schedule ADD FOREIGN KEY (bus_id) REFERENCES Buses(id)
GO

