use wood
if OBJECT_ID ('uniqueClientEventsByRu') is not null 
	drop procedure uniqueClientEventsByRu
go
create procedure uniqueClientEventsByRu
	@EventRu as nvarchar(max),
	@StartDate as DateTime,
	@EndDate as DateTime
as 
	select distinct clientid
	from Client.Events
	where RU In (
		select data from dbo.Split(@EventRu, ',')
	)
	and EventDate between @startdate and @enddate
        and Attendance in ('1', '2', '3')
        and Recipient in ('1', '4', '5', '6')
        and Location not in ('8')
        and ClientDur > '0'
go
