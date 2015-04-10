
/*
exec sp_superUserDetail 'RHSPA1', 3, '4300', .25, '1/1/2012', '1/1/2015'
*/

go
if OBJECT_ID('sp_superUserDetail') is not null 
	drop procedure sp_superUserDetail

go
create procedure sp_superUserDetail (
	@hospitalid nvarchar(10),
	@yearrequirement int,
	@servicesrequirement nvarchar(max),
	@durationrequirement decimal(6,2),
	@start datetime,
	@end datetime
)
as
select a.clientid, a.[total admits], a.[count years], COUNT(e.sac) [count events] 
from fn_AdmitTotalWithMinimumYearCount ( 'RHSPA1', 3, '1/1/2012', '1/1/2015' ) a
join Client.Events e
  on e.ClientID = a.clientid
 and e.EventDate between @start and @end
 and e.ClientNDur > @durationrequirement
 and e.SAC in ( select data from dbo.Split(@servicesrequirement, ',') )
group by a.ClientID, a.[total admits], a.[count years]