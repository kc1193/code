SELECT 
	BS.Supervisor,
	BS.BillingOffice,
	BS.CompanyCorr company_corr,
	CASE 
		WHEN HQ.HoldQ IS NOT NULL THEN 'On Hold' 
		WHEN DataDump.billdate IS NULL THEN 'Un-Billed' 
		ELSE 'Billed' 
	END [BillStatus],
	CASE WHEN HQ.HoldQ IS NULL THEN '' ELSE 'On Hold' END [HoldStatus],
	DataDump.company,
	DataDump.disppriority,
	DataDump.Schedule,
	DataDump.tdate,
	DataDump.TripMo,
	DataDump.tripstatus,
	DataDump.runnumber,
	DataDump.[AMB-NAT],
	DataDump.currpay,
	HQ.HoldQ,
	HQ.HoldQType,
	RG.Region,
	RG.RegionVP,
	1 GRP
FROM
	ECubes.dbo.Daily_DataDump_Exception DataDump
	LEFT OUTER JOIN
	ECube_PreLoad.dbo.CR_HoldQ HQ
		ON
		DataDump.Schedule = HQ.HoldSched
	LEFT OUTER JOIN
	ECube_PreLoad.dbo.CR_BillSupervisor BS
		ON
		DataDump.company = BS.Company
	LEFT OUTER JOIN
	ECube_PreLoad.dbo.CR_Regions RG
		ON
		DataDump.Company = RG.Company

WHERE
	DataDump.tripstatus IN ('Billed','Complete','Not Billed','On Hold','Verified')
	AND
	DataDump.tdate BETWEEN 
		CAST(dateadd(d,-(day(dateadd(m,-1,getdate()-2))),dateadd(m,-1,getdate()-1)) AS DATE)
		AND
		CAST(DATEADD(d,-1,GETDATE()) AS DATE)
	AND
	disppriority NOT IN('Priority 10','Priority 11 - GAREP','Priority 8','Priority 9')
	AND
	[AMB-NAT] IN ('AMB','NAT')
	AND
	DataDump.primpaycat NOT IN ('LifeLink','VA')
	AND
	disppriority NOT LIKE 'Priority 0%'
	AND
	disppriority NOT LIKE 'P 7 - Standby%'
	AND
	disppriority NOT LIKE 'P 8 - Event%'
	AND
	disppriority NOT LIKE 'P 9 - Central Care%'
	AND
	disppriority NOT LIKE 'P 10 - Air Med%'
