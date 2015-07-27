select * from fn_waiverfinancialsummary('3301,3302,3303', 'c/w/c')
union
select * from fn_waiverfinancialsummary('3101,3102,3103,3104,3105', 'Integrated Health')
union
select * from fn_waiverfinancialsummary('3401', 'PEER')
union
select * from fn_waiverfinancialsummary('3405', 'SLECT')
union
select * from fn_waiverfinancialsummary('3408', 'Safe Harbor')
union
select * from fn_waiverfinancialsummary('3409', 'Transitions')
union
select * from fn_waiverfinancialsummary('3410', 'Smoking Cessation')
union
select * from fn_waiverfinancialsummary('3600', 'Wellness & Recovery')
union
select * from fn_waiverfinancialsummary('3801,3802,3803', 'PEER')
union
select * from fn_waiverfinancialsummary('3901', 'Crisis Respite')
union
select * from fn_waiverfinancialsummary('3902', 'Ambulatory Detox')
union
select * from fn_waiverfinancialsummary('3903', 'IDD Crisis Respite')