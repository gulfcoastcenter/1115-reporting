/*
select * from fn_AdmitTotalWithMinimumYearCount ( 'RHSPA1', 3, '1/1/2012', '1/1/2015' )
*/

if OBJECT_ID('fn_AdmitTotalWithMinimumYearCount') is not null
	drop function fn_AdmitTotalWithMinimumYearCount
	
go

create function fn_AdmitTotalWithMinimumYearCount (
	@hospid nvarchar(10),
	@yearrequirement int,
	@start datetime,
	@end datetime
)
	
returns @t table (
	clientid nvarchar(10),
	[total admits] int,
	[count years] int
)
as
begin
declare @t_a table (
	clientid nvarchar(10),
	admitcount int,
	admityear int
)

insert into @t
select clientid
	, sum(count_of_admits) [total admits]
	, COUNT(year_of_admit) [count years]
from fn_CountOfAdmitsByYear ( @hospid, @start, @end )
group by clientid
having COUNT(year_of_admit) >= @yearrequirement
order by clientid
return
end