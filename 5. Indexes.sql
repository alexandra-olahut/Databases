create database CoffeeShop
go

use CoffeeShop
go

ALTER index IDX_Orders_FK_CoffeeID ON Orders DISABLE
ALTER index IDX_Orders_FK_CustomerID ON Orders DISABLE
ALTER index IDX_Customers_Age_includeAll ON Customers DISABLE
ALTER INDEX IDX_Coffees_Type ON Coffees DISABLE
ALTER INDEX IDX_Coffees_Type_includePrice ON Coffees DISABLE
ALTER INDEX IDX_Coffees_Type ON Coffees DISABLE
ALTER INDEX IDX_Coffees_Type_includePrice ON Coffees DISABLE
ALTER index IDX_Customers_Age ON Customers DISABLE
ALTER index IDX_Customers_Age_includeName ON Customers DISABLE





CREATE TABLE Coffees (
Cid int PRIMARY KEY,      -- aid
Ranking int UNIQUE,       -- a2
Type varchar(50),
Extra varchar(50),
Price float )


CREATE TABLE Customers (
Pid int PRIMARY KEY,      -- bid
Name varchar(100),
LastName varchar(100),
Age int )                 -- b2


CREATE TABLE Orders (
Oid int PRIMARY KEY,      -- cid
CustomerID int FOREIGN KEY references Customers(Pid),
CoffeeID int FOREIGN KEY references Coffees(Cid),
Date date )


exec InsertCustomers 1000
exec InsertCoffees 1000
exec InsertOrders 1000
select * from Customers
select * from Coffees
select * from Orders



------------------------------------------------------- a Coffees --------------------------------------------------------------------


--- Only having the primary key and the unique index created automatically

--			ORDER BY

select * from Coffees --/ Cid/Ranking
order by Cid                      -- Clustered index scan (PK_Coffees idx create on primary key)

select * from Coffees
order by Ranking                  -- Clustered index scan + sort
		--/ anything else than Cid


select Ranking from Coffees 
order by Ranking                  -- Non-clustered index scan (UQ_Coffees idx created on unique field)

select Cid,Ranking from Coffees 
order by Ranking                  -- Non-clustered index scan (UQ_Coffees idx created on unique field)


-- * Whatever I select ordered by Cid I get a clustered index scan
--   If I sort by another field there is a clustered index scan + the sorting
--   If I select only the Ranking/Cid orderedy by Ranking -> non-clustered index scan  (uses the unique index on Ranking)


--			 WHERE

select * from Coffees
where Cid in (13,12,23)           -- Clustered index seek (PK_Coffees)

select * from Coffees
where Type in ('Mocha','Hot chocolate')         -- Clustered index scan(PK_Coffees)

select Ranking from Coffees 
where Ranking<10                  -- Non-clustered index seek (UQ_Coffees)

select Cid,Ranking from Coffees 
where Ranking<10                  -- Non-clustered index seek (UQ_Coffees)

select * from Coffees
where Ranking<10                     -- Clustered index scan

select * from Coffees
where Ranking=10                     -- Clustered index seek[UQ_Coffees] + KEY LOOKUP[PK_Coffees]
-- The key lookup happens after the unique value is seeked, to find the corresponding values for the other columns

-- * If I search for a smaller subset of the Cid I get a clustered index seek (on the primary key)
--   If I select Cid/Ranking (primary/candidate key) for a subset of Ranking(unique) I get a non-clustered index seek (on the unique idx)
--   But if I want to select anything else in addition it becomes a clustered index scan (on the primary key)
--   If I want to get a subset of a field that doesn't have any index it is still a clustered index scan


--  Adding some new indexes

CREATE nonclustered index IDX_Coffees_Type ON Coffees(Type)
CREATE nonclustered index IDX_Coffees_Type_includePrice ON Coffees(Type) INCLUDE (Price)

ALTER INDEX IDX_Coffees_Type ON Coffees REBUILD
ALTER INDEX IDX_Coffees_Type_includePrice ON Coffees REBUILD


