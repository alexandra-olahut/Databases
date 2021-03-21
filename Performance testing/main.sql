use Hogwarts
go



exec test 'test_10'
exec test 'test_100'
exec test 'test_1000'
exec test 'test_10000'
select * from TestRuns
select * from TestRunTables
select * from TestRunViews


CREATE PROCEDURE ResetTestResults
AS
	delete from TestRuns
	delete from TestRunTables
	delete from TestRunViews
	DBCC CHECKIDENT ('TestRuns', RESEED, 0)
	GO
GO


-- Main procedure that runs a test by its name
CREATE PROCEDURE test @testName varchar(50)
AS	
	if NOT EXISTS (SELECT t.TestID FROM Tests t
				   WHERE t.Name = @testName)
		print 'This is not a valid test'
	else
		begin
		DECLARE @testID int
		SET @testID = (SELECT t.TestID FROM Tests t
					   WHERE t.Name = @testName)
--		print @testID
		EXEC runTest @testID
		end
GO


-- Run the test given its ID and fill the test run tables with data
CREATE PROCEDURE runTest @testID int
AS
	-- We need to see the tables and views involved in this test and to set its description
	DECLARE @testRunId int
	DECLARE @description varchar(200)
	DECLARE @startTest datetime
	DECLARE @endTest datetime

	set @description = 'Test run for: ' + (SELECT t.Name FROM Tests t WHERE t.TestID=@testID)
	set @startTest = GETDATE()
	set @endTest = GETDATE()
	INSERT INTO TestRuns VALUES (@description, @startTest, @endTest)
	set @testRunId = (SELECT MAX(tr.TestRunID) FROM TestRuns tr)

	-- first we need to delete all the data from the tables involved before evaluating anything
	exec DeleteFromTables @testID

	-- then we need to perform inserts
	exec InsertIntoTables @testRunId, @testID

	-- then we evaluate the views
	exec EvaluateViews @testRunId, @testID

	set @endTest = GETDATE()
	UPDATE TestRuns
	SET EndAt=@endTest
	WHERE TestRunID=@testRunId
	
GO
















-- This procedure takes a testID and performs insert operation on all the tables involved, in the order given by their position
CREATE PROCEDURE InsertIntoTables
	@testRunId int,
	@testId int
AS
	DECLARE @nrTablesInvolved int    -- nr of tables used in test @testId
	SELECT @nrTablesInvolved = COUNT(*) FROM Tables t
										INNER JOIN TestTables tt ON t.TableID=tt.TableID
										WHERE tt.TestID = @testId

	-- We need to get the start end end time for each table
	DECLARE @start datetime
	DECLARE @end datetime

	-- We need to find the right order for operation according to the position column in TestTable
	DECLARE @currentTable nvarchar(50)
	DECLARE @currentTableId int
	DECLARE @nrRows int
	DECLARE @current int
	
	SET @current = 0
	WHILE @current < @nrTablesInvolved
		BEGIN
			SET @current = @current+1
			-- This select will give me the name of the table that must be resolved next (pos = current)
			--   and the nr of rows that must be inserted

			SELECT @currentTable=tb.Name, @nrRows=tt.NoOfRows, @currentTableId=tb.TableID 
			FROM Tables tb INNER JOIN TestTables tt ON tb.TableID=tt.TableID
						   INNER JOIN Tests t ON tt.TestID=t.TestID
				 WHERE tt.Position = @current AND tt.TestID = @testId

--			print 'insert' + @currentTable
			SET @start = GETDATE()
			exec InsertInto @currentTable, @nrRows
			SET @end = GETDATE()
			INSERT INTO TestRunTables VALUES (@testRunId, @currentTableId, @start, @end)
		END
GO


-- This procedure takes a testID and performs delete operation on all the tables involved, in the order given by their position (reversed)
CREATE PROCEDURE DeleteFromTables
	@testId int
AS

	DECLARE @nrTablesInvolved int  
	SELECT @nrTablesInvolved = COUNT(*) FROM Tables t
										INNER JOIN TestTables tt ON t.TableID=tt.TableID
										WHERE tt.TestID = @testId

	DECLARE @currentTable nvarchar(50)
	DECLARE @current int
	
	SET @current = @nrTablesInvolved
	WHILE @current > 0
		BEGIN
			SELECT @currentTable=tb.Name 
			FROM Tables tb INNER JOIN TestTables tt ON tb.TableID=tt.TableID
						   INNER JOIN Tests t ON tt.TestID=t.TestID
				 WHERE tt.Position = @current AND tt.TestID = @testId

			exec DeleteFrom @currentTable
		
			SET @current = @current-1
		END
GO




-- This procedure takes a testID and executes all the views associated with the test
CREATE PROCEDURE EvaluateViews
	@testRunId int,
	@testId int
AS
	-- We need to get the start end end time for each table
	DECLARE @start datetime
	DECLARE @end datetime
	DECLARE @currentView varchar(50)
	DECLARE @currentViewId int

	DECLARE ViewsCursor CURSOR FOR
	SELECT v.ViewID, v.Name
	FROM Views v INNER JOIN TestViews tv ON v.ViewID=tv.ViewID WHERE tv.TestID=@testId    -- I parse the views associated with testID

	OPEN ViewsCursor
	FETCH ViewsCursor INTO @currentViewId, @currentView
	WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @start = GETDATE()
			exec ExecView @currentView
			SET @end = GETDATE()
			INSERT INTO TestRunViews VALUES (@testRunId, @currentViewId, @start, @end)
--			print CAST(@currentViewId as varchar(10)) + ' ' + @currentView

			FETCH ViewsCursor INTO @currentViewId, @currentView
		END
	CLOSE ViewsCursor
	DEALLOCATE ViewsCursor

GO










