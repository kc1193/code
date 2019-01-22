SELECT
CONCAT(KPI.CAD, '-', (DATEPART(yy, KPI.tdate)), '-', (DATEPART(mm, KPI.tdate)), '-',
 (DATEPART(dd, KPI.tdate)), '-', KPI.job, '-', KPI.batchnumber, '-',
	(SELECT DP1.primpayuid WHERE DP1.CAD = 001
		UNION
		SELECT DP2.primpayuid WHERE DP2.CAD = 002
		UNION
		SELECT DP3.primpayuid WHERE DP3.CAD = 003
		UNION
		SELECT DP4.primpayuid WHERE DP4.CAD = 004
		UNION
		SELECT DP5.primpayuid WHERE DP5.CAD = 005
		UNION
		SELECT DP6.primpayuid WHERE DP6.CAD = 006)) AS 'Bill Event Key',
CONCAT(KPI.CAD, '-', (DATEPART(yy, KPI.tdate)), '-', (DATEPART(mm, KPI.tdate)), '-',
 (DATEPART(dd, KPI.tdate)), '-', KPI.job, '-', KPI.batchnumber) AS 'Bill Key',
CONCAT(KPI.CAD, '-', (DATEPART(yy, KPI.tdate)), '-', (DATEPART(mm, KPI.tdate)), '-',
 (DATEPART(dd, KPI.tdate)), '-', KPI.job, '-',
	(SELECT DP1.primpayuid WHERE DP1.CAD = 001
		UNION
		SELECT DP2.primpayuid WHERE DP2.CAD = 002
		UNION
		SELECT DP3.primpayuid WHERE DP3.CAD = 003
		UNION
		SELECT DP4.primpayuid WHERE DP4.CAD = 004
		UNION
		SELECT DP5.primpayuid WHERE DP5.CAD = 005
		UNION
		SELECT DP6.primpayuid WHERE DP6.CAD = 006)) AS 'Payment Key',
CONCAT(KPI.CAD, '-', (DATEPART(yy, KPI.tdate)), '-', (DATEPART(mm, KPI.tdate)), '-',
 (DATEPART(dd, KPI.tdate)), '-', KPI.job) AS 'Trip Key',
batchdate AS 'Batch Date',
batchnumber AS 'Batch Number',
BatchPay AS 'Batch Pay',
Schedule,
Event,
Balance,
(SELECT DP1.primpayuid WHERE DP1.CAD = 001
UNION
SELECT DP2.primpayuid WHERE DP2.CAD = 002
UNION
SELECT DP3.primpayuid WHERE DP3.CAD = 003
UNION
SELECT DP4.primpayuid WHERE DP4.CAD = 004
UNION
SELECT DP5.primpayuid WHERE DP5.CAD = 005
UNION
SELECT DP6.primpayuid WHERE DP6.CAD = 006) AS 'Primary Payor UID',
BD.BillBy AS 'Biller UID',
BD.billdate AS 'Billed Date',
H.HoldType,
CASE
    WHEN HoldType IS NULL THEN 0
    ELSE 1
END AS 'Hold Q Flag',
KPI.BatchForm


FROM ECubes.dbo.ALL_KPI_Batch AS KPI
LEFT JOIN 
OFFLINE_001.dbo.CR_DataDump_PayorUID AS DP1
ON 
KPI.CAD = DP1.CAD
AND
KPI.tdate = DP1.tdate
AND
KPI.job = DP1.job
LEFT JOIN 
OFFLINE_002.dbo.CR_DataDump_PayorUID AS DP2
ON 
KPI.CAD = DP2.CAD
AND
KPI.tdate = DP2.tdate
AND
KPI.job = DP2.job
LEFT JOIN 
OFFLINE_003.dbo.CR_DataDump_PayorUID AS DP3
ON 
KPI.CAD = DP3.CAD
AND
KPI.tdate = DP3.tdate
AND
KPI.job = DP3.job
LEFT JOIN 
OFFLINE_004.dbo.CR_DataDump_PayorUID AS DP4
ON 
KPI.CAD = DP4.CAD
AND
KPI.tdate = DP4.tdate
AND
KPI.job = DP4.job
LEFT JOIN 
OFFLINE_Daily.dbo.CR_DataDump_PayorUID AS DP5
ON 
KPI.CAD = DP5.CAD
AND
KPI.tdate = DP5.tdate
AND
KPI.job = DP5.job
LEFT JOIN 
OFFLINE_006.dbo.CR_DataDump_PayorUID AS DP6
ON 
KPI.CAD = DP6.CAD
AND
KPI.tdate = DP6.tdate
AND
KPI.job = DP6.job
INNER JOIN
	(
	SELECT '001' CAD, * FROM OFFLINE_001.dbo.KPI_BilledDate
	UNION ALL
	SELECT '002' CAD, * FROM OFFLINE_002.dbo.KPI_BilledDate
	UNION ALL
	SELECT '003' CAD, * FROM OFFLINE_003.dbo.KPI_BilledDate
	UNION ALL
	SELECT '004' CAD, * FROM OFFLINE_004.dbo.KPI_BilledDate
	UNION ALL
	SELECT '005' CAD, * FROM OFFLINE_DAILY.dbo.KPI_BilledDate
	UNION ALL
	SELECT '006' CAD, * FROM OFFLINE_006.dbo.KPI_BilledDate
	) BD
		ON
		KPI.tdate = BD.tdate
		AND
		KPI.job = BD.job
		AND
		KPI.CAD = BD.CAD
LEFT JOIN 
ECube_PreLoad.dbo.KPI_Hold AS H
ON 
KPI.CAD = H.CAD
AND
KPI.tdate = H.tdate
AND
KPI.job = H.job

WHERE
DATEDIFF(YEAR,KPI.batchdate,GETDATE()) <= 2

ORDER BY
KPI.batchdate DESC