select * from Coffees
order by Type							
select * from Coffees							-- Clustered index scan (anyway)
order by Price
select Type from Coffees  -- (/Price)
order by Extra
-- * If I use in the select or in the order by any column that is not included in the index
--   the clustered index will be used


select Cid,Type from Coffees
order by Type

select Cid,Type,Price from Coffees      -- Clustered index scan without include Price
order by Type							-- Non-clustered index scan with include Price
-- When I create a nonclustered index on a column A, it will be used only when I select A (+pk) ordered by A
-- If I include a list of colunms in the index, I can select those columns as well and the non-clustered idx will be used

select Type from Coffees -- [Price,Cid,Type]
order by Price                          -- Non-clustered index scan + sort
-- If I only select columns included in the index and I order by the included column,
-- I get a non-clustered index scan + sort


--        WHERE

select Cid,Type,Price from Coffees
where Type in ('Americano','Cortado','Espresso')
-- Using the same index, if instead of order by I use WHERE (to get a smaller subset)  -> Index seek (nonclustered)
-- * If I add any other column it will be a clustered index scan

select * from Coffees
where Type = 'Americano'    -- Clustered index scan

select Cid,Type,Price from Coffees
where Price <3
-- This will stil use the new nonclutered index, but it will be a scan instead of seek



ALTER INDEX IDX_Coffees_Type ON Coffees DISABLE
ALTER INDEX IDX_Coffees_Type_includePrice ON Coffees DISABLE


---------------------------------------------- b Customers --------------------------------------------------------

CREATE index IDX_Customers_Age ON Customers(Age)
CREATE index IDX_Customers_Age_includeName ON Customers(Age) INCLUDE (Name)

ALTER index IDX_Customers_Age ON Customers DISABLE
ALTER index IDX_Customers_Age_includeName ON Customers DISABLE

ALTER index IDX_Customers_Age ON Customers REBUILD
ALTER index IDX_Customers_Age_includeName ON Customers REBUILD

--1
select * from Customers
where Age=20
--2
select Age from Customers       -- /can include Pid
where Age=20
--3
select Age,Name from Customers  -- / can include Pid
where Age=20

-- No index (only the clustered one)  -> all queries use Clustered Index Scan and have the same estimated subtree cost
-- Index on Age -> 1,3 are the same as before
--				-> 2 uses a Nonclustered Index Seek and the estimated subtree cost is smaller
-- Index on Age including Name -> 1 is the same as before
--							   -> 2,3 now both use Nonclustered Index Seek with a decreased estimated subtree cost
						



--------------------------------------------------- c Join -------------------------------------------------------------------


CREATE VIEW ViewAll 
AS
	select *
	from Customers inner join Orders on Pid=CustomerID
	inner join Coffees on Cid=CoffeeID
	where Age = 20
GO

select * from ViewAll


CREATE index IDX_Orders_FK_CoffeeID ON Orders(CoffeeID) 
CREATE index IDX_Orders_FK_CustomerID ON Orders(CustomerID)

ALTER index IDX_Orders_FK_CoffeeID ON Orders DISABLE
ALTER index IDX_Orders_FK_CustomerID ON Orders DISABLE
ALTER index IDX_Orders_FK_CoffeeID ON Orders REBUILD
ALTER index IDX_Orders_FK_CustomerID ON Orders REBUILD

CREATE index IDX_Customers_Age_includeAll ON Customers(Age) INCLUDE (Pid,Name,LastName)
ALTER index IDX_Customers_Age_includeAll ON Customers DISABLE
ALTER index IDX_Customers_Age_includeAll ON Customers REBUILD

-- Without any indexes, there is an index scan on the PK_Orders, and estimated cost is 0.067..
-- With indexes on foreign keys, that index scan is replaced by an index seek on the nonclustered index    -> cost 0.049..
-- When I add a covering index for Age, the index scan on Customers is replaced by an index seek using it  -> cost 0.044..








