
exec sp_activeAnsaAsOfDate '2/1/2015'

create procedure sp_activeAnsaAsOfDate(
	@asofdate datetime
)

as

select a.*
	
from ansa a
left join ansa a2
  on a2.ClientID = a.ClientID
 and a.C_ANSA_DATE < a2.C_ANSA_DATE
where a2.C_ANSA_DATE is null
 and a.C_ANSA_DATE <= @asofdate

