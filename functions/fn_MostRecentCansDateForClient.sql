/*
most recent ansa date by client and date
select dbo.fn_MostRecentCansDateForClient('001592', '4/1/2014') as dt
*/

if OBJECT_ID('dbo.fn_MostRecentCansDateForClient') is not null
	drop function dbo.fn_MostRecentCansDateForClient

go
create function fn_MostRecentCansDateForClient (
	@id nvarchar(10),
	@dt datetime
)
returns datetime 
as 
begin 
	return (
		select Max(c.c_cans_date)
		from dbo.cans c
		where clientid = @id 
		and c.c_cans_date < @dt
	)
end