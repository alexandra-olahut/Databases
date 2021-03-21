use Hogwarts
go

-- This procedure executes a given view (selects from it)
CREATE PROCEDURE ExecView @viewName nvarchar(50)
AS
	IF @viewName = 'View1_Students'
		SELECT * FROM View1_Students
	IF @viewName = 'View2_Activities'
		SELECT * FROM View2_Activities
	IF @viewName = 'View3_ActivitiesByDay'
		SELECT * FROM View3_ActivitiesByDay
GO


-- Here are insert and delete operation for given table
CREATE PROCEDURE InsertInto 
	@Table nvarchar(50),
	@nrRows int
AS
	IF @Table = 'Activities'
		exec InsertIntoActivities @nrRows
	IF @Table = 'Students'
		exec InsertIntoStudents @nrRows
	IF @Table = 'TakesPart'
		exec InsertIntoTakesPart @nrRows
GO

CREATE PROCEDURE DeleteFrom
	@Table nvarchar(50)
AS
	IF @Table = 'Activities'
		DELETE FROM Activities
	IF @Table = 'Students'
		DELETE FROM Students
	IF @Table = 'TakesPart'
		DELETE FROM TakesPart		
GO







--  Here are specfic procedures that insert the given amount of random data into each of our tables

CREATE PROCEDURE InsertIntoActivities @nrRows int
AS
	DECLARE @activityName varchar(20)
	DECLARE @activityLocation varchar(50)
	DECLARE @nr int
	SET @nr = 1

	WHILE @nr <= 100
	BEGIN
		SET @activityName = 'Activity' + CAST(@nr as varchar(10))
		SET @activityLocation = 'Room ' + CAST(@nr%(100/5)+1 as varchar(10))

		INSERT INTO Activities(ActivityName, Location) VALUES (@activityName, @activityLocation)
		print @activityName + ' ' + @activityLocation
		SET @nr = @nr+1
	END
GO



CREATE PROCEDURE InsertIntoStudents @nrRows int
AS
	DECLARE @Sid int
	DECLARE @Name varchar(100)
	DECLARE @LastName varchar(100)
	DECLARE @House varchar(50)
	
	DECLARE @nr int
	SET @nr = 1

	WHILE @nr <= 100
	BEGIN
		SET @Sid = @nr
		SET @Name = (SELECT TOP 1 r.NewName FROM RandomNames r ORDER BY NEWID())
		SET @LastName = (SELECT TOP 1 r.NewName FROM RandomNames r ORDER BY NEWID())
		SET @House = (SELECT TOP 1 h.HouseName FROM Houses h ORDER BY NEWID())

		INSERT INTO Students VALUES (@Sid, @Name, @LastName, @House, 'Pure Blood')
		print cast(@Sid as varchar(10)) +' '+ @Name+' '+ @LastName+' '+ @House
		SET @nr = @nr+1
	END	
GO



CREATE PROCEDURE InsertIntoTakesPart @nrRows int
AS
	DECLARE @Sid int
	DECLARE @Activity varchar(20)
	DECLARE @WeekDay varchar(10)
	DECLARE @Start int
	DECLARE @Finish int
	
	DECLARE @nr int
	SET @nr = 1

	WHILE @nr <= 100
	BEGIN
		
		SET @Activity = (SELECT TOP 1 a.ActivityName FROM Activities a ORDER BY NEWID())
		SET @WeekDay = (SELECT TOP 1 d.Day FROM WeekDays d ORDER BY NEWID())
		SET @Start = @nr%13+8
		SET @Finish = @Start + @nr%3+1

		SET @Sid = (SELECT TOP 1 s.Sid FROM Students s
					WHERE s.Sid NOT IN (SELECT s.Sid FROM Students s
										INNER JOIN TakesPart tp ON tp.Sid=s.Sid
										WHERE tp.DayOfWeek = 'Monday' AND tp.Start = 3)
					ORDER BY NEWID())
		INSERT INTO TakesPart VALUES (@Sid, @Activity, @WeekDay, @Start, @Finish)
		print cast(@Sid as varchar(10)) +' '+ @Activity+' '+ @WeekDay +' '+cast(@Start as varchar(10))+' '+cast(@Finish as varchar(10))
		SET @nr = @nr+1
	END	
GO











exec InsertIntoStudents 10
exec InsertIntoActivities 10
exec InsertIntoTakesPart 10


select * 
from Students s full outer join TakesPart tp ON s.Sid=tp.Sid
full outer join Activities a ON a.ActivityName=tp.Activity

delete from TakesPart
delete from Students
delete from Activities


-- for randomization

CREATE Table RandomNames (
NewName varchar(50))
INSERT INTO RandomNames VALUES ('Mike'),('Harry'),('Emma'),('Potter'),('Weasley'),('Ron'),('Hermione'),('Draco'),('Ariana'),('Ginny'),('Fred'),('George'),('Christopher'),('Logan'),('Lorelai'),('Rachel'),('Pheobe'),('Joey'),('Chandler'),('Monica'),('Ross'),('Janice'),('Rory'),('Jess'),('Dean'),('Emily'),('Richard'),('Babette'),('Emma'),('Alexia'),('Don'),('Archibald'),('Roger'),('Mariposa'),('Sheldon'),('Penny'),('Leonard'),('Howard'),('Bernadette'),('Leia'),('Anakin'),('Padme'),('Ted'),('Barney'),('Marshall'),('Robin'),('Lily'),('Paris')

CREATE TABLE WeekDays (
Day varchar(10))
INSERT INTO WeekDays VALUES ('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'), ('Friday'), ('Saturday'), ('Sunday')
