--select * from fn_AnsaDomainTotals('10/1/2013', '4/1/2015')
if OBJECT_ID('dbo.fn_AnsaDomainTotals') is not null
	drop function dbo.fn_AnsaDomainTotals

go
create function fn_AnsaDomainTotals(
	@start datetime,
	@end datetime
)

returns @t table (
	ClientId nvarchar(10),
	Asmt_Date datetime,
	Asmt_Type nvarchar(2),
	loc_r nvarchar(3),
	loc_a nvarchar(3),
	Risk int,
	Behavior int,
	LifeDomain int,
	Family int,
	Strength int,
	Culture int,
	Hospitalization int,
	Total_no_Hosp int,
	Total_w_Hosp int
)
as
begin
insert into @t
select ClientID
	, C_ANSA_DATE as asmt_date
	, c_ansa_type as asmt_type
	, C_ANSA_RLOC as loc_r
	, C_ANSA_ALOC as loc_a
	, coalesce(cast(C_ANSA_R_Suicid as int), 0) 
		+ coalesce(cast(C_ANSA_R_DANGOT as int), 0) 
		+ coalesce(cast(C_ANSA_R_SMUTIL as int), 0) 
		+ coalesce(cast(C_ANSA_R_OSLFHR as int), 0) 
		+ coalesce(cast(C_ANSA_R_EXPLOIT as int), 0) 
		+ coalesce(cast(C_ANSA_R_GAMBLE as int), 0) 
		+ coalesce(cast(C_ANSA_R_SEXAGR as int), 0) 
		+ coalesce(cast(C_ANSA_R_CRIMBE as int), 0) 
		--+ coalesce(cast(C_ANSA_R_ as int), 0) 
		as Risk
	, coalesce(cast(C_ANSA_B_PSYCHS as int), 0)
		+ coalesce(cast(C_ANSA_B_COG as int), 0)
		+ coalesce(cast(C_ANSA_B_DEPRES as int), 0)
		+ coalesce(cast(C_ANSA_B_ANXITY as int), 0)
		+ coalesce(cast(C_ANSA_B_MANIA as int), 0)
		+ coalesce(cast(C_ANSA_B_IMPLSV as int), 0)
		+ coalesce(cast(C_ANSA_B_INTER as int), 0)
		+ coalesce(cast(C_ANSA_B_ANTISOC as int), 0)
		+ coalesce(cast(C_ANSA_B_ADJTRM as int), 0)
		+ coalesce(cast(C_ANSA_B_angctr as int), 0)
		+ coalesce(cast(C_ANSA_B_SUBABS as int), 0)
		+ coalesce(cast(C_ANSA_B_EATDST as int), 0)
		as Behavior
	, coalesce(cast(C_ANSA_LD_PHYMED as int), 0)
		+ coalesce(cast(C_ANSA_LD_FAMILY as int), 0)
		+ coalesce(cast(C_ANSA_LD_EMPLOY as int), 0)
		+ coalesce(cast(C_ANSA_LD_SOCFUN as int), 0)
		+ coalesce(cast(C_ANSA_LD_RECRET as int), 0)
		+ coalesce(cast(C_ANSA_LD_INDLIV as int), 0)
		+ coalesce(cast(C_ANSA_LD_SEXDEV as int), 0)
		+ coalesce(cast(C_ANSA_LD_LIVING as int), 0)
		+ coalesce(cast(C_ANSA_LD_RESTAB as int), 0)
		+ coalesce(cast(C_ANSA_LD_LEGAL as int), 0)
		+ coalesce(cast(C_ANSA_LD_SLEEP as int), 0)
		+ coalesce(cast(C_ANSA_LD_SLFCRE as int), 0)
		+ coalesce(cast(C_ANSA_LD_DECISI as int), 0)
		+ coalesce(cast(C_ANSA_LD_INVREC as int), 0)
		+ coalesce(cast(C_ANSA_LD_TRANS as int), 0)
		as LifeDomain
	, case C_ANSA_FC_NA
		when '9' then Null
		else coalesce(cast(C_ANSA_FC_PHLTH as int), 0)
			+ coalesce(cast(C_ANSA_FC_INVCRE as int), 0)
			+ coalesce(cast(C_ANSA_FC_KNOW as int), 0)
			+ coalesce(cast(C_ANSA_FC_SFRES as int), 0)
			+ coalesce(cast(C_ANSA_FC_FAMST as int), 0)
			+ coalesce(cast(C_ANSA_FC_SAFE as int), 0)
		end
		as Family
	, coalesce(cast(C_ANSA_ST_FAM as int), 0)
		+ coalesce(cast(C_ANSA_ST_SOCCON as int), 0)
		+ coalesce(cast(C_ANSA_ST_opti as int), 0)
		+ coalesce(cast(C_ANSA_ST_TAL as int), 0)
		+ coalesce(cast(C_ANSA_ST_EDU as int), 0)
		+ coalesce(cast(C_ANSA_ST_VOL as int), 0)
		+ coalesce(cast(C_ANSA_ST_JOBHI as int), 0)
		+ coalesce(cast(C_ANSA_ST_RELIG as int), 0)
		+ coalesce(cast(C_ANSA_ST_COMCON as int), 0)
		+ coalesce(cast(C_ANSA_ST_NATSUP as int), 0)
		+ coalesce(cast(C_ANSA_ST_RESIL as int), 0)
		+ coalesce(cast(C_ANSA_ST_RESOUR as int), 0)
		as Strength
	, coalesce(cast(C_ANSA_AC_LANGUA as int), 0)
		+ coalesce(cast(C_ANSA_AC_IDENTY as int), 0)
		+ coalesce(cast(C_ANSA_ac_ritual as int), 0)
		+ coalesce(cast(c_ansa_ac_culstr as int), 0)
		as Culture
	, coalesce(cast(C_ANSA_HS_num180 as int), 0)
		+ coalesce(cast(c_ansa_hs_numL30 as int), 0)
		+ coalesce(cast(c_ansa_hs_numg30 as int), 0)
		+ coalesce(cast(c_ansa_cr_episds as int), 0)
		as Hospitalization

	, coalesce(cast(C_ANSA_R_Suicid as int), 0) 
		+ coalesce(cast(C_ANSA_R_DANGOT as int), 0) 
		+ coalesce(cast(C_ANSA_R_SMUTIL as int), 0) 
		+ coalesce(cast(C_ANSA_R_OSLFHR as int), 0) 
		+ coalesce(cast(C_ANSA_R_EXPLOIT as int), 0) 
		+ coalesce(cast(C_ANSA_R_GAMBLE as int), 0) 
		+ coalesce(cast(C_ANSA_R_SEXAGR as int), 0) 
		+ coalesce(cast(C_ANSA_R_CRIMBE as int), 0) 
		+ coalesce(cast(C_ANSA_B_PSYCHS as int), 0)
		+ coalesce(cast(C_ANSA_B_COG as int), 0)
		+ coalesce(cast(C_ANSA_B_DEPRES as int), 0)
		+ coalesce(cast(C_ANSA_B_ANXITY as int), 0)
		+ coalesce(cast(C_ANSA_B_MANIA as int), 0)
		+ coalesce(cast(C_ANSA_B_IMPLSV as int), 0)
		+ coalesce(cast(C_ANSA_B_INTER as int), 0)
		+ coalesce(cast(C_ANSA_B_ANTISOC as int), 0)
		+ coalesce(cast(C_ANSA_B_ADJTRM as int), 0)
		+ coalesce(cast(C_ANSA_B_angctr as int), 0)
		+ coalesce(cast(C_ANSA_B_SUBABS as int), 0)
		+ coalesce(cast(C_ANSA_B_EATDST as int), 0)
		+ coalesce(cast(C_ANSA_LD_PHYMED as int), 0)
		+ coalesce(cast(C_ANSA_LD_FAMILY as int), 0)
		+ coalesce(cast(C_ANSA_LD_EMPLOY as int), 0)
		+ coalesce(cast(C_ANSA_LD_SOCFUN as int), 0)
		+ coalesce(cast(C_ANSA_LD_RECRET as int), 0)
		+ coalesce(cast(C_ANSA_LD_INDLIV as int), 0)
		+ coalesce(cast(C_ANSA_LD_SEXDEV as int), 0)
		+ coalesce(cast(C_ANSA_LD_LIVING as int), 0)
		+ coalesce(cast(C_ANSA_LD_RESTAB as int), 0)
		+ coalesce(cast(C_ANSA_LD_LEGAL as int), 0)
		+ coalesce(cast(C_ANSA_LD_SLEEP as int), 0)
		+ coalesce(cast(C_ANSA_LD_SLFCRE as int), 0)
		+ coalesce(cast(C_ANSA_LD_DECISI as int), 0)
		+ coalesce(cast(C_ANSA_LD_INVREC as int), 0)
		+ coalesce(cast(C_ANSA_LD_TRANS as int), 0)
		+ case C_ANSA_FC_NA
			when '9' then 0
			else coalesce(cast(C_ANSA_FC_PHLTH as int), 0)
				+ coalesce(cast(C_ANSA_FC_INVCRE as int), 0)
				+ coalesce(cast(C_ANSA_FC_KNOW as int), 0)
				+ coalesce(cast(C_ANSA_FC_SFRES as int), 0)
				+ coalesce(cast(C_ANSA_FC_FAMST as int), 0)
				+ coalesce(cast(C_ANSA_FC_SAFE as int), 0)
			end
		+ coalesce(cast(C_ANSA_ST_FAM as int), 0)
		+ coalesce(cast(C_ANSA_ST_SOCCON as int), 0)
		+ coalesce(cast(C_ANSA_ST_opti as int), 0)
		+ coalesce(cast(C_ANSA_ST_TAL as int), 0)
		+ coalesce(cast(C_ANSA_ST_EDU as int), 0)
		+ coalesce(cast(C_ANSA_ST_VOL as int), 0)
		+ coalesce(cast(C_ANSA_ST_JOBHI as int), 0)
		+ coalesce(cast(C_ANSA_ST_RELIG as int), 0)
		+ coalesce(cast(C_ANSA_ST_COMCON as int), 0)
		+ coalesce(cast(C_ANSA_ST_NATSUP as int), 0)
		+ coalesce(cast(C_ANSA_ST_RESIL as int), 0)
		+ coalesce(cast(C_ANSA_ST_RESOUR as int), 0)
		+coalesce(cast(C_ANSA_AC_LANGUA as int), 0)
		+ coalesce(cast(C_ANSA_AC_IDENTY as int), 0)
		+ coalesce(cast(C_ANSA_ac_ritual as int), 0)
		+ coalesce(cast(c_ansa_ac_culstr as int), 0)
		as Total_no_hosp
				
	, coalesce(cast(C_ANSA_R_Suicid as int), 0) 
		+ coalesce(cast(C_ANSA_R_DANGOT as int), 0) 
		+ coalesce(cast(C_ANSA_R_SMUTIL as int), 0) 
		+ coalesce(cast(C_ANSA_R_OSLFHR as int), 0) 
		+ coalesce(cast(C_ANSA_R_EXPLOIT as int), 0) 
		+ coalesce(cast(C_ANSA_R_GAMBLE as int), 0) 
		+ coalesce(cast(C_ANSA_R_SEXAGR as int), 0) 
		+ coalesce(cast(C_ANSA_R_CRIMBE as int), 0) 
		+ coalesce(cast(C_ANSA_B_PSYCHS as int), 0)
		+ coalesce(cast(C_ANSA_B_COG as int), 0)
		+ coalesce(cast(C_ANSA_B_DEPRES as int), 0)
		+ coalesce(cast(C_ANSA_B_ANXITY as int), 0)
		+ coalesce(cast(C_ANSA_B_MANIA as int), 0)
		+ coalesce(cast(C_ANSA_B_IMPLSV as int), 0)
		+ coalesce(cast(C_ANSA_B_INTER as int), 0)
		+ coalesce(cast(C_ANSA_B_ANTISOC as int), 0)
		+ coalesce(cast(C_ANSA_B_ADJTRM as int), 0)
		+ coalesce(cast(C_ANSA_B_angctr as int), 0)
		+ coalesce(cast(C_ANSA_B_SUBABS as int), 0)
		+ coalesce(cast(C_ANSA_B_EATDST as int), 0)
		+ coalesce(cast(C_ANSA_LD_PHYMED as int), 0)
		+ coalesce(cast(C_ANSA_LD_FAMILY as int), 0)
		+ coalesce(cast(C_ANSA_LD_EMPLOY as int), 0)
		+ coalesce(cast(C_ANSA_LD_SOCFUN as int), 0)
		+ coalesce(cast(C_ANSA_LD_RECRET as int), 0)
		+ coalesce(cast(C_ANSA_LD_INDLIV as int), 0)
		+ coalesce(cast(C_ANSA_LD_SEXDEV as int), 0)
		+ coalesce(cast(C_ANSA_LD_LIVING as int), 0)
		+ coalesce(cast(C_ANSA_LD_RESTAB as int), 0)
		+ coalesce(cast(C_ANSA_LD_LEGAL as int), 0)
		+ coalesce(cast(C_ANSA_LD_SLEEP as int), 0)
		+ coalesce(cast(C_ANSA_LD_SLFCRE as int), 0)
		+ coalesce(cast(C_ANSA_LD_DECISI as int), 0)
		+ coalesce(cast(C_ANSA_LD_INVREC as int), 0)
		+ coalesce(cast(C_ANSA_LD_TRANS as int), 0)
		+ case C_ANSA_FC_NA
			when '9' then 0
			else coalesce(cast(C_ANSA_FC_PHLTH as int), 0)
				+ coalesce(cast(C_ANSA_FC_INVCRE as int), 0)
				+ coalesce(cast(C_ANSA_FC_KNOW as int), 0)
				+ coalesce(cast(C_ANSA_FC_SFRES as int), 0)
				+ coalesce(cast(C_ANSA_FC_FAMST as int), 0)
				+ coalesce(cast(C_ANSA_FC_SAFE as int), 0)
			end
		+ coalesce(cast(C_ANSA_ST_FAM as int), 0)
		+ coalesce(cast(C_ANSA_ST_SOCCON as int), 0)
		+ coalesce(cast(C_ANSA_ST_opti as int), 0)
		+ coalesce(cast(C_ANSA_ST_TAL as int), 0)
		+ coalesce(cast(C_ANSA_ST_EDU as int), 0)
		+ coalesce(cast(C_ANSA_ST_VOL as int), 0)
		+ coalesce(cast(C_ANSA_ST_JOBHI as int), 0)
		+ coalesce(cast(C_ANSA_ST_RELIG as int), 0)
		+ coalesce(cast(C_ANSA_ST_COMCON as int), 0)
		+ coalesce(cast(C_ANSA_ST_NATSUP as int), 0)
		+ coalesce(cast(C_ANSA_ST_RESIL as int), 0)
		+ coalesce(cast(C_ANSA_ST_RESOUR as int), 0)
		+ coalesce(cast(C_ANSA_AC_LANGUA as int), 0)
		+ coalesce(cast(C_ANSA_AC_IDENTY as int), 0)
		+ coalesce(cast(C_ANSA_ac_ritual as int), 0)
		+ coalesce(cast(c_ansa_ac_culstr as int), 0)
		+ coalesce(cast(C_ANSA_HS_num180 as int), 0)
		+ coalesce(cast(c_ansa_hs_numL30 as int), 0)
		+ coalesce(cast(c_ansa_hs_numg30 as int), 0)
		+ coalesce(cast(c_ansa_cr_episds as int), 0)
		as Total_w_hosp
	from ansa
	where ansa.C_ANSA_TYPE != 3
	return
end
