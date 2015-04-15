/*
exec sp_UniqueClientWithEvents 3600, '480,1500,1501,2201,2202,2203,2204,2205,460', '1/1/2000', '10/1/2014', '4/30/2015' 
*/

if OBJECT_ID('sp_UniqueClientWithEvents') is not null
	drop procedure sp_UniqueClientWithEvents

go

create procedure sp_UniqueClientWithEvents (
	@Ru nvarchar(max),
	@Sac nvarchar(max),
	@prog_start datetime,
	@start datetime,
	@end datetime
)

as

select u.clientid
	, e.EventDate
	, e.SAC
	, s.description
	, e.ru
	, r.Name
	, e.StaffID
	, e.Attendance
	, e.Recipient
	, e.Location
	, e.ClientNDur
from fn_UniqueClientEventsByRu(@Ru, @Sac, @prog_start, @end) u
join Client.Events e
  on u.clientid = e.ClientID
 and e.EventDate between @start and @end
	and e.RU in (select data from Split(@Ru, ','))
    and e.Attendance in ('1', '2', '3')
    and e.Recipient in ('1', '4', '5', '6')
    and e.Location not in ('8')
    and e.ClientNDur > 0

left join SysFile.RU r
  on r.RU = e.RU
left join SysFile.SAC s
  on s.SAC = e.SAC
  
  order by u.clientid, e.EventDate