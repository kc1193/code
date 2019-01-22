SELECT DISTINCT
	DD.CAD,
	DD.Company,
	CU.Custno AS 'Customer Number',
	CU.DOB,
	CONCAT(DD.CAD, '-', CU.custno) AS 'Customer Key'
	
FROM RCSQL.dbo.Customers AS CU
	LEFT JOIN 
	OFFLINE.dbo.CR_DataDump_vw_DAILY AS DD
	ON 
	CU.custno = DD.custno
	LEFT JOIN
	OFFLINE_GTR.dbo.CR_CM_Trip_CLS AS GTR
	ON 
	CU.custno = GTR.custno
WHERE 
	DATEDIFF(YEAR, CU.dob, GETDATE()) >= 65
	AND
	DATEDIFF(YEAR, CU.dob, GETDATE()) <= 130
	AND
	(DD.primpay LIKE '%self-pay%'
	OR
	DD.primpay LIKE '%none%'
	OR
	DD.primpay LIKE '%bill patient%')
	AND
	DATEDIFF(MONTH, DD.tdate, GETDATE()) <= 12
