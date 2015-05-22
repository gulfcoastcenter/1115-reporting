declare @start datetime = '10/1/2013'
declare @end datetime = '8/31/2014'

select 
	bd.c_id [client]
	, bd.c_bd_admitdt [admit date]
	, bd.c_bd_dischdt [discharge date]
	, e.event_date [follow up date]
	, DATEDIFF(dd, bd.c_bd_dischdt, e.event_date) [days to follow up]
	, (DATEDIFF(dd, c.dob, bd.c_bd_dischdt) / 365 ) [age at discharge]
	, case when (DATEDIFF(dd, c.dob, bd.c_bd_dischdt) / 365 ) < 6
		then 'Y'
		else 'N'
	  end [exclude by age]
	, case when dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) > 0
		then 'Y'
		else 'N'
	   end [exclude by readmit]
	, e.event_sac [Service Code]
	, e.event_ru [RU]
from mis_c_bd_rec bd
left join Client.Client_Record c
  on c.ClientID = bd.c_id
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end

