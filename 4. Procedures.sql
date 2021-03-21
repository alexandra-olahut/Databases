use Hogwarts
go

---- Operations performed on table Activities ----

------------------------------------------------------------------------
-- a. modify the type of a column;

-- Modify the type of Location from varchar(50) to varchar(100)
CREATE PROCEDURE V0toV1 
AS
	BEGIN
		ALTER TABLE Activities
		ALTER COLUMN Location varchar(100)
		PRINT('Location is now varchar(100)')
	END
GO

-- Modify it back to varchar(50)
CREATE PROCEDURE V1toV0 
AS
	BEGIN
		ALTER TABLE Activities
		ALTER COLUMN Location varchar(50)
		PRINT('Location is again varchar(50)')
	END
GO

------------------------------------------------------------------------
-- b. add / remove a column;

-- Add column Coordinator

CREATE PROCEDURE V1toV2 
AS
	BEGIN
		ALTER TABLE Activities
		ADD Coordinator varchar(5)
		PRINT('Column -Coordinator- was added')
	END
GO

-- Remove column Coordinator

CREATE PROCEDURE V2toV1 
AS
	BEGIN
		ALTER TABLE Activities
		DROP COLUMN Coordinator
		PRINT('Column -Coordinator- was removed')
	END
GO


------------------------------------------------------------------------
-- c. add / remove a DEFAULT constraint;

-- Add default location = classroom

CREATE PROCEDURE V2toV3 
AS
	BEGIN
		ALTER TABLE Activities
		ADD CONSTRAINT df_location DEFAULT 'Classroom' FOR Location
		PRINT('Added -Classroom- as default location')
	END
GO

-- Remove the default location

CREATE PROCEDURE V3toV2 
AS
	BEGIN
		ALTER TABLE Activities
		DROP CONSTRAINT df_location
		PRINT('Removed -Classroom- as default location')
	END
GO


------------------------------------------------------------------------
-- d. remove / add a primary key;
----* Can't remove primary key of Activities because it is foreign key for another table
----* We remove the primary key for table Books
-- Remove the existing primary key (ActivityName)

CREATE PROCEDURE V3toV4 
AS
	BEGIN
		ALTER TABLE Books
		DROP CONSTRAINT pk_Books
		PRINT('Primary key was removed from Books')
	END
GO

-- Add back the primary key

CREATE PROCEDURE V4toV3 
AS
	BEGIN
		ALTER TABLE Books
		ADD CONSTRAINT pk_Books PRIMARY KEY(Bid)
		PRINT('Primary key was added to Books')
	END
GO


------------------------------------------------------------------------
-- e. add / remove a candidate key;

-- Make tuple (Coordinator, ActivityName) unique

CREATE PROCEDURE V4toV5 
AS
	BEGIN
		ALTER TABLE Activities
		ADD CONSTRAINT ck_coorindator_activity UNIQUE (ActivityName, Coordinator)
		PRINT('(ActivityName,Coordinator) was made candidate key')
	END
GO

-- Remove the candidate key

CREATE PROCEDURE V5toV4 
AS
	BEGIN
		ALTER TABLE Activities
		DROP CONSTRAINT ck_coorindator_activity
		PRINT('(ActivityName,Coordinator) is no longer candidate key')
	END
GO


------------------------------------------------------------------------
-- f. add / remove a foreign key;

-- Coordinator should reference a professor from table Professors

CREATE PROCEDURE V5toV6 
AS
	BEGIN
		ALTER TABLE Activities
		ADD CONSTRAINT fk_CoordinatorProfessor FOREIGN KEY(Coordinator)
								REFERENCES Professors(Tid)
		PRINT('Coordinator is foreign key referencing professor id')
	END
GO

-- Remove the foreign key to Professors

CREATE PROCEDURE V6toV5 
AS
	BEGIN
		ALTER TABLE Activities
		DROP CONSTRAINT fk_CoordinatorProfessor
		PRINT('Coordinator is no longer foreign key referencing professor id')
	END
GO


------------------------------------------------------------------------
-- g. create / drop a table.

CREATE PROCEDURE V6toV7 
AS
BEGIN
		CREATE Table CommonRooms (
		House varchar(50) FOREIGN KEY references Houses(HouseName),
		Location varchar(50),
		CONSTRAINT pk_CommonRooms PRIMARY KEY (House))
		PRINT('New table -CommonRooms- was created')
	END
GO

CREATE PROCEDURE V7toV6 
AS
	BEGIN
		DROP Table CommonRooms
		PRINT('Table -CommonRooms- was deleted')
	END
GO




-- Create a new table that holds the current version of the database schema. 
-- Simplifying assumption: the version is an integer number.

CREATE Table DbVersion (
	CurrentVersion int	
)
DELETE from DbVersion
INSERT into DbVersion VALUES (0)   -- current version is the initial state:0


CREATE PROCEDURE PrintCurrentVersion
AS
	BEGIN
		DECLARE @Crt int
		SELECT @Crt=CurrentVersion
		FROM DbVersion
		PRINT('Database is currently in version ' + CAST(@Crt as varchar(2)))
	END
GO


----------------------------------------------------------------------------

CREATE PROCEDURE UpdateDB
AS
	DECLARE @currentV int
	SELECT @currentV = CurrentVersion FROM DbVersion
	DECLARE @nextV int
	SET @nextV = @currentV+1
	DELETE from DbVersion
	INSERT into DbVersion VALUES (@nextV)

	if @currentV = 0
		exec V0toV1
	else if @currentV = 1
		exec V1toV2
	else if @currentV = 2
		exec V2toV3
	else if @currentV = 3
		exec V3toV4
	else if @currentV = 4
		exec V4toV5
	else if @currentV = 5
		exec V5toV6
	else if @currentV = 6
		exec V6toV7
GO


CREATE PROCEDURE UndoUpdateDB
AS
	DECLARE @currentV int
	SELECT @currentV = CurrentVersion FROM DbVersion
	DECLARE @prevV int
	SET @prevV = @currentV-1
	DELETE from DbVersion
	INSERT into DbVersion VALUES (@prevV)

	if @currentV = 1
		exec V1toV0
	else if @currentV = 2
		exec V2toV1
	else if @currentV = 3
		exec V3toV2
	else if @currentV = 4
		exec V4toV3
	else if @currentV = 5
		exec V5toV4
	else if @currentV = 6
		exec V6toV5
	else if @currentV = 7
		exec V7toV6
GO




-- Write a stored procedure that receives as a parameter a version number and brings the database to that version.

CREATE PROCEDURE GetToVersion(@GoalVersion int)
AS
	if @GoalVersion > 7 or @GoalVersion < 0
		RAISERROR ('This is not a valid Database version',10,1)
	
	else
	BEGIN
		DECLARE @CurrentVersion int
		SET @CurrentVersion = (SELECT CurrentVersion FROM DbVersion)

		if @CurrentVersion = @GoalVersion
			PRINT('Database is currently in this version')

		while @GoalVersion > @CurrentVersion
			BEGIN
				exec UpdateDB
				exec PrintCurrentVersion
				SET @CurrentVersion = (SELECT CurrentVersion FROM DbVersion)
			END
		while @GoalVersion < @CurrentVersion
			BEGIN
				exec UndoUpdateDB
				exec PrintCurrentVersion
				SET @CurrentVersion = (SELECT CurrentVersion FROM DbVersion)
			END
	END
GO

exec GetToVersion 13
exec GetToVersion 0
exec GetToVersion 5
exec GetToVersion 2
exec GetToVersion 7
