if OBJECT_ID('dbo.sp_AnsaDomainTotals') is not null
	drop function dbo.sp_AnsaDomainTotals

go
create procedure sp_AnsaDomainTotals(
	@start datetime,
	@end datetime
)
as
select *
from viewAnsaDomainTotals
where Asmt_Date between @start and @end