CREATE PROCEDURE InsertCustomers @nrRows int
AS
	declare @name varchar(100)
	declare @lastname varchar(100)
	declare @age int
	declare @pid int
	SET @pid = 1

	while @pid<=@nrRows
		begin
			set @name = (select top 1 NewName from RandomNames order by NEWID())
			set @lastname = (select top 1 NewName from RandomNames order by NEWID())
			set @age = FLOOR(RAND()*45)+15
			INSERT into Customers values (@pid, @name, @lastname, @age)
		
			set @pid = @pid+1
		end
GO


CREATE PROCEDURE InsertCoffees @nrRows int
AS
	declare @rankingExists int
	declare @ranking int
	declare @type varchar(100)
	declare @topping varchar(100)
	declare @price float
	declare @cid int
	SET @cid = 1

	while @cid<=@nrRows
		begin
			set @type = (select top 1 NewType from RandomTypes order by NEWID())
			set @topping = (select top 1 NewExtra from RandomExtras order by NEWID())
			set @price = FLOOR(((RAND()*19)+2)*100)/100

			set @rankingExists = 1
			while @rankingExists != 0
			BEGIN
				set @ranking = FLOOR(RAND()*@nrRows)+1
				set @rankingExists = (select count(Ranking) from Coffees where Ranking=@ranking)
			END
			
			
			INSERT into Coffees values (@cid+100, @ranking, @type, @topping, @price)
		
			set @cid = @cid+1
		end
GO



CREATE PROCEDURE InsertOrders @nrRows int
AS
	declare @oid int
	set @oid = 1
	declare @customer int
	declare @coffee int
	declare @date date

	while @oid<=@nrRows
		begin
			set @date = (select dateadd(day, rand(checksum(newid()))*(1+datediff(day, '1-1-2015', '1-1-2020')), '1-1-2015'))
			
			select top 1 @customer = Pid, @coffee = Cid 
			from Customers CROSS JOIN Coffees
			order by NEWID()

			INSERT into Orders values (@oid+1000, @customer, @coffee, @date)
		
			set @oid = @oid+1
		end
GO



exec InsertCustomers 1000
exec InsertCoffees 1000
exec InsertOrders 1000
select * from Customers
select * from Coffees
select * from Orders

delete from Orders
delete from Customers
delete from Coffees



CREATE Table RandomNames (
NewName varchar(50))
INSERT INTO RandomNames VALUES ('Mike'),('Harry'),('Emma'),('Potter'),('Weasley'),('Ron'),('Hermione'),('Draco'),('Ariana'),('Ginny'),('Fred'),('George'),('Christopher'),('Logan'),('Lorelai'),('Rachel'),('Pheobe'),('Joey'),('Chandler'),('Monica'),('Ross'),('Janice'),('Rory'),('Jess'),('Dean'),('Emily'),('Richard'),('Babette'),('Emma'),('Alexia'),('Don'),('Archibald'),('Roger'),('Mariposa'),('Sheldon'),('Penny'),('Leonard'),('Howard'),('Bernadette'),('Leia'),('Anakin'),('Padme'),('Ted'),('Barney'),('Marshall'),('Robin'),('Lily'),('Paris')

CREATE Table RandomTypes (
NewType varchar(50))
INSERT INTO RandomTypes VALUES ('Cappuccino'),('Latte Macchiatto'),('Cafe au lait'),('Flat white'),('Espresso'),('Americano'),('Cortado'),('Irish'),('Lungo'),('Mocha'),('Doppio'),('Ristretto'),('Con Pana'),('Freddo'),('Frappe'),('Frappucino'),('Hot chocolate'),('Affogato'),('Black'),('Red eye'),('Macchiatto'),('Galao'),('Vienna'),('Turkish'),('Chai latte'),('Marochino'),('Corretto')

CREATE Table RandomExtras (
NewExtra varchar(50))
INSERT INTO RandomExtras VALUES ('Whipped Cream'),('Icecream'),('Caramel syrup'),('Chocolate syrup'),('Marshmallow'),('Cinnamon'),('No topping'),('No topping'),('No topping'),('No topping'),('No topping'),('No topping'),('No topping'),('No topping'),('Vanilla'),('ALmonds'),('Coconut flakes'),('Ginger'),('Sugar'),('Coconut milk'),('Soy milk'),('Honey'),('Vanila extract'),('Mint')

