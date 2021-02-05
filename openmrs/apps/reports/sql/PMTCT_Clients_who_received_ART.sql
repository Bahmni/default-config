-- Number of PMTCT Clients who received ART during  this reporting period by Regimen (Current on OptionB+)

SELECT
  'Adult 1st Line Regimens:' as 'Regimen',
  'M' as '<10 Male',
  'F' as '<10 Female',
  'M' as'10-15 Male' ,
  'F' as'10-15 Female',
  'M' as '15-49 Male',
  'F' as '15-49 Female',
  'M' as '50+ Male',
  'F' as '50+ Female',
  '' as 'Total',
  '' as'BreastFeeding',
  '' as 'Pregnant'
  From DUAL

UNION All
select 
'1a = AZT/3TC+ EFV' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1a = AZT/3TC+EFV') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id






UNION ALL
select 
'1b = AZT/3TC/NVP' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1b = AZT/3TC/NVP') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id




UNION ALL

select 
'1c = TDF/3TC/DTG' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1c = TDF/3TC/DTG') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id


UNION ALL

select 
'1d=ABC/3TC (600/300)/DTG' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1d=ABC/3TC (600/300)/DTG') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id


UNION ALL

select 
'1e = AZT/3TC +DTG' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1e = AZT/3TC +DTG') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

select 
'1f = TDF/3TC+EFV' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1f = TDF/3TC+EFV') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL
select 
'1g = TDF/3TC+NVP' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1g = TDF/3TC+NVP') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

select 
'1h = TDF/FTC/EFV' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('1h = TDF/FTC/EFV') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

SELECT
  'Adult 2nd Line Regimens:' as 'Regimen',
  '' as '<10 Male',
  '' as '<10 Female',
  '' as'10-15 Male' ,
  '' as'10-15 Female',
  '' as '15-49 Male',
  '' as '15-49 Female',
  '' as '50+ Male',
  '' as '50+ Female',
  '' as 'Total',
  '' as'BreastFeeding',
  '' as 'Pregnant'
From DUAL

UNION ALL

select 

'2a=AZT/3TC+DTG' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2a=AZT/3TC+DTG') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

select 
'2b=ABC/3TC+DTG' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2b=ABC/3TC+DTG') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

select 
'2c=TDF+3TC+LPV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2c=TDF+3TC+LPV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

select 
'2d=TDF/3TC+ATV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2d=TDF/3TC+ATV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

select 
'2e=TDF/FTC-LPV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2e=TDF/FTC-LPV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL
select 
'2f=TDF/FTC-ATV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2f=TDF/FTC-ATV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL
select 
'2g=AZT/3TC+LPV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2g=AZT/3TC+LPV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL
select 
'2h=AZT/3TC+ATV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2h=AZT/3TC+ATV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

select 
'2i=ABC/3TC+LPV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2i=ABC/3TC+LPV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id
UNION ALL
select 
'2j=ABC/3TC+ATV/r' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2j=ABC/3TC+ATV/r') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL
select 
'2k=TDF/3TC/DTG' as 'Regimen',
'N/A' as '<10 Male',
count(distinct(case when patient_id is not null and Age < 10 and gender = 'F' then patient_id end)) as '<10 Female',
'N/A' as '10 - 15 Male',
count(distinct(case when patient_id is not null and Age >= 10 and Age  <15 and gender = 'F' then patient_id end)) as '10 - 15 Female',
'N/A' as '15 - 49 Male',
count(distinct(case when patient_id is not null and Age >= 15 and Age < 50 and gender = 'F'  then patient_id end)) as '15 - 49 Female',
'N/A' as '50+ Male',
count(distinct(case when patient_id is not null and Age >= 50 and gender = 'F'  then patient_id end)) as '50+ Female',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F'  then patient_id end)) as 'Total',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and breastFeeding = 'YES' then patient_id end)) as 'Breastfeeding',
count(distinct(case when patient_id is not null and Age > 0 and gender = 'F' and pregnant = 'YES'  then patient_id end)) as 'Pregant'

from(
select patient_id, Age, gender
from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped , p.birthdate , p.gender ,
(TIMESTAMPDIFF(YEAR, p.birthdate, '#endDate#')) as 'Age'
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
left join person p on o.patient_id = p.person_id
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))
and name = ('2k=TDF/3TC/DTG') 
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate and gender = 'F'
)t1a left join (
select person_id , (case when  pregnantResult = 1 then 'YES' else 'NO' end) as 'pregnant' from (
select person_id, pregnantResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pregnantResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'pregnant' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.pregnantResult = tConceptname.concept_id
)tpregnant on t1a.patient_id = tpregnant.person_id
left join(
select person_id , (case when  breastFeedingResult = 1 then 'YES' else 'NO' end) as 'breastFeeding' from (
select person_id, breastFeedingResult from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'breastFeedingResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'breastfeeding' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.breastFeedingResult = tConceptname.concept_id
)tBreastFeeding on t1a.patient_id = tBreastFeeding.person_id

UNION ALL

SELECT
  'No signs of TB' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END overFiftyfemale,
    CASE WHEN (cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END totalAll,
    CASE WHEN (cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END breastfeeding,
    CASE WHEN (cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END Pregnant
FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'cuCoughResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Current Cough" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS cr ON (cr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbFeverResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Fever" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS fr ON (fr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbWeightResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening ,Weight loss" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS wr ON (wr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbNightsResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Night Sweats" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS nr ON (nr.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
  'Presumptive TB case' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END overFiftyfemale,
    CASE WHEN (cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END totalAll,
    CASE WHEN (cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END Pregnant
FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'cuCoughResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Current Cough" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS cr ON (cr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbFeverResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Fever" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS fr ON (fr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbWeightResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening ,Weight loss" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS wr ON (wr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbNightsResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Night Sweats" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS nr ON (nr.visitPatientId = pn.person_id)
) p

UNION All

SELECT
  'Not Assesed' as 'Title',
  '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'TB RX' as 'Title',
  '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual
