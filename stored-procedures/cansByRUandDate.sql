GO
/****** Object:  StoredProcedure [dbo].[cansByRUandDate]    Script Date: 02/25/2015 09:16:56 ******/
-- test: exec ansaByRUandDate '3301,3302,3303,3401', '10/1/2014', '4/1/2015'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[cansByRUandDate]
	@RuList as nvarchar(max),
	@StartDate as DateTime,
	@EndDate as DateTime
	
as
	
if object_id('tempdb..#tempClientList') is not null 
	drop table #tempClientList

create table #tempClientList (id nvarchar(10))
insert into #tempClientList
exec uniqueClientEventsByRU @RuList, @StartDate, @Enddate

select a.*
from cans a
join #tempClientList c
on c.id = a.ClientID
order by clientid