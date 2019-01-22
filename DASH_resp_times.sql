/*USE [STAGING]
GO

/****** Object:  View [dbo].[DASH_resp_times]    Script Date: 12/4/2018 5:16:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[DASH_resp_times] AS*/

		SELECT EX.CAD, EX.job, EX.company, EX.disptime, EX.tdate, EX.atstime, EX.atsdate,
			   /*DATEPART(SECOND,(CAST(EX.atsdate AS datetime)) - CAST(EX.tdate AS datetime)) AS resp_time_day,
			   DATEPART(HOUR,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) AS resp_time_hour,
			   DATEPART(MINUTE,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) AS resp_time_minute,
			   DATEPART(SECOND,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) AS resp_time_second,*/
			   /*(DATEPART(SECOND,(CAST(EX.atsdate AS datetime)) - CAST(EX.tdate AS datetime)) * 24 * 60) AS conv_days_mins,
			   (DATEPART(HOUR,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) * 60) AS conv_hours_mins,
			   (DATEPART(MINUTE,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime))) AS conv_mins,
			   CONVERT(decimal(10,2),(DATEPART(SECOND,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)))/60) AS conv_secs_mins,*/

			   (DATEPART(SECOND,(CAST(EX.atsdate AS datetime)) - CAST(EX.tdate AS datetime)) * 24 * 60 * 60) +
			   (DATEPART(HOUR,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) * 60 * 60) +
			   (DATEPART(MINUTE,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) * 60) +
			   (DATEPART(SECOND,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime))) AS resp_time_in_secs,

			   CONVERT(decimal(10,2),((DATEPART(SECOND,(CAST(EX.atsdate AS datetime)) - CAST(EX.tdate AS datetime)) * 24 * 60 * 60) +
			   (DATEPART(HOUR,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) * 60 * 60) +
			   (DATEPART(MINUTE,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)) * 60) +
			   (DATEPART(SECOND,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)))))/60 AS resp_time_in_mins,
						CONCAT(
							DATEPART(SECOND,(CAST(EX.atsdate AS datetime)) - CAST(EX.tdate AS datetime)), 'D ',
							DATEPART(HOUR,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)), 'H ',
							DATEPART(MINUTE,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)), 'm ',
							DATEPART(SECOND,(CAST(EX.atstime AS datetime)) - CAST(EX.disptime AS datetime)), 's ') AS resp_time_string,
		CONCAT(EX.CAD, '-', EX.tdate, '-', EX.job) AS 'KEY'
				
FROM ecubes.dbo.Daily_DataDump_Exception EX
WHERE EX.atsdate NOT LIKE '%1900%'
	  AND
	  cxltime < atstime
	  AND
	  cxldate < atsdate
	  AND
	  DATEDIFF(MONTH, EX.tdate, GETDATE()) <= 18

GO
