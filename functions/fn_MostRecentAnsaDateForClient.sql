/*
most recent ansa date by client and date
select dbo.fn_MostRecentAnsaDateForClient('001592', '4/1/2014') as dt
*/

if OBJECT_ID('dbo.fn_MostRecentAnsaDateForClient') is not null
	drop function dbo.fn_MostRecentAnsaDateForClient

go
create function fn_MostRecentAnsaDateForClient (
	@id nvarchar(10),
	@dt datetime
)
returns datetime 
as 
begin 
	return (
		select Max(asmt_date)
		from viewAnsaDomainTotals
		where clientid = @id and asmt_date < @dt
	)
end