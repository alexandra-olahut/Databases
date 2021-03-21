use Hogwarts
go

-- INSERTS --

INSERT INTO Classes(ClassName,Location) VALUES ('Transfiguration', 'Class 1')
INSERT INTO Classes(ClassName,Location) VALUES ('Potions', 'Dungeons'),
											   ('Charms', 'Class 99'),
											   ('Care of Magical Creatures', 'Forbidden Forest'),
											   ('History of Magic', 'Classroom 4F'),
											   ('Divination', 'North Tower'),
											   ('Astronomy', 'Astronomy Tower'),
											   ('Defence against the Dark Arts', 'Class 99'),
											   ('Flying', 'Hogwarts grounds'),
											   ('Herbology', 'Greenhouses'),
											   ('Arithmancy', 'Class 1'),
											   ('Study of Ancient Runes', 'Classroom 4F')

INSERT INTO Books(Bid, Title, Author, Subject) VALUES(11, 'The Standard Book of Spells, Grade 1', 'Miranda Goshawk', null),
													 (1001, 'A History of Magic', 'Bathilda Bagshot', 'History of Magic'),
													 (100, 'A Beginner Guide to Transfiguration', 'Emeric Switch', 'Transfiguration'),
													 (3, 'Fantastic Beasts and Where to Find Them', 'Newt Scamander', 'Care of Magical Creatures'),
													 (66, 'Advanced Potion-Making', 'Libatius Borage', 'Potions'),
													 (12, 'The Standard Book of Spells, Grade 2', 'Miranda Goshawk', 'Potions'),
													 (13, 'The Standard Book of Spells, Grade 3', 'Miranda Goshawk', 'Charms'),
													 (67, 'Magical Drafts and Potions', 'Arsenius Jigger', 'Potions'),
													 (77, 'The Essential Defence Against the Dark Arts', 'Arsenius Jigger', 'Defence against the Dark Arts')


INSERT INTO Professors(Tid, Name, Class, FromY, UntilY) VALUES ('AD', 'Albus Dumbledore', 'Transfiguration', 1927, 1996)
INSERT INTO Professors(Tid, Name, Class, FromY, UntilY) VALUES ('MM', 'Minerva McGonagall', 'Transfiguration', 1956, null),
														       ('SS', 'Severus Snape', 'Potions', 1981, null),
															   ('FF', 'Filius Flitwick', 'Charms', 1970, null),
															   ('PS', 'Pomona Sprout', 'Herbology', 1975, null),
															   ('AS', 'Aurora Sinistra', 'Astronomy', 1985, null),
															   ('RH', 'Rubeus Hagrid', 'Care of Magical Creatures', 1993, null),
															   ('RL', 'Remus Lupin', 'Defence against the Dark Arts', 1993, 1994),
															   ('CB', 'Cuthbert Binns', 'History of Magic', 1940, 2010),
															   ('ST', 'Sybill Trelawney', 'Divination', 1980, 1996),
															   ('MH', 'Rolanda Hooch', 'Flying', 1980, null),
															   ('DU', 'Dolores Umbridge', 'Defence against the Dark Arts', 1995, 1996),
															   ('FC', 'Firenze', 'Divination', 1996, 1998),
															   ('HS', 'Horace Slughorn', 'Potions', 1931, 1981),
															   ('QQ', 'Quirinus Quirell', 'Defence against the Dark Arts', 1991, 1992),
															   ('SV', 'Septima Vector', 'Arithmancy', 1973, null),
															   ('BB', 'Batshelda Babbling', 'Study of Ancient Runes', 1955, null)
INSERT INTO Professors(Tid, Name, Class, FromY, UntilY) VALUES ('AJ', 'Arsenius Jigger', 'Transfiguration', 1930, 1950)

INSERT INTO Houses(HouseName, Founder, HeadOfHouse, Color, Animal) VALUES ('Gryffindor', 'Godric Gryffindor', 'MM', 'Red', 'Lion'),
																		  ('Slytherin', 'Salazar Slytherin', 'SS', 'Green', 'Snake'),
																		  ('Ravenclaw', 'Rowena Ravenclaw', 'FF', 'Blue', 'Eagle'),
																		  ('Hufflepuff', 'Helga Hufflepuff', 'PS', 'Yellow', 'Badger')

INSERT INTO Ghosts(House, Name, YearOfBirth, YearOfDeath) VALUES ('Gryffindor', 'Nearly Headless Nick', 1440, 1492),
									   						     ('Slytherin', 'Bloody Baron', 982, 1013),
															     ('Hufflepuff', 'Fat Friar', 1212, 1260),
															     ('Ravenclaw', 'Grey Lady', 985, 1013)

