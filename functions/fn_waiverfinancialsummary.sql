
--select * from fn_waiverfinancialsummary('3301,3302,3303', 'c/w/c')
drop function fn_waiverfinancialsummary

go
create function fn_waiverfinancialsummary(
	@rus nvarchar(max),
	@name nvarchar(64)
)

returns @t table (
	Project nvarchar(64)
	, RU int
	, Year_budget int
	, Period int
	, PeriodDesc nvarchar(32)
	, [RevenueDSRIP] float
	, [RevenueOther] float
	, [RevenueTotal] float
	, [ExpenseStaff] float
	, [ExpenseOther] float
	, [ExpenseTotal] float
)

begin

declare @expensestaff nvarchar(max) = '6000,6001'
declare @expenseother nvarchar(max) = '6010,6015,6018,6020,6030,6035,6040,6045,6050,6055,6060,6065,6070,6075,6080,6090,6105,6110,6115,6205,6210,6305,6405,6410,6415,6420'
declare @expensetotal nvarchar(max) = '6000,6001,6010,6015,6018,6020,6030,6035,6040,6045,6050,6055,6060,6065,6070,6075,6080,6090,6105,6110,6115,6205,6210,6305,6405,6410,6415,6420'
declare @revenuedisrp nvarchar(max) = '5825'
declare @revenueother nvarchar(max) = '5001,5005,5020,5025,5105,5110,5310,5320,5330,5340,5505,5510,5520,5525,5530,5605,5610,5615,5620,5705,5805,5810,5815,5820'
declare @revenuetotal nvarchar(max) = '5825,5001,5005,5020,5025,5105,5110,5310,5320,5330,5340,5505,5510,5520,5525,5530,5605,5610,5615,5620,5705,5805,5810,5815,5820'

insert into @t
select  
	Project
	, RU
	, Year_budget
	, Period
	, PeriodDesc
	, [RevenueDSRIP], [RevenueOther], [RevenueTotal], [ExpenseStaff], [ExpenseOther], [ExpenseTotal]
from
(
	select *
	from fn_GroupAccountTotals(@rus, @expensestaff, @name, 'ExpenseStaff')
	union
	select *
	from fn_GroupAccountTotals(@rus, @expenseother, @name, 'ExpenseOther')
	union
	select *
	from fn_GroupAccountTotals(@rus, @expensetotal, @name, 'ExpenseTotal')
	union
	select *
	from fn_GroupAccountTotals(@rus, @revenuedisrp, @name, 'RevenueDSRIP')
	union
	select *
	from fn_GroupAccountTotals(@rus, @revenueother,	@name, 'RevenueOther')
	union
	select *
	from fn_GroupAccountTotals(@rus, @revenuetotal,	@name, 'RevenueTotal')
) a

pivot 
(
	sum(a.Total)
	for a.Account_Group in ([RevenueDSRIP], [RevenueOther], [RevenueTotal], [ExpenseStaff], [ExpenseOther], [ExpenseTotal])
) as pt

order by project, RU, year_budget desc, period

return
end