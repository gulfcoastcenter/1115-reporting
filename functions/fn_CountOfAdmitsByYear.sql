
/*
exec fn_CountOfAdmitsByYear 'RHSPA1', '1/1/2012', '1/1/2015'
*/

if OBJECT_ID('fn_CountOfAdmitsByYear') is not null
	drop function fn_CountOfAdmitsByYear
	
go

create function fn_CountOfAdmitsByYear (
	@hospid nvarchar(10),
	@start datetime,
	@end datetime
)
returns @t table (
	clientid nvarchar(10),
	count_of_admits int,
	year_of_admit int
)
as
begin
	insert into @t
	select bd.c_id
		, count(bd.c_bd_admitdt) count_of_admits
		, year(bd.c_bd_admitdt) year_of_admit
	from mis_c_bd_rec bd
	where bd.c_bd_admitdt between @start and @end
	and bd.c_bd_hospid = @hospid
	group by bd.c_id, YEAR(bd.c_bd_admitdt)
return 
end