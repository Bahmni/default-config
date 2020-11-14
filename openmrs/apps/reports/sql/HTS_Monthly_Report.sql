select 'First Time Testers',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1 and pat_id_tested is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4 and pat_id_tested is not null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9 and pat_id_tested is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14 and pat_id_tested is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19 and pat_id_tested is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24 and pat_id_tested is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29 and pat_id_tested is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34 and pat_id_tested is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39 and pat_id_tested is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44 and pat_id_tested is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49 and pat_id_tested is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50 and pat_id_tested is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'M' and pat_id_tested is not null then pid end)) as 'Total MALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1 and pat_id_tested is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4 and pat_id_tested is not null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9 and pat_id_tested is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14 and pat_id_tested is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19 and pat_id_tested is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24 and pat_id_tested is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29 and pat_id_tested is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34 and pat_id_tested is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39 and pat_id_tested is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44 and pat_id_tested is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49 and pat_id_tested is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50 and pat_id_tested is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex = 'F' and pat_id_tested is not null then pid end)) as 'Total FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested'  and sex in ('F','M') and pat_id_tested is not null then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all 
select 'Repeat Testers',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age < 1 and pat_id_positives is null then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives is null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives is null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives is null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives is null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives is null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives is null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives is null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives is null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives is null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives is null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 50 and pat_id_positives is null then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and pat_id_positives is null then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age < 1 and pat_id_positives is null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives is null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives is null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives is null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives is null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives is null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives is null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives is null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives is null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives is null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives is null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 50 and pat_id_positives is null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and pat_id_positives is null then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex in ('F','M') and pat_id_positives is null then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select distinct(patient_id) as pat_id_positives,row_num,  date_activated , name  as 'firstregimen' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 )  
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 1
)tHivPositives on tDemographics.pid = tHivPositives.pat_id_positives
union all
select 'VCT(CITC)  Tested ',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all 
select 'VCT(CITC) +ve',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all 
select 'PITC TB Tested',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic'  and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic'  and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic'  and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all
select 'PITC TB +ve',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age < 1 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 50 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age < 1 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 50 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex in ('F','M') and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_tb_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsTBDiagnosized on tDemographics.pid = tIsTBDiagnosized.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all 
select 'PITC OPD Tested',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all 
select 'PITC OPD +ve',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all 
select 'PITC Inpatient Tested',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all 
select 'PITC Inpatient +ve',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all 
select 'PITC (Nutrition Unit) Tested',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all 
select 'PITC (Nutrition Unit) +ve',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all
select 'PITC Pediatric Tested',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all
select 'PITC Pediatric +ve',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all 
select 'PITC (STI Clinic) Tested',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all
select 'PITC (STI Clinic) +ve',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all
select 'PITC ANC Tested',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all
select 'PITC ANC +ve',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all
select 'Others Tested',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all
select 'Others +ve',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all
select 'Index Case Contact Tested', (@sexl1+@fam1) as '< 1 YRS MALE',(@sexl2+@fam2) as '4 - 5 YRS MALEs',(@sexl3+@fam3) as '5 - 9 YRS MALEs',
(@sexl4+@fam4) as '10 - 14 YRS MALEs',
(@sexl5+@fam5) as '15 - 19 YRS MALEs',(@sexl6+@fam6) as '20 - 24 YRS MALEs',(@sexl7+@fam7)as '25 - 29 YRS MALEs',(@sexl8+@fam8) as '30 - 34 YRS MALEs',
(@sexl9+@fam9) as '35 - 39 YRS MALEs',(@sexl10+@fam10) as '40 - 44 YRS MALEs',(@sexl11+@fam11)  as '45 - 49 YRS MALEs',(@sexl12+@fam12) as '50+ YRS MALEs',(@sexl13+@fam13) as 'Total MALEs',
(@sexl14+@fam14) as '< 1 YRS FEMALEs' ,(@sexl15+@fam15) as '4 - 5 YRS FEMALEs',(@sexl16+@fam16)  as '5 - 9 YRS FEMALEs',(@sexl17+@fam17)  as '10 - 14 YRS FEMALEs'
,(@sexl18+@fam18) as '15 - 19 YRS FEMALEs',(@sexl19+@fam19) as '20 - 24 YRS FEMALEs',(@sexl20+@fam20) as '25 - 29 YRS FEMALEs',(@sexl21+@fam21) as '30 - 34 YRS FEMALEs',
(@sexl22+@fam22)  as '35 - 39 YRS FEMALEs',(@sexl23+@fam23) as '40 - 44 YRS FEMALEs',(@sexl24+@fam24) as '45 - 49 YRS FEMALEs',(@sexl25+@fam25) as '50+ YRS FEMALEs',(@sexl26+@fam26) as 'Total FEMALEs',
(@sexl27+@fam27) as 'Overall Totals'  from (
select
@sexl1 := count(distinct(case when pat_sexual_pTested and sex = 'M' and age < 1  then pat_sexual_pTested end)) as '< 1 YRS MALEs',
@sexl2 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 1 and age <= 4  then pat_sexual_pTested end)) as '4 - 5 YRS MALEs',
@sexl3 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 5 and age <= 9  then pat_sexual_pTested end)) as '5 - 9 YRS MALEs',
@sexl4 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 10 and age <= 14  then pat_sexual_pTested end)) as '10 - 14 YRS MALEs',
@sexl5 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 15 and age <= 19  then pat_sexual_pTested end)) as '15 - 19 YRS MALEs',
@sexl6 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 20 and age <= 24  then pat_sexual_pTested end)) as '20 - 24 YRS MALEs',
@sexl7 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 25 and age <= 29  then pat_sexual_pTested end)) as '25 - 29 YRS MALEs',
@sexl8 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 30 and age <= 34  then pat_sexual_pTested end)) as '30 - 34 YRS MALEs',
@sexl9 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 35 and age <= 39  then pat_sexual_pTested end)) as '35 - 39 YRS MALEs',
@sexl10 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 40 and age <= 44  then pat_sexual_pTested end)) as '40 - 44 YRS MALEs',
@sexl11 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 45 and age <= 49  then pat_sexual_pTested end)) as '45 - 49 YRS MALEs',
@sexl12 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 50  then pat_sexual_pTested end)) as '50+ YRS MALEs',
@sexl13 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M'  then pat_sexual_pTested end)) as 'Total MALEs',
@sexl14 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age < 1  then pat_sexual_pTested end)) as '< 1 YRS FEMALEs',
@sexl15 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 1 and age <= 4  then pat_sexual_pTested end)) as '4 - 5 YRS FEMALEs',
@sexl16 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 5 and age <= 9  then pat_sexual_pTested end)) as '5 - 9 YRS FEMALEs',
@sexl17 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 10 and age <= 14  then pat_sexual_pTested end)) as '10 - 14 YRS FEMALEs',
@sexl18 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 15 and age <= 19  then pat_sexual_pTested end)) as '15 - 19 YRS FEMALEs',
@sexl19 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 20 and age <= 24  then pat_sexual_pTested end)) as '20 - 24 YRS FEMALEs',
@sexl20 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 25 and age <= 29  then pat_sexual_pTested end)) as '25 - 29 YRS FEMALEs',
@sexl21 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 30 and age <= 34  then pat_sexual_pTested end)) as '30 - 34 YRS FEMALEs',
@sexl22 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 35 and age <= 39  then pat_sexual_pTested end)) as '35 - 39 YRS FEMALEs',
@sexl23 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 40 and age <= 44  then pat_sexual_pTested end)) as '40 - 44 YRS FEMALEs',
@sexl24 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 45 and age <= 49  then pat_sexual_pTested end)) as '45 - 49 YRS FEMALEs',
@sexl25 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 50  then pat_sexual_pTested end)) as '50+ YRS FEMALEs',
@sexl26 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F'  then pat_sexual_pTested end)) as 'Total FEMALEs',
@sexl27 :=count(distinct(case when pat_sexual_pTested is not null and sex in ('F','M')  then pat_sexual_pTested end)) as 'Overall Totals',
@fam1 := count(distinct(case when pat_tested_fmember and sex = 'M' and age < 1  then pat_tested_fmember end)) as '< 1 YRS MALE',
@fam2 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 1 and age <= 4  then pat_tested_fmember end)) as '4 - 5 YRS MALE',
@fam3 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 5 and age <= 9  then pat_tested_fmember end)) as '5 - 9 YRS MALE',
@fam4 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 10 and age <= 14  then pat_tested_fmember end)) as '10 - 14 YRS MALE',
@fam5 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 15 and age <= 19  then pat_tested_fmember end)) as '15 - 19 YRS MALE',
@fam6 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 20 and age <= 24  then pat_tested_fmember end)) as '20 - 24 YRS MALE',
@fam7 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 25 and age <= 29  then pat_tested_fmember end)) as '25 - 29 YRS MALE',
@fam8 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 30 and age <= 34  then pat_tested_fmember end)) as '30 - 34 YRS MALE',
@fam9 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 35 and age <= 39  then pat_tested_fmember end)) as '35 - 39 YRS MALE',
@fam10 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 40 and age <= 44  then pat_tested_fmember end)) as '40 - 44 YRS MALE',
@fam11 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 45 and age <= 49  then pat_tested_fmember end)) as '45 - 49 YRS MALE',
@fam12 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 50  then pat_tested_fmember end)) as '50+ YRS MALE',
@fam13 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M'  then pat_tested_fmember end)) as 'Total MALE',
@fam14 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age < 1  then pat_tested_fmember end)) as '< 1 YRS FEMALE',
@fam15 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 1 and age <= 4  then pat_tested_fmember end)) as '4 - 5 YRS FEMALE',
@fam16 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 5 and age <= 9  then pat_tested_fmember end)) as '5 - 9 YRS FEMALE',
@fam17 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 10 and age <= 14  then pat_tested_fmember end)) as '10 - 14 YRS FEMALE',
@fam18 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 15 and age <= 19  then pat_tested_fmember end)) as '15 - 19 YRS FEMALE',
@fam19 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 20 and age <= 24  then pat_tested_fmember end)) as '20 - 24 YRS FEMALE',
@fam20 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 25 and age <= 29  then pat_tested_fmember end)) as '25 - 29 YRS FEMALE',
@fam21 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 30 and age <= 34  then pat_tested_fmember end)) as '30 - 34 YRS FEMALE',
@fam22 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 35 and age <= 39  then pat_tested_fmember end)) as '35 - 39 YRS FEMALE',
@fam23 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 40 and age <= 44  then pat_tested_fmember end)) as '40 - 44 YRS FEMALE',
@fam24 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 45 and age <= 49  then pat_tested_fmember end)) as '45 - 49 YRS FEMALE',
@fam25 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 50  then pat_tested_fmember end)) as '50+ YRS FEMALE',
@fam26 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F'  then pat_tested_fmember end)) as 'Total FEMALE',
@fam27 :=count(distinct(case when pat_tested_fmember is not null and sex in ('F','M')  then pat_tested_fmember end)) as 'Overall Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select person_id as pat_sexual_pTested, isSexualPartnerTested from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isSexualPartnerTested', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pat_sexual_pTested , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pat_sexual_pTested) c on 
a.person_id = c.pat_sexual_pTested and a.encounter_id = c.maxdate 
)tFamilyMemberTested on tDemographics.person_id = tFamilyMemberTested.pat_sexual_pTested
left join (
select person_id as pat_tested_fmember, isFmemberTested from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isFmemberTested', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pat_tested_fmember , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pat_tested_fmember) c on 
a.person_id = c.pat_tested_fmember and a.encounter_id = c.maxdate 
)tFamilyMemberTsted on tDemographics.person_id = tFamilyMemberTsted.pat_tested_fmember
)tested
union all
select 'Index Case Contact +ve', (@sexl1+@fam1) as '< 1 YRS MALE',(@sexl2+@fam2) as '4 - 5 YRS MALEs',(@sexl3+@fam3) as '5 - 9 YRS MALEs',
(@sexl4+@fam4) as '10 - 14 YRS MALEs',
(@sexl5+@fam5) as '15 - 19 YRS MALEs',(@sexl6+@fam6) as '20 - 24 YRS MALEs',(@sexl7+@fam7)as '25 - 29 YRS MALEs',(@sexl8+@fam8) as '30 - 34 YRS MALEs',
(@sexl9+@fam9) as '35 - 39 YRS MALEs',(@sexl10+@fam10) as '40 - 44 YRS MALEs',(@sexl11+@fam11)  as '45 - 49 YRS MALEs',(@sexl12+@fam12) as '50+ YRS MALEs',(@sexl13+@fam13) as 'Total MALEs',
(@sexl14+@fam14) as '< 1 YRS FEMALEs' ,(@sexl15+@fam15) as '4 - 5 YRS FEMALEs',(@sexl16+@fam16)  as '5 - 9 YRS FEMALEs',(@sexl17+@fam17)  as '10 - 14 YRS FEMALEs'
,(@sexl18+@fam18) as '15 - 19 YRS FEMALEs',(@sexl19+@fam19) as '20 - 24 YRS FEMALEs',(@sexl20+@fam20) as '25 - 29 YRS FEMALEs',(@sexl21+@fam21) as '30 - 34 YRS FEMALEs',
(@sexl22+@fam22)  as '35 - 39 YRS FEMALEs',(@sexl23+@fam23) as '40 - 44 YRS FEMALEs',(@sexl24+@fam24) as '45 - 49 YRS FEMALEs',(@sexl25+@fam25) as '50+ YRS FEMALEs',(@sexl26+@fam26) as 'Total FEMALEs',
(@sexl27+@fam27) as 'Overall Totals'  from (
select
@sexl1 := count(distinct(case when pat_sexual_pTested and sex = 'M' and age < 1  then pat_sexual_pTested end)) as '< 1 YRS MALEs',
@sexl2 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 1 and age <= 4  then pat_sexual_pTested end)) as '4 - 5 YRS MALEs',
@sexl3 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 5 and age <= 9  then pat_sexual_pTested end)) as '5 - 9 YRS MALEs',
@sexl4 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 10 and age <= 14  then pat_sexual_pTested end)) as '10 - 14 YRS MALEs',
@sexl5 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 15 and age <= 19  then pat_sexual_pTested end)) as '15 - 19 YRS MALEs',
@sexl6 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 20 and age <= 24  then pat_sexual_pTested end)) as '20 - 24 YRS MALEs',
@sexl7 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 25 and age <= 29  then pat_sexual_pTested end)) as '25 - 29 YRS MALEs',
@sexl8 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 30 and age <= 34  then pat_sexual_pTested end)) as '30 - 34 YRS MALEs',
@sexl9 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 35 and age <= 39  then pat_sexual_pTested end)) as '35 - 39 YRS MALEs',
@sexl10 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 40 and age <= 44  then pat_sexual_pTested end)) as '40 - 44 YRS MALEs',
@sexl11 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 45 and age <= 49  then pat_sexual_pTested end)) as '45 - 49 YRS MALEs',
@sexl12 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M' and age >= 50  then pat_sexual_pTested end)) as '50+ YRS MALEs',
@sexl13 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'M'  then pat_sexual_pTested end)) as 'Total MALEs',
@sexl14 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age < 1  then pat_sexual_pTested end)) as '< 1 YRS FEMALEs',
@sexl15 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 1 and age <= 4  then pat_sexual_pTested end)) as '4 - 5 YRS FEMALEs',
@sexl16 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 5 and age <= 9  then pat_sexual_pTested end)) as '5 - 9 YRS FEMALEs',
@sexl17 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 10 and age <= 14  then pat_sexual_pTested end)) as '10 - 14 YRS FEMALEs',
@sexl18 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 15 and age <= 19  then pat_sexual_pTested end)) as '15 - 19 YRS FEMALEs',
@sexl19 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 20 and age <= 24  then pat_sexual_pTested end)) as '20 - 24 YRS FEMALEs',
@sexl20 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 25 and age <= 29  then pat_sexual_pTested end)) as '25 - 29 YRS FEMALEs',
@sexl21 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 30 and age <= 34  then pat_sexual_pTested end)) as '30 - 34 YRS FEMALEs',
@sexl22 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 35 and age <= 39  then pat_sexual_pTested end)) as '35 - 39 YRS FEMALEs',
@sexl23 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 40 and age <= 44  then pat_sexual_pTested end)) as '40 - 44 YRS FEMALEs',
@sexl24 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 45 and age <= 49  then pat_sexual_pTested end)) as '45 - 49 YRS FEMALEs',
@sexl25 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F' and age >= 50  then pat_sexual_pTested end)) as '50+ YRS FEMALEs',
@sexl26 :=count(distinct(case when pat_sexual_pTested is not null and sex = 'F'  then pat_sexual_pTested end)) as 'Total FEMALEs',
@sexl27 :=count(distinct(case when pat_sexual_pTested is not null and sex in ('F','M')  then pat_sexual_pTested end)) as 'Overall Totals',
@fam1 := count(distinct(case when pat_tested_fmember and sex = 'M' and age < 1  then pat_tested_fmember end)) as '< 1 YRS MALE',
@fam2 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 1 and age <= 4  then pat_tested_fmember end)) as '4 - 5 YRS MALE',
@fam3 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 5 and age <= 9  then pat_tested_fmember end)) as '5 - 9 YRS MALE',
@fam4 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 10 and age <= 14  then pat_tested_fmember end)) as '10 - 14 YRS MALE',
@fam5 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 15 and age <= 19  then pat_tested_fmember end)) as '15 - 19 YRS MALE',
@fam6 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 20 and age <= 24  then pat_tested_fmember end)) as '20 - 24 YRS MALE',
@fam7 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 25 and age <= 29  then pat_tested_fmember end)) as '25 - 29 YRS MALE',
@fam8 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 30 and age <= 34  then pat_tested_fmember end)) as '30 - 34 YRS MALE',
@fam9 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 35 and age <= 39  then pat_tested_fmember end)) as '35 - 39 YRS MALE',
@fam10 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 40 and age <= 44  then pat_tested_fmember end)) as '40 - 44 YRS MALE',
@fam11 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 45 and age <= 49  then pat_tested_fmember end)) as '45 - 49 YRS MALE',
@fam12 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M' and age >= 50  then pat_tested_fmember end)) as '50+ YRS MALE',
@fam13 :=count(distinct(case when pat_tested_fmember is not null and sex = 'M'  then pat_tested_fmember end)) as 'Total MALE',
@fam14 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age < 1  then pat_tested_fmember end)) as '< 1 YRS FEMALE',
@fam15 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 1 and age <= 4  then pat_tested_fmember end)) as '4 - 5 YRS FEMALE',
@fam16 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 5 and age <= 9  then pat_tested_fmember end)) as '5 - 9 YRS FEMALE',
@fam17 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 10 and age <= 14  then pat_tested_fmember end)) as '10 - 14 YRS FEMALE',
@fam18 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 15 and age <= 19  then pat_tested_fmember end)) as '15 - 19 YRS FEMALE',
@fam19 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 20 and age <= 24  then pat_tested_fmember end)) as '20 - 24 YRS FEMALE',
@fam20 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 25 and age <= 29  then pat_tested_fmember end)) as '25 - 29 YRS FEMALE',
@fam21 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 30 and age <= 34  then pat_tested_fmember end)) as '30 - 34 YRS FEMALE',
@fam22 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 35 and age <= 39  then pat_tested_fmember end)) as '35 - 39 YRS FEMALE',
@fam23 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 40 and age <= 44  then pat_tested_fmember end)) as '40 - 44 YRS FEMALE',
@fam24 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 45 and age <= 49  then pat_tested_fmember end)) as '45 - 49 YRS FEMALE',
@fam25 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F' and age >= 50  then pat_tested_fmember end)) as '50+ YRS FEMALE',
@fam26 :=count(distinct(case when pat_tested_fmember is not null and sex = 'F'  then pat_tested_fmember end)) as 'Total FEMALE',
@fam27 :=count(distinct(case when pat_tested_fmember is not null and sex in ('F','M')  then pat_tested_fmember end)) as 'Overall Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select person_id as pat_sexual_pTested, isSexualPartnerTested from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isSexualPartnerTested', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1738 and voided = 0
)a inner join (select person_id as pat_sexual_pTested , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pat_sexual_pTested) c on 
a.person_id = c.pat_sexual_pTested and a.encounter_id = c.maxdate 
)tFamilyMemberTested on tDemographics.person_id = tFamilyMemberTested.pat_sexual_pTested
left join (
select person_id as pat_tested_fmember, isFmemberTested from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isFmemberTested', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1738 and voided = 0
)a inner join (select person_id as pat_tested_fmember , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pat_tested_fmember) c on 
a.person_id = c.pat_tested_fmember and a.encounter_id = c.maxdate 
)tFamilyMemberTsted on tDemographics.person_id = tFamilyMemberTsted.pat_tested_fmember
)testedPositive
union all
select 'Community Tested',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all
select 'Community +ve',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Community' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id
union all 
select 'Total Key Population Tested',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex in ('F','M')  then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_tested' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
union all
select 'Total Key Population Tested +ve',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age < 1 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 50 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex in ('F','M') and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as 'Overall Total'
from (
select pid , tConceptname.name as 'entrypoint'  from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HIV - Entry Point' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers left join ( select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tDemographics 
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tEnrtyPoint on tDemographics.pid = tEnrtyPoint.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'pat_id_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivPositives on tDemographics.pid = tHivPositives.person_id
left join (
select person_id, (select name from concept_name where concept_id = hivStatus and concept_name_type = 'FULLY_SPECIFIED') as 'result_positives' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'hivStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Newly Tested HIV Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultPositive on tDemographics.pid = tResultPositive.person_id










