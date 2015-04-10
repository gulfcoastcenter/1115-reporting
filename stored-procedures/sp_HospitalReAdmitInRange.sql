/* tests
	exec sp_HospitalReAdmitInRange 1, 'RHSPA1', 3, '4299,4300,4451,4452', .25, '10/1/2013', '9/30/2014'
	exec sp_HospitalReAdmitInRange 2, 'RHSPA1', 3, '4299,4300,4451,4452', .25, '10/1/2013', '9/30/2014'
*/

if OBJECT_ID('dbo.sp_HospitalReAdmitInRange') is not null 
	drop procedure dbo.sp_HospitalReAdmitInRange
	
go

create procedure dbo.sp_HospitalReAdmitInRange(
	@implementation int,
	@hospitalid nvarchar(10),
	@yearrequirement int,
	@servicesrequirement nvarchar(max),
	@durationrequirement decimal(6,2),
	@start datetime,
	@end datetime
)

as

declare @su_end datetime = cast('12/31/' + cast(year(@end) as varchar) as datetime)
declare @su_start datetime = cast('1/1/' + cast((year(@su_end) - 2) as varchar) as datetime)

create table #t_su (
	clientid nvarchar(10), 
	[total admits] int, 
	[count years] int, 
	[count events] int 
)

insert into #t_su
exec sp_superUserDetail @hospitalid, @yearrequirement, @servicesrequirement, @durationrequirement, @su_start, @su_end


select idx.cid
	, c.dob
	--, ansa.ansa_date as [loc date]
	--, ansa.ansa_rloc as loc
	--, ansa.C_ANSA_DATE
	--, ansa.C_ANSA_RLOC
	, case --su.clientid
		when su.clientid IS null then 0
		else 1
	end as super_user
	, idx.index_admit_dt
	, idx.index_disch_dt
	, idx.hospid
	, b.c_bd_admitdt as [readmit]
	, DATEDIFF(DAY, c.DOB, b.c_bd_admitdt)/365 as age_at_admit
	, b.c_bd_dischdt as [readmit discharge]
	, DATEDIFF(DAY, c.DOB, b.c_bd_dischdt)/365 as age_at_disch
	, b.c_bd_hospid
from fn_IndexHospAdmitDateInRange(@implementation, @start, @end) as idx
join client.client_record as c
  on c.clientid = idx.cid
left join mis_c_bd_rec as b
  on b.c_id = idx.cid
 and b.c_bd_hospid = idx.hospid
 --and b.c_bd_admitdt != idx.index_admit_dt
 and b.c_bd_admitdt between idx.index_disch_dt and dateadd(day, 30, idx.index_disch_dt)
left join #t_su su
  on su.clientid = idx.cid
--left join ansa
--  on ansa.ClientID = idx.cid
-- and ansa.C_ANSA_DATE between @start and @end
--left join 
--cross apply (
--	select ansa_date
--		, ansa_rloc
--	from fn_AnsaActiveAtPointInTime(idx.index_admit_dt) as ansa 
--	where cid = idx.cid
--	) as ansa
  
where idx.hospid = @hospitalid
order by idx.cid, b.c_bd_admitdt
