/*
declare @origin datetime ='1/1/2014'
declare @start datetime = '10/1/2014'
declare @end datetime = '4/1/2015'
declare @ru nvarchar(30) = '3301,3302,3303'

sp_CetClientAnsaOverTime '1/1/2014', '10/1/2014', '4/1/2015', '3301,3302,3303'

*/

if OBJECT_ID('dbo.sp_CetClientAnsaOverTime') is not null
	drop procedure dbo.sp_CetClientAnsaOverTime

go
create procedure sp_CetClientAnsaOverTime (
	@origin datetime,
	@start datetime,
	@end datetime,
	@ru nvarchar(30)
)

as

begin

create table #CetClients (
	id nvarchar(10)
)

insert into #CetClients 
exec uniqueClientEventsByRu @ru, @start, @end

select c.id
	, o.asmt_date [ansa date prior to 2014]
	, o.total_no_hosp [ansa total prior to 2014]
	, bc.asmt_date [ansa date prior to cet]
	, bc.total_no_hosp [ansa total prior to cet]
	, ac.asmt_date [ansa date most recent]
	, ac.total_no_hosp [ansa total most recent]
from #CetClients c

left join viewAnsaDomainTotals o
  on o.ClientID = c.id
 and o.asmt_date = dbo.fn_MostRecentAnsaDateForClient(c.id, @origin) --< '1/1/2014'
 
left join viewAnsaDomainTotals bc
  on bc.ClientID = c.id
 and bc.asmt_date = dbo.fn_MostRecentAnsaDateForClient(c.id, @start) --between '1/1/2014' and @start
 
 left join viewAnsaDomainTotals ac
  on ac.ClientID = c.id
 and ac.asmt_date = dbo.fn_MostRecentAnsaDateForClient(c.id, GETDATE()) --> @start

order by id, o.asmt_date desc, bc.asmt_date desc, ac.asmt_date desc
 
 drop table #CetClients
 
end