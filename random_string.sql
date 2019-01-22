DECLARE @inabit DATETIME
DECLARE @inabit2 DATETIME
--DECLARE @future DATETIME
SET @inabit = DATEADD(S, 10, GETDATE())
SET @inabit = DATEADD(S, 5, GETDATE())
--SET @future = '2018-12-12 19:35:50.830'

DECLARE @Length int
DECLARE @CharPool varchar(max)
DECLARE @PoolLength int
DECLARE @RandomString varchar(max)
DECLARE @LoopCount int

DECLARE @UN sysname
DECLARE @PW sysname
DECLARE @S nvarchar(500)

SET @UN = 'rando'

SET @Length = RAND() * 36 + 24

SET @CharPool = 
    'abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ23456789.,-_!$@#%^&*'
SET @PoolLength = Len(@CharPool)

SET @LoopCount = 0
SET @RandomString = ''

WHILE (@LoopCount < @Length) BEGIN
    SELECT @RandomString = @RandomString + 
        SUBSTRING(@Charpool, CONVERT(int, RAND() * @PoolLength), 1)
    SELECT @LoopCount = @LoopCount + 1
END
SELECT @RandomString AS 'Random String'

set @PW = @RandomString

set @S = 'ALTER LOGIN ' + quotename(@UN) + ' WITH PASSWORD = ' + quotename(@PW, '''')

exec (@S)

WAITFOR TIME @inabit
