/*
exec uniqueClientEventsByRu 3600, '480,1500,1501,2201,2202,2203,2204,2205,460', '10/1/2000', '4/30/2015'
*/

if OBJECT_ID ('uniqueClientEventsByRu') is not null 
	drop procedure uniqueClientEventsByRu
go
create procedure uniqueClientEventsByRu
	@EventRu as nvarchar(max),
	@QualifyingSac as nvarchar(max),
	@StartDate as DateTime,
	@EndDate as DateTime
as 
	select distinct clientid
	from Client.Events
	where RU In (
		select data from dbo.Split(@EventRu, ',')
	)
	and (@QualifyingSac is null or SAC in (
		select data from dbo.Split(@QualifyingSac, ',')
	))
	and EventDate between @startdate and @enddate
        and Attendance in ('1', '2', '3')
        and Recipient in ('1', '4', '5', '6')
        and Location not in ('8')
        and ClientDur > '0'
    order by ClientID
go
