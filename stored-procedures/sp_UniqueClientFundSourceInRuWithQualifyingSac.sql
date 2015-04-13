/*
exec sp_UniqueClientFundSourceInRuWithQualifyingSac '480,1501', 3600, '1/1/2000', '4/30/2015'
*/

if OBJECT_ID ('sp_UniqueClientFundSourceInRuWithQualifyingSac') is not null 
	drop procedure sp_UniqueClientFundSourceInRuWithQualifyingSac
go

create procedure sp_UniqueClientFundSourceInRuWithQualifyingSac (

	@qualifyingsac nvarchar(max),
	@ru int,
	@start datetime,
	@end datetime
)

as

select e.ClientID, i.FundSource, f.description
from Client.Events e
left join Client.Eligibility i
 on i.ClientID = e.ClientID
and i.StartDate < @end
and (i.EndDate > @start or i.EndDate is null)
left join SysFile.FundSource f
 on f.FundSource = i.FundSource
where 
	e.SAC in ( select data from Split(@qualifyingsac, ','))
	and e.RU = @ru
	and e.EventDate between @start and @end
        and Attendance in ('1', '2', '3')
        and Recipient in ('1', '4', '5', '6')
        and Location not in ('8')
        and ClientNDur > 0

group by e.ClientID, i.FundSource, f.description
order by e.ClientID, i.FundSource, f.Description

