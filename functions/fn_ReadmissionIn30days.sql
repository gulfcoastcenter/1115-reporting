if OBJECT_ID('fn_ReadmissionIn30days') is not null
	drop function fn_ReadmissionIn30days

go
create function fn_ReadmissionIn30days(
	@clientid varchar(10),
	@discharge datetime
) 
returns int
as 
	begin
		declare @output as int
		select @output = count(bd.c_bd_admitdt)
			from mis_c_bd_rec bd
			where bd.c_id = @clientid
			  and bd.c_bd_admitdt between dateadd(DD, 0, @discharge) and dateadd(DD, 30, @discharge)
			
		--select @output
		--if @output > 0 
		--	set @output = 1
		
		return @output
	end