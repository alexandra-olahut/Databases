use Hogwarts
go

-- Use 3 tables for the tests:  Activities - Pk, no Fk
--								Students - Pk and Fk
--								TakesPart - 2-column Pk
INSERT INTO Tables(Name) VALUES ('Activities'), ('Students'), ('TakesPart')


-- View using only 1 table
CREATE View View1_Students
AS
	SELECT s.Name, s.LastName, s.House
	FROM Students s
GO

-- View using 2 tables
CREATE View View2_Activities
AS
	SELECT a.ActivityName, a.Location, tp.DayOfWeek, tp.Start
	FROM Activities a INNER JOIN TakesPart tp ON a.ActivityName=tp.Activity
GO

-- View using 2 tables and the group by clause
CREATE View View3_ActivitiesByDay
AS
	SELECT tp.DayOfWeek, COUNT(*) Participation, MIN(tp.Start) Earliest_hour, MAX(tp.Finish) Latest_hour
	FROM Students s INNER JOIN TakesPart tp ON s.Sid=tp.Sid
	GROUP BY tp.DayOfWeek
GO

-- Insert the views prepared for tests into the table
INSERT INTO Views (Name) VALUES ('View1_Students'), ('View2_Activities'), ('View3_ActivitiesByDay')

select * from Tables
select * from Views




-- Insert the tests configurations (for 10/100/1000 entries)
INSERT INTO Tests (Name) VALUES ('test_10'), ('test_100'), ('test_1000'), ('test_10000')
select * from Tests


-- Now insert the connections between Tests and Tables/Views
-- Each of my tests will include all 3 tables and all 3 views, to see the differences between 10/100/1000 entries
INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, 1, 10, 1),
																	(1, 2, 10, 2),
																	(1, 3, 10, 3),
																	(2, 1, 100, 1),
																	(2, 2, 100, 2),
																	(2, 3, 100, 3),
																	(3, 1, 1000, 1),
																	(3, 2, 1000, 2),
																	(3, 3, 1000, 3),
																	(4, 1, 10000, 1),
																	(4, 2, 10000, 2),
																	(4, 3, 10000, 3)
INSERT INTO TestViews (TestID, ViewID) VALUES (1, 1),
											  (1, 2),
											  (1, 3),
											  (2, 1),
											  (2, 2),
											  (2, 3),
											  (3, 1),
											  (3, 2),
											  (3, 3),
											  (4, 1),
											  (4, 2),
											  (4, 3)
select * from TestTablesConfig
select * from TestViewsConfig
