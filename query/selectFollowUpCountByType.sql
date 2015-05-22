declare @start datetime = '10/1/2013'
declare @end datetime = '8/31/2014'

select 
	'same day followup' [count type]
	,count(bd.c_id) [count of followup events]
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
and e.days_from_date = 0
union
select
	'with 7 days', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
and e.days_from_date between 0 and 7
union
select
	'with 30 days', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
and e.days_from_date between 0 and 30
union
select
	'> 30 days', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
and (e.days_from_date > 30)
union
select
	'none', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
and (e.days_from_date is null)
union
select
	'some', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
and (e.days_from_date is not null)
union
select
	'all', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
 
 union
select
	'excluded', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) > 0
 
 union
select
	'all+excluded', COUNT(bd.c_id) 
from mis_c_bd_rec bd
outer apply fn_NextEventFromDate(bd.c_bd_dischdt, bd.c_id) e
 where bd.c_bd_dischdt between @start and @end
 --and dbo.fn_ReadmissionIn30days(bd.c_id, bd.c_bd_dischdt) = 0
