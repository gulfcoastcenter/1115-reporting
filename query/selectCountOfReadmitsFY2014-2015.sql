select count(b.c_bd_admitdt)
from fn_IndexHospAdmitDateInRange(2, '10/1/2013', '12/31/2013') as idx
join client.client_record as c
  on c.clientid = idx.cid
left join mis_c_bd_rec as b
  on b.c_id = idx.cid
 and b.c_bd_hospid = idx.hospid
 and b.c_bd_admitdt between idx.index_disch_dt and dateadd(day, 30, idx.index_disch_dt)
where idx.hospid = 'RHSPA1'
and b.c_bd_admitdt is not null
and DATEDIFF(DAY, c.DOB, b.c_bd_admitdt) > 17

select count(b.c_bd_admitdt)
from fn_IndexHospAdmitDateInRange(2, '1/1/2014', '3/31/2014') as idx
join client.client_record as c
  on c.clientid = idx.cid
left join mis_c_bd_rec as b
  on b.c_id = idx.cid
 and b.c_bd_hospid = idx.hospid
 and b.c_bd_admitdt between idx.index_disch_dt and dateadd(day, 30, idx.index_disch_dt)
where idx.hospid = 'RHSPA1'
and b.c_bd_admitdt is not null
and DATEDIFF(DAY, c.DOB, b.c_bd_admitdt) > 17

select count(b.c_bd_admitdt)
from fn_IndexHospAdmitDateInRange(2, '4/1/2014', '6/30/2014') as idx
join client.client_record as c
  on c.clientid = idx.cid
left join mis_c_bd_rec as b
  on b.c_id = idx.cid
 and b.c_bd_hospid = idx.hospid
 and b.c_bd_admitdt between idx.index_disch_dt and dateadd(day, 30, idx.index_disch_dt)
where idx.hospid = 'RHSPA1'
and b.c_bd_admitdt is not null
and DATEDIFF(DAY, c.DOB, b.c_bd_admitdt) > 17

select count(b.c_bd_admitdt)
from fn_IndexHospAdmitDateInRange(2, '7/1/2014', '9/30/2014') as idx
join client.client_record as c
  on c.clientid = idx.cid
left join mis_c_bd_rec as b
  on b.c_id = idx.cid
 and b.c_bd_hospid = idx.hospid
 and b.c_bd_admitdt between idx.index_disch_dt and dateadd(day, 30, idx.index_disch_dt)
where idx.hospid = 'RHSPA1'
and b.c_bd_admitdt is not null
and DATEDIFF(DAY, c.DOB, b.c_bd_admitdt) > 17

select count(b.c_bd_admitdt)
from fn_IndexHospAdmitDateInRange(2, '10/1/2014', '12/31/2014') as idx
join client.client_record as c
  on c.clientid = idx.cid
left join mis_c_bd_rec as b
  on b.c_id = idx.cid
 and b.c_bd_hospid = idx.hospid
 and b.c_bd_admitdt between idx.index_disch_dt and dateadd(day, 30, idx.index_disch_dt)
where idx.hospid = 'RHSPA1'
and b.c_bd_admitdt is not null
and DATEDIFF(DAY, c.DOB, b.c_bd_admitdt) > 17

select count(b.c_bd_admitdt)
from fn_IndexHospAdmitDateInRange(2, '1/1/2015', '3/31/2015') as idx
join client.client_record as c
  on c.clientid = idx.cid
left join mis_c_bd_rec as b
  on b.c_id = idx.cid
 and b.c_bd_hospid = idx.hospid
 and b.c_bd_admitdt between idx.index_disch_dt and dateadd(day, 30, idx.index_disch_dt)
where idx.hospid = 'RHSPA1'
and b.c_bd_admitdt is not null
and DATEDIFF(DAY, c.DOB, b.c_bd_admitdt) > 17
