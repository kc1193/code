SELECT
CONCAT(TC.CAD, '-', (DATEPART(yy, TC.tdate)), '-', (DATEPART(mm, TC.tdate)), '-',
 (DATEPART(dd, TC.tdate)), '-', TC.job, '-', 
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
		SELECT DP6.primpayuid WHERE DP6.CAD = 006)) AS 'Payment Key', --CAD-Trip Date-Job-PrimPayorUID
			/*CONCAT(TC.CAD, '-', (DATEPART(yy, TC.tdate)), '-', (DATEPART(mm, TC.tdate)), '-',
			 (DATEPART(dd, TC.tdate)), '-', TC.job, '-', 
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
				SELECT DP6.primpayuid WHERE DP6.CAD = 006), '-',
				TC.depositDate) AS 'Payment UID', --CAD-Trip Date-Job-PrimPayorUID-Deposit Date*/
			TC.CredUID,
		CONCAT(TC.CAD, '-', (DATEPART(yy, TC.tdate)), '-', (DATEPART(mm, TC.tdate)), '-',
			(DATEPART(dd, TC.tdate)), '-', TC.job) AS 'Trip Key',
			TC.depositDate AS 'Deposit Date',
			TC.postdate AS 'Post Date',
			TC.CreditPayor AS 'Credit Payor',
			TC.PaidAmt,
			TC.CreditType

FROM ecubes.dbo.DAILY_TripCredits AS TC
	LEFT JOIN 
	OFFLINE_001.dbo.CR_DataDump_PayorUID AS DP1
	ON 
	TC.CAD = DP1.CAD
	AND
	TC.tdate = DP1.tdate
	AND
	TC.job = DP1.job
	LEFT JOIN 
	OFFLINE_002.dbo.CR_DataDump_PayorUID AS DP2
	ON 
	TC.CAD = DP2.CAD
	AND
	TC.tdate = DP2.tdate
	AND
	TC.job = DP2.job
	LEFT JOIN 
	OFFLINE_003.dbo.CR_DataDump_PayorUID AS DP3
	ON 
	TC.CAD = DP3.CAD
	AND
	TC.tdate = DP3.tdate
	AND
	TC.job = DP3.job
	LEFT JOIN 
	OFFLINE_004.dbo.CR_DataDump_PayorUID AS DP4
	ON 
	TC.CAD = DP4.CAD
	AND
	TC.tdate = DP4.tdate
	AND
	TC.job = DP4.job
	LEFT JOIN 
	OFFLINE_Daily.dbo.CR_DataDump_PayorUID AS DP5
	ON 
	TC.CAD = DP5.CAD
	AND
	TC.tdate = DP5.tdate
	AND
	TC.job = DP5.job
	LEFT JOIN 
	OFFLINE_006.dbo.CR_DataDump_PayorUID AS DP6
	ON 
	TC.CAD = DP6.CAD
	AND
	TC.tdate = DP6.tdate
	AND
	TC.job = DP6.job
WHERE DATEDIFF(MONTH,TC.tdate,GETDATE()) <= 18
AND
(TC.CreditType LIKE '%payment%'
OR
TC.CreditType LIKE '%refund%')
AND
TC.PaidAmt <> 0
