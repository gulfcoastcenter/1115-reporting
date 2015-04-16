/*
  select * from fn_IndexHospAdmitDateInRange(0, '10/1/2013', '9/30/2014')
  select * from fn_IndexHospAdmitDateInRange(1, '10/1/2014', '3/31/2015')
  select * from fn_IndexHospAdmitDateInRange(2, '10/1/2013', '9/30/2014')
*/

if OBJECT_ID('dbo.fn_IndexHospAdmitDateInRange') is not null
	drop function dbo.fn_IndexHospAdmitDateInRange

go
create function fn_IndexHospAdmitDateInRange(
	@implementation as int,
	@start as datetime,
	@end as datetime
)
returns @t table (
	cid nvarchar(10),
	hospid nvarchar(10),
	index_admit_dt datetime,
	index_disch_dt datetime
)
as
begin
	declare @adj_start as datetime = dateadd(month, -1, @start)
	declare @adj_end as datetime = dateadd(MONTH, -1, @end)
	if @implementation = 0 
		insert into @t
			SELECT b2.[c_id]
				,b2.[c_bd_hospid]
				, MIN(b2.c_bd_admitdt) as [index_admit_dt]
				, MIN(b2.c_bd_dischdt) as [index_disch_dt]
			FROM [WOOD].[dbo].[mis_c_bd_rec] b
			left join mis_c_bd_rec b2
			  on b.c_id = b2.c_id 
			 and b2.c_bd_hospid = b.c_bd_hospid
			 and b2.c_bd_admitdt < b.c_bd_admitdt
			where b2.c_bd_admitdt between @adj_start and @adj_end 
			group by b2.[c_id]
				  ,b2.[c_bd_hospid]
			order by c_id
	if @implementation = 1 
		insert into @t
			SELECT b2.[c_id]
				,b2.[c_bd_hospid]
				, b2.c_bd_admitdt as [index_admit_dt]
				, b2.c_bd_dischdt as [index_disch_dt]
			FROM [WOOD].[dbo].[mis_c_bd_rec] b
			left join mis_c_bd_rec b2
			  on b.c_id = b2.c_id 
			 and b2.c_bd_hospid = b.c_bd_hospid
			 and b2.c_bd_admitdt < b.c_bd_admitdt
			where b2.c_bd_admitdt between @adj_start and @adj_end 
			group by b2.[c_id]
				  ,b2.[c_bd_hospid]
				  , b2.c_bd_admitdt
				  , b2.c_bd_dischdt
			order by c_id
	if @implementation = 2 
		insert into @t
			select c.c_id
				, c.c_bd_hospid
				, c.c_bd_admitdt
				, c.c_bd_dischdt
			from mis_c_bd_rec b
			left join mis_c_bd_rec c
			  on c.c_id = b.c_id
			  and c.c_bd_hospid = b.c_bd_hospid
			  and c.c_bd_admitdt < @adj_end
			  and (
				c.c_bd_admitdt = (
					select MIN(c_bd_admitdt) from mis_c_bd_rec e
					where e.c_id = b.c_id
					and e.c_bd_hospid = b.c_bd_hospid
					and e.c_bd_admitdt > DATEADD(day, 30, b.c_bd_dischdt)
				) or
				c.c_bd_admitdt = (
					select MIN(c_bd_admitdt) from mis_c_bd_rec d 
					where d.c_id = b.c_id and d.c_bd_hospid = b.c_bd_hospid
					and d.c_bd_admitdt between @adj_start and @adj_end
				)
			)

			 
			where b.c_bd_admitdt between @adj_start and @adj_end
			group by c.c_id
				, c.c_bd_hospid
				, c.c_bd_admitdt
				, c.c_bd_dischdt

			order by c.c_id
				, c.c_bd_hospid
				, c.c_bd_admitdt asc
	return
end