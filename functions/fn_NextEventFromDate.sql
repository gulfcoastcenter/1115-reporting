/*
select * from fn_NextEventFromDate('3/1/2014', '000100')
select * from client.events where clientid = '000100' order by eventdate
*/

if object_id('fn_NextEventFromDate' ) is not null
	drop function fn_NextEventFromDate

go
create function [dbo].[fn_NextEventFromDate](
	@asofdate as datetime,
	@clientid as varchar(10)
)
returns @t table (
	cid nvarchar(10),
	days_from_date int,
	event_date datetime,
	event_start datetime,
	event_sac int,
	event_ru int
)
as
begin
with cte as 
(
	select clientid, eventdate, starttime, sac, ru, clientdur, datediff(DD, @asofdate, eventdate) days_diff,
	ROW_NUMBER() over (partition by clientid order by datediff(dd, @asofdate, eventdate)) as num
	from client.Events
	where datediff(dd, @asofdate, eventdate) >= 0
	and SAC between 0 and 9000
	and sac not in ('8500')
	and Recipient in ('1','4','5','6')
	and Attendance in ('1','2','3')
	and Location not in ('8')
	and clientid = @clientid
)

insert into @t
select ClientID, days_diff, EventDate, StartTime, sac, RU
from cte 
where num = 1
order by ClientID

return
end