/*
select * from fn_NextEventFromDate('3/1/2014', '003143')
select * from client.events where clientid = '003143' order by eventdate
*/

if object_id('fn_NextEventFromDateByCredential' ) is not null
	drop function fn_NextEventFromDateByCredential

go
create function [dbo].[fn_NextEventFromDateByCredential](
	@asofdate as datetime,
	@clientid as varchar(10),
	@credentialcode as varchar(max) = null
)
returns @t table (
	cid nvarchar(10),
	days_from_date int,
	event_id int,
	event_date datetime,
	event_start datetime,
	event_staff varchar(10),
	event_sac int,
	event_ru int
)
as
begin
with cte as 
(
	select clientid, e.thekey, eventdate, starttime, e.staffid, sac, e.ru, clientdur, datediff(DD, @asofdate, eventdate) days_diff,
	ROW_NUMBER() over (partition by clientid order by datediff(dd, @asofdate, eventdate)) as num
	from client.Events e
	left join staff.staffrec s
	  on s.staffid = e.staffid
	where datediff(dd, @asofdate, eventdate) >= 0
	and SAC > 0
	and sac not in ('8500') and sac between 0 and 9000
	and Recipient in ('1','4','5','6')
	and Attendance in ('1','2','3')
	and Location not in ('8')
	and clientid = @clientid
	and (@credentialcode is null or s.Licensure in (select Data from dbo.Split(@credentialcode, ',')))
)

insert into @t
select ClientID, days_diff, thekey, EventDate, StartTime, staffid, sac, RU
from cte 
where num = 1
order by ClientID

return
end