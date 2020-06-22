select 'Started ART In this Clinic (original Cohort)',
(case when startdate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from
(
select distinct(o.patient_id) , min(o.date_created) as 'startdate',o.concept_id , dr.dosage_form , pa.person_id from orders o
left join drug dr on o.concept_id = dr.concept_id
left join person_attribute pa on o.patient_id = pa.person_id
left join person p on pa.person_id = p.person_id
where dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738') and pa.person_attribute_type_id = 33 and
pa.value not in (SELECT concept_id FROM openmrs.concept_name where name = 'Transfer-in'  and concept_name_type = 'FULLY_SPECIFIED')
group by o.patient_id ) patients
union all 
select 'Transfer in', 
(case when startdate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from
(
select distinct(o.patient_id) , min(o.date_created) as 'startdate',o.concept_id , dr.dosage_form , pa.person_id from orders o
left join drug dr on o.concept_id = dr.concept_id
left join person_attribute pa on o.patient_id = pa.person_id
left join person p on pa.person_id = p.person_id
where dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738') and pa.person_attribute_type_id = 33 and
pa.value = (SELECT concept_id FROM openmrs.concept_name where name = 'Transfer-in'  and concept_name_type = 'FULLY_SPECIFIED')
group by o.patient_id ) patients 
union all
select 'Transfer out', 
(case when value_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select patient_id , obs.value_datetime
from orders o
left join drug dr on o.concept_id = dr.concept_id
left join concept_name cn on o.concept_id = cn.concept_id
left join obs obs on o.patient_id = obs.person_id
where  dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738')
and obs.concept_id = (select concept_id from concept_name where name = 'Transferred Out Date' and concept_name_type = 'FULLY_SPECIFIED'
and obs.status = 'FINAL') group by o.patient_id
)tTransferOut
union all
select 'Net Current Cohort', (@initial1 + @tranferIn1 - @transferOut1) as 'start' , (@initial2 + @tranferIn2 - @transferOut2) as '6mo' , (@initial3 + @tranferIn3 - @transferOut3) as '12mo'
,(@initial4 + @tranferIn4 - @transferOut4) as '24mo', (@initial5 + @tranferIn5 - @transferOut5) as '36mo', (@initial6 + @tranferIn6 - @transferOut6) as '48mo'
,(@initial7 + @tranferIn7 - @transferOut7) as '60mo'
from (
select
@initial1 := (case when startdate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@initial2 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@initial3 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@initial4 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@initial5 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@initial6 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@initial7 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from
(
select distinct(o.patient_id) , min(o.date_created) as 'startdate',o.concept_id , dr.dosage_form , pa.person_id from orders o
left join drug dr on o.concept_id = dr.concept_id
left join person_attribute pa on o.patient_id = pa.person_id
left join person p on pa.person_id = p.person_id
where dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738') and pa.person_attribute_type_id = 33 and
pa.value not in (SELECT concept_id FROM openmrs.concept_name where name = 'Transfer-in'  and concept_name_type = 'FULLY_SPECIFIED')
group by o.patient_id ) patients
union all
select 
@tranferIn1 :=  (case when startdate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@tranferIn2 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@tranferIn3 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@tranferIn4 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@tranferIn5 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@tranferIn6 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@tranferIn7 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from
(
select distinct(o.patient_id) , min(o.date_created) as 'startdate',o.concept_id , dr.dosage_form , pa.person_id from orders o
left join drug dr on o.concept_id = dr.concept_id
left join person_attribute pa on o.patient_id = pa.person_id
left join person p on pa.person_id = p.person_id
where dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738') and pa.person_attribute_type_id = 33 and
pa.value = (SELECT concept_id FROM openmrs.concept_name where name = 'Transfer-in'  and concept_name_type = 'FULLY_SPECIFIED')
group by o.patient_id ) patients 
union all
select 
@transferOut1 := (case when value_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@transferOut2 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@transferOut3 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@transferOut4 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@transferOut5 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@transferOut6 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@transferOut7 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select patient_id , obs.value_datetime
from orders o
left join drug dr on o.concept_id = dr.concept_id
left join concept_name cn on o.concept_id = cn.concept_id
left join obs obs on o.patient_id = obs.person_id
where  dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738')
and obs.concept_id = (select concept_id from concept_name where name = 'Transferred Out Date' and concept_name_type = 'FULLY_SPECIFIED'
and obs.status = 'FINAL') group by o.patient_id
)tTransferOut
) tNetCohort limit 1
union all 
select 'On Original 1st Line Regimen',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) = 1) pp
union all
select 'On Alternate 1st Line Regimen (Substituted)',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 1) tAltenateFirstLine
union all 
select 'On 2nd Line Regimen (Switched)',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 0) tSecondSubstitutedLine
union all
select 'Stopped',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'Interruption type' and concept_name_type = 'Fully_specified') 
and ob.value_coded = (select concept_id from concept_name where name = 'Stop' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 0) tRegimenStopped
union all 
select 'Died',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'Fully_specified') 
and ob.value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 0 ) tPatientDied
union all
select 'Lost  to Follow-up (DROP)',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'

