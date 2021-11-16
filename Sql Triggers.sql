
--1. Kitabxanada olmayan kitabları , kitabxanadan götürmək olmaz.



CREATE TRIGGER TASK_1_SCard
ON S_Cards
AFTER INSERT 
AS
BEGIN

SET NOCOUNT ON

IF (SELECT Quantity FROM inserted JOIN Books ON Books.Id=Id_Book)<0
	BEGIN
		PRINT 'This Book Have Not in Libary'
		ROLLBACK TRAN
	END
ELSE
	BEGIN
		PRINT 'Every Things OK'
	END

END

GO

CREATE TRIGGER TASK_1_TCard
ON T_Cards
AFTER INSERT 
AS
BEGIN

SET NOCOUNT ON

IF (SELECT Quantity FROM inserted JOIN Books ON Books.Id=Id_Book)<0
	BEGIN
		PRINT 'This Book Have Not in Libary'
		ROLLBACK TRAN
	END
ELSE
	BEGIN
		PRINT 'Every Things OK'
	END

END

INSERT INTO S_Cards VALUES(30,9,14,'2001-04-21 00:00:00.000',NULL,1)




--2. Müəyyən kitabı qaytardıqda, onun Quantity-si (sayı) artmalıdır.
GO

CREATE PROCEDURE ReturnBook 
@BookName AS NVARCHAR(MAX)
AS
BEGIN 

UPDATE Books
SET Quantity=Quantity+1
WHERE Books.[Name]=@BookName

END

SELECT * FROM Books WHERE Id=1
EXEC ReturnBook 'SQL'
SELECT * FROM Books WHERE Id=1

--3. Kitab kitabxanadan verildikdə onun sayı azalmalıdır.
GO

CREATE TRIGGER TASK_3_SCARD
ON S_Cards
AFTER INSERT 
AS
BEGIN

UPDATE Books
SET Quantity=Quantity-1
WHERE (SELECT Id_Book FROM inserted )=Books.Id

END

GO

CREATE TRIGGER TASK_3_TCARD
ON S_Cards
AFTER INSERT 
AS
BEGIN

UPDATE Books
SET Quantity=Quantity-1
WHERE (SELECT Id_Book FROM inserted )=Books.Id

END

GO
SELECT * FROM Books
WHERE Id=1

INSERT INTO S_Cards VALUES(33,7,1,'2001-04-21 00:00:00.000',NULL,1)

SELECT * FROM Books
WHERE Id=1


--4. Bir tələbə artıq 3 itab götütürübsə ona yeni kitab vermək olmaz.
GO

CREATE TRIGGER TASK4_SCARD
ON S_Cards
AFTER INSERT
AS
BEGIN 

IF(SELECT COUNT(S_Cards.Id_Book) FROM S_Cards Where(SELECT Id_Student FROM inserted)=S_Cards.Id_Student GROUP BY S_Cards.Id_Student)>3
	BEGIN
		PRINT 'We cant give you a book Because You Taked So many book'
		ROLLBACK TRAN
	END
ELSE 
	PRINT 'No Problem'
END


INSERT INTO S_Cards VALUES(101,5,1,'2001-04-21 00:00:00.000',NULL,2)




--5. Əgər tələbə bir kitabı 2aydan çoxdur oxuyursa, bu halda tələbəyə yeni kitab vermək olmaz.

CREATE TRIGGER TASK5_SCARD
ON S_Cards
INSTEAD OF INSERT
AS
BEGIN

IF (DATEDIFF(month,(SELECT TOP 1 DateOut FROM S_Cards WHERE (SELECT Id_Student FROM inserted) = Id_Student ORDER BY Id DESC),(SELECT DateOut FROM inserted))<3)
	Print 'No Problem'
ELSE
BEGIN
 PRINT 'We cant give you a book Date Time Problem'
 ROLLBACK TRAN
 END
END


INSERT INTO S_Cards VALUES(106,5,1,'2001-06-21 00:00:00.000',NULL,2)

--6. Kitabı bazadan sildikdə, onun haqqında data LibDeleted cədvəlinə köçürülməlidir.

--Lib Deleted Deye bir table yoxdu axi



































































































