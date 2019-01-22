SELECT
	DK.tdate AS 'Trip Date',
	ASE.agingDate AS 'Aging Date',
	DK.CAD,
	DK.Company,
	DK.[AMB-NAT(EXT)],
	DK.CostCenter AS 'Cost Center',
	DK.TripMo AS 'Trip Month',
	DK.ServiceLevel AS 'Service Level',
	DK.tripstatus AS 'Trip Status',
	DK.Job,
	DK.runnumber AS 'Run Number',
	DK.primpaycat AS 'Primary Payor Category',
	DK.secpaycat AS 'Secondary Payor Category',
	--CONCAT(DATEPART(yy, GETDATE()), DATEPART(mm, GETDATE())) AS Period,
	DK.grosscharges AS 'Gross Charges',
	DK.Contractuals,
	DK.Writeoffs,
	--adjustments,
	DK.Payments,
	DK.Refunds,
	--tripcnt,
	DK.Loadedmiles,
	DK.puzip AS 'Pick-Up Zip',
	DK.overridemod AS 'Override Modifier',
	DK.[911-Non911],
	CONCAT(DK.CAD, '-', (DATEPART(yy, DK.tdate)), '-', (DATEPART(mm, DK.tdate)), '-', (DATEPART(dd, DK.tdate)), '-', DK.job) AS 'KEY',
	DK.baseratecharge AS 'Base Rate Charge',
	DK.orderfac AS 'Ordering Facility',
	DK.primpay AS 'Primary Payor',
	DK.secpay AS 'Secondary Payor',
	DK.Dialysis,
	--CONCAT(DK.CAD, '-', DK.TripDate, '-', DK.job, '-') AS 'CHARGE KEY', --sequence id?
	DK.disppriority AS 'Dispatch Priority',
	DK.currpay AS 'Current Payor',
	DK.currpaycat AS 'Current Payor Category',
	DK.pufac AS 'Pick-Up Facility',
	EX.HoldType,
	EX.FirstHold,
	DK.Schedule,
	DK.Events,
	EX.billdate_txt AS 'Bill Date',
	DK.TimeStamp

  FROM ECubes.dbo.Daily_DataDump_NOKPI DK
    LEFT JOIN STAGING.dbo.DASH_AgingSchedEvent ASE 
		ON DK.tdate = ASE.tdate 
		AND DK.CAD = ASE.CAD
		AND DK.job = ASE.job

	LEFT JOIN ECubes.dbo.Daily_DataDump_Exception EX
		ON DK.tdate = EX.tdate
		AND DK.CAD = EX.CAD
		AND DK.job = EX.job

 WHERE DK.tdate >= '2014-01-01'

 ORDER BY DK.tdate DESC
