/*
exec sp_AdmitTotalWithMinimumYearCount 'RHSPA1', 3, '1/1/2012', '1/1/2015'
*/

if OBJECT_ID('sp_AdmitTotalWithMinimumYearCount') is not null
	drop procedure sp_AdmitTotalWithMinimumYearCount
	
go

create procedure sp_AdmitTotalWithMinimumYearCount (
	@hospid nvarchar(10),
	@yearrequirement int,
	@start datetime,
	@end datetime
)
	
as 

IF OBJECT_ID('tempdb..#t_a') IS NOT NULL
	drop table #t_a
	
create table #t_a (
	clientid nvarchar(10),
	admitcount int,
	admityear int
)
insert into #t_a
exec sp_CountOfAdmitsByYear @hospid, @start, @end

select clientid
	, sum(admitcount) [total admits]
	, COUNT(admityear) [count years]
from #t_a a
group by clientid
having COUNT(admityear) >= @yearrequirement
order by clientid