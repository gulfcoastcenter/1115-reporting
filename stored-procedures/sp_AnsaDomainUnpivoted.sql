/*
exec sp_AnsaDomainUnpivoted '9/1/2013', '8/31/2014'
*/

if OBJECT_ID('dbo.sp_AnsaDomainUnpivoted') is not null 
	drop procedure dbo.sp_AnsaDomainUnpivoted
	
go
create procedure sp_AnsaDomainUnpivoted (
	@start datetime,
	@end datetime
)
as	
select clientid, asmt_date, loc_r, domain, score
from (
	select a.ClientID, asmt_date, loc_r, Risk, behavior, lifedomain, family, strength, culture, hospitalization,
		total_no_hosp, total_w_hosp
	from viewAnsaDomainTotals a
	where a.asmt_date between @start and @end) p
	unpivot
	(score for domain in (Risk, behavior, lifedomain, family, strength, culture, hospitalization,
		total_no_hosp, total_w_hosp)
 ) aDomains