INSERT INTO Students(Sid, Name, LastName, House, BloodStatus) VALUES (101, 'Harry', 'Potter', 'Gryffindor', 'Half Blood'),
														             (102, 'Hermione', 'Granger', 'Gryffindor', 'Muggleborn'),
																	 (103, 'Ron', 'Weasley', 'Gryffindor', 'Pure Blood'),
																	 (104, 'Ginny', 'Weasley', 'Gryffindor', 'Pure Blood'),
																	 (112, 'Fred', 'Weasley', 'Gryffindor', null),
																	 (113, 'George', 'Weasley', 'Gryffindor', null),
																	 (150, 'Parvati', 'Patil', 'Gryffindor', 'Pure Blood'),
																	 (108, 'Seamus', 'Finnigan', 'Gryffindor', 'Half Blood'),
																	 (109, 'Dean', 'Thomas', 'Gryffindor', 'Muggleborn'),
																	 (105, 'Neville', 'Longbottom', 'Gryffindor', 'Pure Blood'),
																	 (111, 'Angelina', 'Johnson', 'Gryffindor', 'Half Blood'),
																	 (117, 'Oliver', 'Wood', 'Gryffindor', 'Half Blood'),

																	 (222, 'Draco', 'Malfoy', 'Slytherin', null),
																	 (253, 'Marcus', 'Flint', 'Slytherin', 'Muggleborn'),
																	 (261, 'Vincent', 'Crabbe', 'Slytherin', 'Pure Blood'),
																	 (271, 'Gregory', 'Goyle', 'Slytherin', 'Pure Blood'),
																	 (202, 'Pansy', 'Parkinson', 'Slytherin', 'Half Blood'),
																	 (201, 'Blaise', 'Zabini', 'Slytherin', 'Half Blood'),
																	 (299, 'Terry', 'Boot', 'Slytherin', 'Muggleborn'),
																	 (298, 'Clara', 'Zabini', 'Slytherin', 'Half Blood'),

																	 (322, 'Penelope', 'Clearwater', 'Ravenclaw', 'Half Blood'),
																	 (311, 'Roger', 'Davies', 'Ravenclaw', 'Muggleborn'),
																	 (333, 'Luna', 'Lovegood', 'Ravenclaw', 'Pure Blood'),
																	 (345, 'Cho', 'Chang', 'Ravenclaw', 'Half Blood'),
																	 (350, 'Padma', 'Patil', 'Ravenclaw', 'Pure Blood'),
			 														 (303, 'Michael', 'Corner', 'Ravenclaw', 'Half Blood'),
																	 (300, 'Dorian', 'Black', 'Ravenclaw', null),
																	 (313, 'Alexia', 'Black', 'Ravenclaw', null),
																	 (323, 'Christopher', 'Matthews', 'Ravenclaw', 'Half Blood'),

																	 (401,'Hannah', 'Abbot', 'Hufflepuff', 'Half Blood'),
																	 (404, 'Cedric', 'Diggory', 'Hufflepuff', 'Pure Blood'),
																	 (412, 'Susan', 'Bones', 'Hufflepuff', 'Muggleborn'),
																	 (456, 'Zacharias', 'Smith', 'Hufflepuff', 'Pure Blood'),
																	 (444, 'Justin', 'Finch-Fletchley', 'Hufflepuff', 'Muggleborn')
																		
INSERT INTO Wands(Wid, Core, Wood, Trait, Length) VALUES (101, 'Pheonix feather', 'Holly', 'Supple', 11),
												         (102, 'Dragon heartstring', 'Vine', null, 10),
												         (103, 'Unicorn hair', 'Willow', null, 14),
														 (404, 'Unicorn hair', 'Ash', 'Springy', 12),
														 (105, 'Unicorn hair', 'Cherry', null, 11),
														 (222, 'Unicorn hair', 'Hawthorn', 'Yielding', 10),
														 (313, 'Pheonix feather', 'Ash', 'Unyielding', 12),
														 (104, 'Dragon heartstring', 'Elder', null, 14),
														 (201, 'Dragon heartstring', 'Chestnut', 'Supple', 11),
														 (444, 'Pheonix feather', 'Cherry', null, 13),
														 (323, 'Pheonix feather', 'Vine', null, 13),
														 (333, 'Dragon heartstring', 'Willow', null, 11)

INSERT INTO Pets(Species, Type, PetName, Owner) VALUES ('Owl', 'Snowy', 'Hedwig', 101),
													   ('Cat', 'Half-Kneazle', 'Crookshanks', 102),
													   ('Rat', null, 'Scabbers', null),
													   ('Owl', 'Barn owl', 'Errol', 113),
													   ('Owl', null, 'Pigwidgeon', 102),
													   ('Owl', 'Snowy', 'Tofo', 313),
													   ('Cat', 'Tabby', 'Mellow', 444),
													   ('Toad', null, 'Trevor', 105),
													   ('Owl', 'Eagle owl', 'Scorpio', 222)

