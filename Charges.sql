SELECT
	CONCAT(DCA.CAD, '-', (DATEPART(yy, DCA.tdate)), '-', (DATEPART(mm, DCA.tdate)), '-',
	 (DATEPART(dd, DCA.tdate)), '-', DCA.job, '-', DCA.TripAddonUID) AS 'Charge Key', --[CAD-Trip Date-Job-Sequence ID]
	DCA.postdate AS 'Charge Date',
	DCA.RevCharge AS 'Reversing Identifier',
	DCA.Modifier,
	DCA.TotChg,
	DCA.Charge,
	DCA.TimeStamp
 FROM ECubes.dbo.DAILY_Charges_ALL AS DCA
 WHERE
	DATEDIFF(MONTH, DCA.tdate, GETDATE()) <= 18