from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'Fully_specified') 
and ob.value_coded = (select concept_id from concept_name where name = 'Lost Follow Up(< 28days)' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 0) tLostToFollowup
union all
select 'Alive and on ART (E+F+G)',sum(start) as 'start' , sum(6mo) as '6mo' , sum(12mo) as '12mo' , sum(24mo) as '24mo' , sum(36mo) as '36mo' , sum(48mo) as '48mo' , sum(60mo) as '60mo' from (
select 'On Original 1st Line Regimen',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) = 1) pp
union all
select 'On Alternate 1st Line Regimen (Substituted)',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 1) tAltenateFirstLine
union all 
select 'On 2nd Line Regimen (Switched)',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 0) tSecondSubstitutedLine
)tefg
union all
select 'Percent of cohort alive and on ART[K / D * 100 ]', CEIL(@perc1) as 'start', CEIL(@perc2) as '6mo' , CEIL(@perc3) as '12mo' ,CEIL(@perc4) as '24mo' , CEIL(@perc5) as '36mo', CEIL(@perc6) as '48mo', CEIL(@perc7) as '60mo' from (
select @perc1 := CEIL((@original1+@alternate1+@switched1) / (@initial1 + @tranferIn1 - @transferOut1) * 100) as 'start', @perc2 := CEIL((@original2+@alternate2+@switched2) / (@initial2 + @tranferIn2 - @transferOut2) * 100) as '6mo',@perc3 := CEIL((@original3+@alternate3+@switched3) / (@initial3 + @tranferIn3 - @transferOut3) * 100) as '12mo',
@perc4 := CEIL((@original4+@alternate4+@switched4)/(@initial4 + @tranferIn4 - @transferOut4) * 100) as '24mo',
@perc5 := CEIL((@original5+@alternate5+@switched5) / (@initial5 + @tranferIn5 - @transferOut5) * 100) as '36mo',@perc6 := CEIL((@original6+@alternate6+@switched6) / (@initial2 + @tranferIn2 - @transferOut2) * 100) as '48mo', @perc7 := CEIL((@original7+@alternate7+@switched7) /(@initial2 + @tranferIn2 - @transferOut2) * 100)as '60mo'from (
select 'On Original 1st Line Regimen',
@original1 := (case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@original2 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@original3 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@original4 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@original5 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@original6 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@original7 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) = 1) pp
union all
select 'On Alternate 1st Line Regimen (Substituted)',
@alternate1 := (case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@alternate1 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@alternate1 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@alternate1 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@alternate1 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@alternate1 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@alternate1 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 1) tAltenateFirstLine
union all 
select 'On 2nd Line Regimen (Switched)',
@switched1 := (case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@switched2 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@switched3 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@switched4 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@switched5 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@switched6 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@switched7 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) > 0) tSecondSubstitutedLine
)tefg limit 1
union all
select 
@initial1 := (case when startdate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@initial2 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@initial3 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@initial4 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@initial5 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@initial6 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@initial7 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from
(
select distinct(o.patient_id) , min(o.date_created) as 'startdate',o.concept_id , dr.dosage_form , pa.person_id from orders o
left join drug dr on o.concept_id = dr.concept_id
left join person_attribute pa on o.patient_id = pa.person_id
left join person p on pa.person_id = p.person_id
where dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738') and pa.person_attribute_type_id = 33 and
pa.value not in (SELECT concept_id FROM openmrs.concept_name where name = 'Transfer-in'  and concept_name_type = 'FULLY_SPECIFIED')
group by o.patient_id ) patients
union all
select
@tranferIn1 := (case when startdate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@tranferIn2 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@tranferIn3 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@tranferIn4 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@tranferIn5 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@tranferIn6 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@tranferIn7 := SUM(CASE WHEN startdate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from
(
select distinct(o.patient_id) , min(o.date_created) as 'startdate',o.concept_id , dr.dosage_form , pa.person_id from orders o
left join drug dr on o.concept_id = dr.concept_id
left join person_attribute pa on o.patient_id = pa.person_id
left join person p on pa.person_id = p.person_id
where dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738') and pa.person_attribute_type_id = 33 and
pa.value = (SELECT concept_id FROM openmrs.concept_name where name = 'Transfer-in'  and concept_name_type = 'FULLY_SPECIFIED')
group by o.patient_id ) patients 
union all
select 
@transferOut1 := (case when value_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@transferOut2 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@transferOut3 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@transferOut4 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@transferOut5 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@transferOut6 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@transferOut7 := SUM(CASE WHEN value_datetime between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select patient_id , obs.value_datetime
from orders o
left join drug dr on o.concept_id = dr.concept_id
left join concept_name cn on o.concept_id = cn.concept_id
left join obs obs on o.patient_id = obs.person_id
where  dr.dosage_form = (select concept_id from concept_name where uuid = '95955de4-7440-4482-88f6-e5daefc2d738')
and obs.concept_id = (select concept_id from concept_name where name = 'Transferred Out Date' and concept_name_type = 'FULLY_SPECIFIED'
and obs.status = 'FINAL') group by o.patient_id
)tTransferOutlimit limit 1
) hh
union all
select 'Fraction CD4 <200 (of adults with available CD4 at baseline)', CEIL(@baselineStart / @baseStart ) as 'start', CEIL(@baseline6 / @base6) as '6mo', CEIL(@baseline12 / @base12 ) as '12mo', CEIL(@baseline24 / @base24 ) as '24mo', CEIL(@baseline36 / @base36 ) as '36mo', 
CEIL(@baseline48 / @base48 ) as '48mo', CEIL(@baseline60 / @base60 ) as '60mo'  from (
select 'Fraction CD4 <200 (of adults with available CD4 at baseline)',
@baselineStart := (case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@baseline6 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@baseline12 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@baseline24 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@baseline36 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@baseline48 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@baseline60 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
left join person pa on ob.person_id = pa.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'CD4' and concept_name_type = 'Fully_specified') 
and ob.value_numeric < 200 and TIMESTAMPDIFF(YEAR,pa.birthdate,NOW()) >= 18
group by o.patient_id having count(o.patient_id) > 0) tb2
union all
select 'Fraction CD4 <200 (of adults with available CD4 at baseline)',
@baseStart := (case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
@base6 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
@base12 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
@base24 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
@base36 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
@base48 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
@base60 := SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
left join person pa on ob.person_id = pa.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'CD4' and concept_name_type = 'Fully_specified') 
and ob.value_numeric > 0 and TIMESTAMPDIFF(YEAR,pa.birthdate,NOW()) >= 18
group by o.patient_id having count(o.patient_id) > 0) tb1
)tcd4lessthan200 LIMIT 1
union all
select 'Done Viral Load (VL)',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
 from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'Fully_specified')
and ob.value_numeric > 0
group by o.patient_id having count(o.patient_id) > 0) tDoneViralload
union all
select 'Viral Load < 1000 copies /ml',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'

from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'Fully_specified')
and ob.value_numeric < 1000
group by o.patient_id having count(o.patient_id) > 0) tVllessthanthousand
union all
select 'Presumptive TB (Pr TB)',
(case when mindate between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then count(distinct(patient_id)) else 0 end) as 'start',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 6 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 6 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '6mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 12 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 12 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '12mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 24 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 24 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '24mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 36 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 36 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '36mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 48 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 48 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '48mo',
SUM(CASE WHEN mindate between DATE_FORMAT('#startDate#' - INTERVAL 60 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 60 MONTH),'%Y-%m-%d 23:59:59')) then 1 else 0 end) as '60mo'
from (
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
left join obs ob on o.patient_id = ob.person_id
where cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' 
and concept_name_type = 'Fully_specified')
and ob.concept_id = (select concept_id from concept_name where name = 'On TB Treatment' and concept_name_type = 'Fully_specified')
and ob.value_coded = (select concept_id from concept_name where name = 'True' and concept_name_type = 
'fully_specified')
group by o.patient_id having count(o.patient_id) > 0) tPresumptiveTb