INSERT INTO Activities(ActivityName, Location) VALUES ('Quidditch', 'Quidditch pitch'),
													  ('Duelling Club', 'The Great Hall'),
													  ('Dumbledores Army', 'Room of Requirement'),
													  ('Gobston Club', 'Common Room'),
													  ('Potions Club', 'Dungeons'),
													  ('Wizard Chess Club', 'The Great Hall'),
													  ('Hippogriff Club', 'Room of Requirement')

INSERT INTO TakesPart(Sid, Activity, DayOfWeek, Start, Finish) VALUES (444, 'Duelling Club', 'Monday', 10, 11),
																	  (103, 'Wizard Chess Club', 'Thursday', 20, 21),
																	  (101, 'Duelling Club', 'Monday', 10, 11),
																	  (456, 'Wizard Chess Club', 'Monday', 11, 12),
																	  (108, 'Wizard Chess Club', 'Monday', 11, 12),
																	  (102, 'Hippogriff Club', 'Friday', 12, 13),
																	  (313, 'Hippogriff Club', 'Friday', 12, 13),
																	  (102, 'Potions Club', 'Tuesday', 18, 19),
																	  (299, 'Potions Club', 'Tuesday', 18, 19),
																	  (222, 'Potions Club', 'Sunday', 12, 14),
																	  (401, 'Gobston Club', 'Saturday', 17, 18),
																	  (105, 'Gobston Club', 'Saturday', 17, 18),
																	  (323, 'Dumbledores Army', 'Monday', 20, 22),
																	  (102, 'Dumbledores Army', 'Monday', 20, 22),
																	  (103, 'Dumbledores Army', 'Monday', 20, 22)

INSERT INTO TakesPart(Sid, Activity, DayOfWeek, Start, Finish) VALUES (303, 'Quidditch', 'Friday', 18, 20),
																	  (323, 'Quidditch', 'Friday', 18, 20),
																	  (345, 'Quidditch', 'Friday', 18, 20),
																	  (404, 'Quidditch', 'Saturday', 8, 10),
																	  (412, 'Quidditch', 'Saturday', 8, 10),
																	  (101, 'Quidditch', 'Wednesday', 19, 22),
																	  (113, 'Quidditch', 'Wednesday', 19, 22),
																	  (112, 'Quidditch', 'Wednesday', 19, 22),
																	  (117, 'Quidditch', 'Wednesday', 19, 22),
																	  (111, 'Quidditch', 'Wednesday', 19, 22),
																	  (222, 'Quidditch', 'Wednesday', 17, 19),
																	  (253, 'Quidditch', 'Wednesday', 17, 19),
																	  (261, 'Quidditch', 'Wednesday', 17, 19),
																	  (271, 'Quidditch', 'Wednesday', 17, 19)

INSERT INTO Exams(Sid, Cid, Year, Grade) VALUES (102, 'Potions', 1, 10),
												(102, 'Transfiguration', 1, 10),
												(101, 'Potions', 1, 8),
												(101, 'Defence against the Dark Arts', 1, 10),
												(103, 'Defence against the Dark Arts', 2, 9),
												(323, 'Defence against the Dark Arts', 4, 9),
												(222, 'Defence against the Dark Arts', 1, 8),
												(105, 'Potions', 3, 5),
												(105, 'Potions', 4, 6),
												(222, 'Potions', 1, 9),
												(313, 'Potions', 1, 10),
												(222, 'Transfiguration', 1, 7)



select * from Students
select * from Ghosts
select * from Houses
select * from Books
select * from Professors
select * from Classes
select * from Exams
select * from Pets
select * from Wands
select * from Activities
select * from TakesPart

-- Inserts with constraints violation
INSERT INTO Pets VALUES ('Ferret', 'White', 'Draco', null)
INSERT INTO Students VALUES (0, 'Newt', 'Scammander', 'Thunderbird', null)


-- using =, IS NULL, OR, IN, LIKE, BETWEEN
-- UPDATES --

UPDATE Wands
SET Trait='Flexible'
WHERE (Length BETWEEN 13 AND 16) OR Wood='Vine'      -- BETWEEN, OR

UPDATE Students
SET BloodStatus='Pure Blood'
WHERE LastName IN ('Weasley', 'Malfoy', 'Black')     -- IN

UPDATE Books
SET Subject='Charms'
WHERE Title LIKE '%Spells%'                          -- LIKE


-- DELETES --

DELETE from Professors
WHERE Name='Dolores Umbridge'                        -- =

DELETE from Pets
WHERE Owner IS NULL                                  -- IS NULL

--- using =, IS NULL, OR, IN, LIKE, BETWEEN

