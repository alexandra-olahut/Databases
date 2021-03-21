use Hogwarts
go

-- a. 2 queries with the union operation; use UNION [ALL] and OR;

-- OR -- Show the locations where classes are held, that are in the castle (towers/classrooms)
SELECT DISTINCT c.Location FROM Classes c                                                                   -- DISTINCT
WHERE c.Location LIKE '%Class%' OR c.Location LIKE '%Tower%'												-- OR


-- UNION -- Show the classes where Arsenius Jigger teaches or in which his books are thaught
SELECT b.Subject 
FROM Books b
WHERE b.Author='Arsenius Jigger'
  UNION
SELECT p.Class
FROM Professors p
WHERE p.Name='Arsenius Jigger'



-- b. 2 queries with the intersection operation; use INTERSECT and IN;

-- INTERSECT -- Show that activities that take place in the Great Hall on Mondays
SELECT a.ActivityName
FROM Activities a
WHERE a.Location='The Great Hall'
   INTERSECT
SELECT tp.Activity
FROM TakesPart tp
WHERE tp.DayOfWeek='Monday'


-- IN -- Display the name of the students who play Quidditch
SELECT s.Name, s.LastName FROM Students s
WHERE s.Sid IN ( SELECT tp.Sid FROM TakesPart tp
				 WHERE tp.Activity='Quidditch' )



-- c. 2 queries with the difference operation; use EXCEPT and NOT IN;

-- EXCEPT -- Show the name of the Slytherins who do not have pure blood
SELECT s.Name, s.LastName
FROM Students s
WHERE s.House='Slytherin'
   EXCEPT
SELECT s.Name, s.LastName
FROM Students s
WHERE s.BloodStatus='Pure Blood'


-- NOT IN -- Show the Pure Blood students who do not own any pet
SELECT * FROM Students s
WHERE s.BloodStatus='Pure Blood' AND s.Sid NOT IN ( SELECT p.Owner FROM Pets p)								 -- NOT





-- d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator); one query will join at least 3 tables, while another one will join at least two many-to-many relationships;

-- Left outer join
--- Display all the teachers and for those being heads of house also their house

SELECT p.Name, h.HouseName
FROM Professors p LEFT OUTER JOIN Houses h ON h.HeadOfHouse=p.Tid


-- Right outer join
--- Show all the classes and also the books used in each class

SELECT b.Title, b.Author, c.ClassName
FROM Books b RIGHT OUTER JOIN Classes c ON b.Subject=c.ClassName


-- Full outer join   -- using three tables (Students, Wands, Pets)
--- Show all the students together with their pets and wands (if they have one)

SELECT s.Name, s.LastName, p.Species AS Pet, p.PetName, w.Core AS WandCore, w.Wood AS WandWood
FROM Students s FULL OUTER JOIN Pets p ON s.Sid=p.Owner 
FULL OUTER JOIN Wands w ON w.wid=s.sid
ORDER BY s.Name, s.LastName																					-- ORDER BY


-- Inner join   -- using 2 many-to-many relationships
--- Show the grades of the students and the activities they participate in

SELECT s.Name, s.LastName, e.Year, c.ClassName, e.Grade, a.ActivityName, tp.DayOfWeek
FROM Activities a INNER JOIN TakesPart tp ON a.ActivityName=tp.Activity
				  INNER JOIN Students s ON s.Sid=tp.Sid
				  INNER JOIN Exams e ON s.Sid=e.Sid 
				  INNER JOIN Classes c ON c.ClassName=e.Cid
ORDER BY tp.DayOfWeek, tp.Start																				-- ORDER BY





-- e. 2 queries using the IN operator to introduce a subquery in the WHERE clause; in at least one query, the subquery should include a subquery in its own WHERE clause;

-- Display the Ravenclaw Quidditch team
SELECT s.Name, s.LastName FROM Students s
WHERE s.House='Ravenclaw' AND
	  s.Sid IN ( SELECT tp.Sid FROM TakesPart tp
				 WHERE tp.Activity='Quidditch' )

-- Dislpay the books used in classes thaught by professors who are also head of house
SELECT b.Title, b.Subject
FROM Books b
WHERE b.Subject IN  ( SELECT p.Class
					  FROM Professors p
   					  WHERE p.Tid IN ( SELECT h.HeadOfHouse
									   FROM Houses h))



-- f. 2 queries using the EXISTS operator to introduce a subquery in the WHERE clause;

-- Show the houses of students who are in the Wizard Chess Club
SELECT DISTINCT s.House FROM Students s                                                                   -- DISTINCT
WHERE EXISTS ( SELECT * FROM TakesPart tp
			   WHERE tp.Sid=s.Sid AND tp.Activity='Wizard Chess Club' )


-- Show the types of pets owned by muggleborns
SELECT DISTINCT p.Type, p.Species FROM Pets p
WHERE EXISTS ( SELECT * FROM Students s
			   WHERE p.Owner=s.Sid AND s.BloodStatus='Muggleborn')




-- g. 2 queries with a subquery in the FROM clause;

-- Display the Gryffindors that have a 10 in Potions (together with their students ids and the year in which they got that grade)
SELECT PG.Sid, s.Name, s.LastName, PG.Year
FROM (SELECT e.Sid, e.Year FROM Exams e
      WHERE e.Cid='Potions' AND e.Grade=10) PG
INNER JOIN Students s ON PG.Sid=s.Sid
WHERE s.House='Gryffindor'

