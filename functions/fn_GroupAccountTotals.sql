--declare @ru_group nvarchar(max) = '3301,3302,3303'
--declare @ru_group_name nvarchar(64) = 'c/w/c'
--declare @acct_group nvarchar(max) = '6000,6005'
--declare @acct_group_name nvarchar(64) = 'Staff_Expenses'

--go
if OBJECT_ID('fn_GroupAccountTotals') is not null
	drop function fn_GroupAccountTotals

go
create function fn_GroupAccountTotals (
	@ru_group as nvarchar(max),
	@acct_group as nvarchar(max),
	@ru_group_name as nvarchar(64),
	@acct_group_name as nvarchar(64)
)

returns @t table (

	Project nvarchar(64)
	, RU int
	, Year_budget int
	, Period int
	, PeriodDesc nvarchar(64)
	, Account_Group nvarchar(64)
	, Total float
)

as
begin

	declare @group table (
		account int
	)
	insert into @group 
		select data from Split(@acct_group, ',')
		
	declare @ru table (
		ru int
	)
	insert into @ru  
		select data from split(@ru_group, ',')
		
	--declare 
	insert into @t
	select 	
		@ru_group_name Project
		, a.RU
		, year_budget
		, period
		, PeriodDesc
		, @acct_group_name Account_Group
		, case when a.itemtype = 6
		     then SUM(amount) 
		     else SUM(-1*amount)
		  end total
	from [FINRPT].dbo.GL_Summary a
	join @group g
	  on g.account = a.account
	join @ru r
	  on r.ru = a.ru
	--where Account in (select data from Split(@acct_group, ','))
	--  and RU in (select data from Split(@ru_group, ','))
	  
	group by
		year_budget
		, period
		, PeriodDesc
		, a.RU
		, a.itemtype
	order by 
		a.RU, 
		year_budget desc,
		period,
		PeriodDesc 
	return
end 
