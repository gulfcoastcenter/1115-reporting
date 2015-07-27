
if OBJECT_ID ('ansaByRUandDate') is not null 
	drop procedure [ansaByRUandDate]
go

Create procedure [dbo].[ansaByRUandDate]
	@RuList as nvarchar(max),
	@SacList as nvarchar(max) = null,
	@StartDate as DateTime,
	@EndDate as DateTime
	
as
	
if object_id('tempdb..#tempClientList') is not null 
	drop table #tempClientList

create table #tempClientList (id nvarchar(10))
insert into #tempClientList
exec uniqueClientEventsByRU @RuList, @saclist, @StartDate, @Enddate

select a.*
from ansa a
join #tempClientList c
on c.id = a.ClientID
order by clientid