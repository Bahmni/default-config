select 'Total' as 'Adult 1st Line Regimens',
count(distinct(case when patient_id is not null and name = '1a = AZT/3TC+EFV' then patient_id end)) as '1a = AZT/3TC+EFV',
count(distinct(case when patient_id is not null and name = '1b = AZT/3TC/NVP' then patient_id end)) as '1b = AZT/3TC/NVP',
count(distinct(case when patient_id is not null and name = '1f = TDF/3TC+EFV' then patient_id end)) as '1f = TDF/3TC+EFV',
count(distinct(case when patient_id is not null and name = '1g = TDF/3TC+NVP' then patient_id end)) as '1g = TDF/3TC+NVP',
count(distinct(case when patient_id is not null and name = '1h = TDF/FTC/EFV' then patient_id end)) as '1h = TDF/FTC/EFV',
count(distinct(case when patient_id is not null and name = '1j = TDF/3TC+NVP' then patient_id end)) as '1J = TDF+FTC+NVP ',
null as 'N/A',null as 'N/A'
 from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate 
union all 
select null, null , null ,null ,null ,null, null,null,null
union all
select 'Adult 2nd Line Regimens', '2c=TDF+3TC+LPV/r' , '2d=TDF/3TC+ATV/r' ,'2e=TDF/FTC-LPV/r' ,'2f=TDF/FTC-ATV/r' ,'2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r'
union all
select 'Total' as 'Adult 2nd Line Regimens',
count(distinct(case when patient_id is not null and name = '2c=TDF+3TC+LPV/r' then patient_id end)) as '2c=TDF+3TC+LPV/r',
count(distinct(case when patient_id is not null and name = '2d=TDF/3TC+ATV/r' then patient_id end)) as '2d=TDF/3TC+ATV/r',
count(distinct(case when patient_id is not null and name = '2e=TDF/FTC-LPV/r' then patient_id end)) as '2e=TDF/FTC-LPV/r',
count(distinct(case when patient_id is not null and name = '2f=TDF/FTC-ATV/r' then patient_id end)) as '2f=TDF/FTC-ATV/r',
count(distinct(case when patient_id is not null and name = '2g=AZT/3TC+LPV/r' then patient_id end)) as '2g=AZT/3TC+LPV/r',
count(distinct(case when patient_id is not null and name = '2h=AZT/3TC+ATV/r' then patient_id end)) as '2h=AZT/3TC+ATV/r',
count(distinct(case when patient_id is not null and name = '2i=ABC/3TC+LPV/r' then patient_id end)) as '2i=ABC/3TC+LPV/r',
count(distinct(case when patient_id is not null and name = '2j=ABC/3TC+ATV/r'then patient_id end)) as '2j=ABC/3TC+ATV/r'
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate 
union all
select null, null , null ,null ,null ,null, null,null,null
union all
select 'Child 1st Line Regimens', '4a = AZT/3TC+NVP' , '4b = AZT/3TC +EFV' ,'4f = ABC/3TC +NVP' ,'4g = TDF/3TC (120/60) + EFV (200mg)' ,'4h = TDF/FTC/EFV', '4i = ABC/3TC +LPV/r',null,null
union all
select 'Total' as 'Adult 1st Line Regimens',
count(distinct(case when patient_id is not null and name = '4a = AZT/3TC+NVP' then patient_id end)) as '4a = AZT/3TC+NVP',
count(distinct(case when patient_id is not null and name = '4b = AZT/3TC +EFV' then patient_id end)) as '4b = AZT/3TC +EFV',
count(distinct(case when patient_id is not null and name = '4f = ABC/3TC +NVP' then patient_id end)) as '4f = ABC/3TC +NVP',
count(distinct(case when patient_id is not null and name = '4g = TDF/3TC (120/60) + EFV (200mg)' then patient_id end)) as '4g = TDF/3TC (120/60) + EFV (200mg)',
count(distinct(case when patient_id is not null and name = '4h = TDF/FTC/EFV' then patient_id end)) as '4h = TDF/FTC/EFV',
count(distinct(case when patient_id is not null and name = '4i = ABC/3TC +LPV/r' then patient_id end)) as '4i = ABC/3TC +LPV/r',
null,null
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name in ('4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate
union all
select null, null , null ,null ,null ,null, null,null,null
union all
select 'Child 2nd Line Regimens', '5b = AZT/3TC +RAL' , '5c = ABC/3TC (120/60) + RAL' ,'5d = AZT/3TC +ATV/r' ,'5e = ABC/3TC + ATV/r' ,'5f = TDF/3TC + ATV/r',null,null,null
union all
select 'Total' as 'Child 2nd Line Regimens',
count(distinct(case when patient_id is not null and name = '5b = AZT/3TC +RAL' then patient_id end)) as '5b = AZT/3TC +RAL',
count(distinct(case when patient_id is not null and name = '5c = ABC/3TC (120/60) + RAL' then patient_id end)) as '5c = ABC/3TC (120/60) + RAL',
count(distinct(case when patient_id is not null and name = '5d = AZT/3TC +ATV/r' then patient_id end)) as '5d = AZT/3TC +ATV/r',
count(distinct(case when patient_id is not null and name = '5e = ABC/3TC + ATV/r' then patient_id end)) as '5e = ABC/3TC + ATV/r',
count(distinct(case when patient_id is not null and name = '5f = TDF/3TC + ATV/r' then patient_id end)) as '5f = TDF/3TC + ATV/r',
null,null,null
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name in ('5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL','5c = ABC/3TC (120/60) + RAL' , '5d = AZT/3TC +ATV/r' , '5e = ABC/3TC + ATV/r' , '5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*' , '5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate 


