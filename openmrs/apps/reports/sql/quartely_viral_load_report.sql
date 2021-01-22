select 'less than 1 year' as 'Age Groups', sex, 
@documented1 := count(distinct(case when value_numeric is not null and age < 1 then pid end)) as '\# of  VL documented in ART',
count(distinct(case when value_numeric >= 1000 and age < 1 then pid end)) as '\# of VL results(>=1000 copies/ml) in ART',
count(distinct(case when value_numeric < 1000 and age < 1 then pid end)) as '\# of VL results (<1000copies/ml) in ART',
count(distinct(case when isPregnant and age < 1 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age < 1  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age < 1 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and value_numeric >= 1000 and age < 1 then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = (select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all
select '1 to 4 Years' as 'Age Groups', sex, 
@documented2 := count(distinct(case when value_numeric is not null and age >= 1 and age < 5 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 1 and age < 5 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 1 and age < 5 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 1 and age < 5 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 1 and age < 5  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 1 and age < 5 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 1 and age < 5  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all 
select '5 to 9 Years' as 'Age Groups', sex, 
@documented3 := count(distinct(case when value_numeric is not null and age >= 5 and age < 10 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 5 and age < 10 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 5 and age < 10 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 5 and age < 10 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 5 and age < 10  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 5 and age < 10 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 5 and age < 10  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all 
select '10 to 14 Years' as 'Age Groups', sex, 
@documented4 :=  count(distinct(case when value_numeric is not null and age >= 10 and age < 15 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 10 and age < 15 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 10 and age < 15 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 10 and age < 15 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 10 and age < 15  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 10 and age < 15 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 10 and age < 15  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all 
select '15 to 19 Years' as 'Age Groups', sex, 
@documented5 := count(distinct(case when value_numeric is not null and age >= 15 and age < 20 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 15 and age < 20 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 15 and age < 20 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 15 and age < 20 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 15 and age < 20  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 15 and age < 20 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 15 and age < 20  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all 
select '20 to 24 Years' as 'Age Groups', sex, 
@documented6 := count(distinct(case when value_numeric is not null and age >= 20 and age < 25 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 20 and age < 25 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 20 and age < 25 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 20 and age < 25 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 20 and age < 25  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 20 and age < 25 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 20 and age < 25  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all
select '25 to 29 Years' as 'Age Groups', sex, 
@documented7 := count(distinct(case when value_numeric is not null and age >= 25 and age < 30 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 25 and age < 30 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 25 and age < 30 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 25 and age < 29 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 29 and age < 30  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 29 and age < 30 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 29 and age < 30  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id group by sex
union all
select '30 to 34 Years' as 'Age Groups', sex, 
@documented8 := count(distinct(case when value_numeric is not null and age >= 30 and age < 35 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 30 and age < 35 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 30 and age < 35 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 30 and age < 35 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 30 and age < 35  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 30 and age < 34 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 30 and age < 35  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id group by sex
union all
select '35 to 39 Years' as 'Age Groups', sex, 
@documented9 := count(distinct(case when value_numeric is not null and age >= 35 and age < 40 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 35 and age < 40 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 35 and age < 40 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 35 and age < 40 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 35 and age < 40  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 35 and age < 40 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 35 and age < 40  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id group by sex
union all 
select '40 to 44 Years' as 'Age Groups', sex, 
@documented10 := count(distinct(case when value_numeric is not null and age >= 40 and age < 45 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 40 and age < 45 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 40 and age < 45 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 40 and age < 45 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 40 and age < 45  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 40 and age < 45 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 40 and age < 45  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all
select '45 to 49 Years' as 'Age Groups', sex, 
@documented11 := count(distinct(case when value_numeric is not null and age >= 45 and age < 50 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 45 and age < 50 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 45 and age < 50 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 45 and age < 50 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 45 and age < 50  then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 45 and age < 50 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >= 45 and age < 50  then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex
union all
select '50 Years and Above' as 'Age Groups', sex, 
@documented12 := count(distinct(case when value_numeric is not null and age >= 50 then pid end)) as 'Vl_Documented',
count(distinct(case when value_numeric >= 1000 and age >= 50 then pid end)) as 'VL results (>= 1,000 copies/ml)',
count(distinct(case when value_numeric < 1000 and age >= 50 then pid end)) as 'VL results (< 1,000 copies/ml)',
count(distinct(case when isPregnant and age >= 50 then pid end)) as 'Pregant Women with documented VL result',
count(distinct(case when isPregnant and value_numeric >= 1000 and age >= 50 then pid end)) as 'Pregant Women with documented VL result Above or Equal 1000',
count(distinct(case when isBreastfeeding and sex = 'F' and age >= 50 then pid end)) as 'Breastfeeding Women with documented VL result',
count(distinct(case when isBreastfeeding and sex = 'F' and  value_numeric >= 1000 and age >=50 then pid end)) as 'Breastfeeding Women with VL result equal or above 1000'
from 
(
select person_id as pid, obs_datetime , value_numeric from obs where concept_id = 
(select concept_id from concept_name where name = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tvlResults
left join (
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIspregnant on  tvlResults.pid = tIspregnant.person_id
left join (
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsbreastfeeding on tvlResults.pid = tIsbreastfeeding.person_id
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics on tvlResults.pid = tDemographics.person_id  group by sex










