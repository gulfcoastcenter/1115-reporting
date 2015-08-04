/*
exec sp_FollowUpEventAfterHospitalAdmitInRange '10/1/2013', '9/30/2014', 'RHSPA1'
*/

if object_id('sp_FollowUpEventAfterHospitalAdmitInRange' ) is not null
	drop procedure sp_FollowUpEventAfterHospitalAdmitInRange

go
create procedure [dbo].[sp_FollowUpEventAfterHospitalAdmitInRange](
	@start as datetime,
	@end datetime,
	@hospid as varchar(10)
)
as
select b.c_id client_id
	, b.c_bd_admitdt admit_date
	, b.c_bd_dischdt discharge_date
	, e.days_from_date days_to_followup
	, e.event_date followup_date
	, e.event_sac followup_service_code
from mis_c_bd_rec b
outer apply fn_NextEventFromDate(b.c_bd_dischdt, b.c_id) e
where c_bd_admitdt between @start and @end
 and c_bd_hospid = @hospid