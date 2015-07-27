--select * from fn_AnsaDomainTotals('10/1/2013', '4/1/2015')
if OBJECT_ID('dbo.fn_AnsaDomainScores') is not null
	drop function dbo.fn_AnsaDomainScores

go
create function dbo.fn_AnsaDomainScores(
	@start datetime,
	@end datetime
)

returns @t table (
	ClientId nvarchar(10),
	Asmt_Date datetime,
	Asmt_Type nvarchar(2),
	loc_r nvarchar(3),
	loc_a nvarchar(3),
	Risk float,
	Behavior float,
	LifeDomain float,
	Family float,
	Strength float,
	Culture float
)
as
begin
insert into @t
select ClientID
	, C_ANSA_DATE as asmt_date
	, c_ansa_type as asmt_type
	, C_ANSA_RLOC as loc_r
	, C_ANSA_ALOC as loc_a
	, Str(((coalesce(cast(C_ANSA_R_Suicid as float), 0) 
		+ coalesce(cast(C_ANSA_R_DANGOT as float), 0) 
		+ coalesce(cast(C_ANSA_R_SMUTIL as float), 0) 
		+ coalesce(cast(C_ANSA_R_OSLFHR as float), 0) 
		+ coalesce(cast(C_ANSA_R_EXPLOIT as float), 0) 
		+ coalesce(cast(C_ANSA_R_GAMBLE as float), 0) 
		+ coalesce(cast(C_ANSA_R_SEXAGR as float), 0) 
		+ coalesce(cast(C_ANSA_R_CRIMBE as float), 0)) / 8) * 10, 3, 0)
		--+ coalesce(cast(C_ANSA_R_ as float), 0) 
		as Risk
	, Str(((coalesce(cast(C_ANSA_B_PSYCHS as float), 0)
		+ coalesce(cast(C_ANSA_B_COG as float), 0)
		+ coalesce(cast(C_ANSA_B_DEPRES as float), 0)
		+ coalesce(cast(C_ANSA_B_ANXITY as float), 0)
		+ coalesce(cast(C_ANSA_B_MANIA as float), 0)
		+ coalesce(cast(C_ANSA_B_IMPLSV as float), 0)
		+ coalesce(cast(C_ANSA_B_INTER as float), 0)
		+ coalesce(cast(C_ANSA_B_ANTISOC as float), 0)
		+ coalesce(cast(C_ANSA_B_ADJTRM as float), 0)
		+ coalesce(cast(C_ANSA_B_angctr as float), 0)
		+ coalesce(cast(C_ANSA_B_SUBABS as float), 0)
		+ coalesce(cast(C_ANSA_B_EATDST as float), 0)) /12 ) * 10, 3, 0)
		as Behavior
	, Str(((coalesce(cast(C_ANSA_LD_PHYMED as float), 0)
		+ coalesce(cast(C_ANSA_LD_FAMILY as float), 0)
		+ coalesce(cast(C_ANSA_LD_EMPLOY as float), 0)
		+ coalesce(cast(C_ANSA_LD_SOCFUN as float), 0)
		+ coalesce(cast(C_ANSA_LD_RECRET as float), 0)
		+ coalesce(cast(C_ANSA_LD_INDLIV as float), 0)
		+ coalesce(cast(C_ANSA_LD_SEXDEV as float), 0)
		+ coalesce(cast(C_ANSA_LD_LIVING as float), 0)
		+ coalesce(cast(C_ANSA_LD_RESTAB as float), 0)
		+ coalesce(cast(C_ANSA_LD_LEGAL as float), 0)
		+ coalesce(cast(C_ANSA_LD_SLEEP as float), 0)
		+ coalesce(cast(C_ANSA_LD_SLFCRE as float), 0)
		+ coalesce(cast(C_ANSA_LD_DECISI as float), 0)
		+ coalesce(cast(C_ANSA_LD_INVREC as float), 0)
		+ coalesce(cast(C_ANSA_LD_TRANS as float), 0)) / 15 ) * 10, 3, 0)
		as LifeDomain
	, case C_ANSA_FC_NA
		when '9' then Null
		else Str(((coalesce(cast(C_ANSA_FC_PHLTH as float), 0)
			+ coalesce(cast(C_ANSA_FC_INVCRE as float), 0)
			+ coalesce(cast(C_ANSA_FC_KNOW as float), 0)
			+ coalesce(cast(C_ANSA_FC_SFRES as float), 0)
			+ coalesce(cast(C_ANSA_FC_FAMST as float), 0)
			+ coalesce(cast(C_ANSA_FC_SAFE as float), 0)) / 6 ) * 10, 3, 0)
		end
		as Family
	, Str(((coalesce(cast(C_ANSA_ST_FAM as float), 0)
		+ coalesce(cast(C_ANSA_ST_SOCCON as float), 0)
		+ coalesce(cast(C_ANSA_ST_opti as float), 0)
		+ coalesce(cast(C_ANSA_ST_TAL as float), 0)
		+ coalesce(cast(C_ANSA_ST_EDU as float), 0)
		+ coalesce(cast(C_ANSA_ST_VOL as float), 0)
		+ coalesce(cast(C_ANSA_ST_JOBHI as float), 0)
		+ coalesce(cast(C_ANSA_ST_RELIG as float), 0)
		+ coalesce(cast(C_ANSA_ST_COMCON as float), 0)
		+ coalesce(cast(C_ANSA_ST_NATSUP as float), 0)
		+ coalesce(cast(C_ANSA_ST_RESIL as float), 0)
		+ coalesce(cast(C_ANSA_ST_RESOUR as float), 0)) / 12 ) * 10, 3, 0)
		as Strength
	, Str(((coalesce(cast(C_ANSA_AC_LANGUA as float), 0)
		+ coalesce(cast(C_ANSA_AC_IDENTY as float), 0)
		+ coalesce(cast(C_ANSA_ac_ritual as float), 0)
		+ coalesce(cast(c_ansa_ac_culstr as float), 0)) / 4 ) * 10, 3, 0)
		as Culture

	from ansa
	where ansa.C_ANSA_TYPE != 3
	return
end
