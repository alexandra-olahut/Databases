create database Hogwarts
go
use Hogwarts
go


create table Classes (
ClassName varchar(50) PRIMARY KEY,
Location varchar(50) DEFAULT 'A free classroom'
)

create table Teachers (
Tid varchar(5) PRIMARY KEY,
Name varchar(100) NOT NULL,
Class varchar(50) FOREIGN KEY references Classes(ClassName),
Started int,
Retired int
)

create table Books (
Bid int PRIMARY KEY,
Title varchar(50) NOT NULL,
Author varchar(50) DEFAULT 'UNKNOWN',
Subject varchar(50) FOREIGN KEY references Classes(ClassName)
)

create table Houses (
HouseName varchar(50) PRIMARY KEY,
Founder varchar(50) NOT NULL UNIQUE,
HeadOfHouse varchar(5) FOREIGN KEY references Teachers(Tid) NOT NULL UNIQUE,
Color varchar(10) UNIQUE,
Animal varchar(20) UNIQUE
)

create table Ghosts (
House varchar(50) FOREIGN KEY references Houses(HouseName),
Name varchar(50) NOT NULL,
YearOfBirth int,
YearOfDeath int,
CONSTRAINT pk_Ghosts PRIMARY KEY (House)
)

create table Students (
Sid int PRIMARY KEY,
Name varchar(100) NOT NULL,
LastName varchar(100) NOT NULL,
House varchar(50) FOREIGN KEY references Houses(HouseName) NOT NULL,
BloodStatus varchar(50) CHECK (BloodStatus='Pure Blood' OR BloodStatus='Half Blood' OR BloodStatus='Muggleborn') DEFAULT 'Unknown'
)

create table Wands (
Wid int FOREIGN KEY references Students(Sid),
Core varchar(50),
Wood varchar(50),
Trait varchar(50),
Length int,
CONSTRAINT pk_Wands PRIMARY KEY (Wid) 
)

create table Pets (
Pid int PRIMARY KEY IDENTITY,
Species varchar(50) DEFAULT 'Owl' CHECK (Species='Owl' OR Species='Cat' OR Species='Toad' OR Species='Rat'),
Type varchar(50),
PetName varchar(50),
Owner int FOREIGN KEY references Students(Sid)
)

create table Exams (
Sid int FOREIGN KEY references Students(Sid), 
Cid varchar(50) FOREIGN KEY references Classes(ClassName),
Year int NOT NULL CHECK (Year>=1 AND Year<=7),
Grade int CHECK (Grade>=1 AND Grade<=10)
CONSTRAINT pk_Exams PRIMARY KEY (Sid,Cid,Year)
)

create table Activities (
ActivityName varchar(20) PRIMARY KEY,
Location varchar(50),
)

create table TakesPart (
Sid int FOREIGN KEY references Students(Sid),
Activity varchar(20) FOREIGN KEY references Activities(ActivityName),
DayOfWeek varchar(10),
Start int,
Finish int,
CONSTRAINT pk_TakesPartIn PRIMARY KEY (Sid, DayOfWeek, Start)
)



ALTER TABLE Exams
ALTER COLUMN Grade float