-- Show the details for the houses whose ghosts had lived more than 40 years
SELECT h.*, R.Name AS Ghost, R.YearsLived
FROM (SELECT g.Name, g.House, (g.YearOfDeath-g.YearOfBirth)AS YearsLived
      FROM Ghosts g
      WHERE (g.YearOfDeath-g.YearOfBirth) > 40 ) R															-- Arithmetic exp
INNER JOIN Houses h ON h.HouseName=R.House



-- h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

-- Show the maximum wand length for each different wood
SELECT w.Wood, MAX(w.Length) MaxLength
FROM Wands w
GROUP BY w.Wood


-- Show the top 10 students with an average >8 in first year
SELECT TOP 10 e.Sid, AVG(e.Grade) Average																	-- TOP
FROM Exams e
WHERE e.Year=1
GROUP BY e.Sid
HAVING AVG(e.Grade) > 8			


-- Show the students that are above average in Potions, in descending order by their grades
SELECT s.Sid, s.Name, s.LastName, a.Average
FROM
(SELECT e.Sid, AVG(e.Grade) Average
FROM Exams e
WHERE e.Cid='Potions'
GROUP BY e.Sid
HAVING AVG(e.Grade) > (SELECT AVG(e.Grade)
					   FROM Exams e
					   WHERE e.Cid='Potions')) A inner join Students s ON s.Sid=A.Sid
ORDER BY a.Average DESC																						-- ORDER BY


-- Show days in the week with most (different) activities organized 
SELECT TOP 3 tp.DayOfWeek, COUNT(DISTINCT tp.Activity) NoActivities                                         -- DISTINCT
FROM TakesPart tp																							
GROUP BY tp.DayOfWeek
HAVING COUNT(DISTINCT tp.Activity) >=ALL (SELECT COUNT(DISTINCT tp.Activity) 
										 FROM TakesPart tp
										 GROUP BY tp.DayOfWeek )



-- i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause; rewrite 2 of them with aggregation operators, and the other 2 with [NOT] IN.

-- >ANY = >MIN
--- Show the students who got a bigger grade in Defence against the Dark Arts than a pure blood

SELECT s.Name, s.LastName, e.Grade
FROM Students S INNER JOIN Exams e ON e.Sid=s.Sid
WHERE e.Cid='Defence against the Dark Arts'
AND s.BloodStatus<>'Pure Blood'
AND e.Grade > ANY ( SELECT e.Grade
					FROM Exams e INNER JOIN Students s ON e.Sid=s.Sid
					WHERE e.Cid='Defence against the Dark Arts'
					AND s.BloodStatus='Pure Blood' )

SELECT s.Name, s.LastName, e.Grade
FROM Students S INNER JOIN Exams e ON e.Sid=s.Sid
WHERE e.Cid='Defence against the Dark Arts'
AND s.BloodStatus<>'Pure Blood'
AND e.Grade > ( SELECT MIN(e.Grade)
				FROM Exams e INNER JOIN Students s ON e.Sid=s.Sid											 -- AND
				WHERE e.Cid='Defence against the Dark Arts'
				AND s.BloodStatus='Pure Blood' )


-- >ALL = >MAX
--- Show the retired professors who thaught for more years than all current professors
SELECT p.Name, (p.UntilY-p.FromY) AS NoYears 
FROM Professors p
WHERE p.UntilY IS NOT NULL																		            -- NOT
AND (p.UntilY-p.FromY) > ALL (SELECT (2020-p.FromY) FROM Professors p
							  WHERE p.UntilY IS NULL)

SELECT p.Name, (p.UntilY-p.FromY) AS NoYears																-- arithmetic exp
FROM Professors p
WHERE p.UntilY IS NOT NULL
AND (p.UntilY-p.FromY) > (SELECT MAX (2020-p.FromY)															-- AND, paranthesis
						  FROM Professors p
					      WHERE p.UntilY IS NULL)


-- =ANY = IN
--- Show the students who got at least a 10 in first year
SELECT s.Name, s.LastName
FROM Students s
WHERE s.Sid = ANY (SELECT e.Sid FROM Exams e
				   WHERE e.Year=1 AND e.Grade=10)

SELECT s.Name, s.LastName
FROM Students s
WHERE s.Sid IN (SELECT e.Sid FROM Exams e
				WHERE e.Year=1 AND e.Grade=10)                                     


-- <>ALL = NOT IN
--- Show the activities that do not take place during the weekends
SELECT * FROM Activities a
WHERE a.ActivityName <> ALL (SELECT tp.Activity FROM TakesPart tp
							 WHERE tp.DayOfWeek IN ('Saturday', 'Sunday'))

SELECT * FROM Activities a
WHERE a.ActivityName NOT IN (SELECT tp.Activity FROM TakesPart tp
							 WHERE tp.DayOfWeek IN ('Saturday', 'Sunday'))





/*
You must use:
- arithmetic expressions in the SELECT clause in at least 3 queries;
- conditions with AND, OR, NOT, and parentheses in the WHERE clause in at least 3 queries;
- DISTINCT in at least 3 queries, ORDER BY in at least 2 queries, and TOP in at least 2 queries.
*/

-- Arithmetic expression - Find the volume of a wand, considering diameter is 0.6 inches (V=L*piR^2), show the top 5

SELECT TOP 5 vol.Wid, vol.Vol
FROM (SELECT w.Wid, w.Length, (w.Length*PI()*POWER(0.6,2))Vol
	  FROM Wands w) vol
ORDER BY vol.Vol DESC

