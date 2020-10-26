select 'First Time Testers',
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
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex in ('F','M')  then pid end)) as 'Overall Total'
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
select 'VCT(CITC) +ve',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and pat_id_positives is not null then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and pat_id_positives is not null then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex in ('F','M') and pat_id_positives is not null then pid end)) as 'Overall Total'
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
select 'PITC OPD Tested',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex in ('F','M')  then pid end)) as 'Overall Total'
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
select 'PITC OPD +ve',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and pat_id_positives is not null then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and pat_id_positives is not null then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex in ('F','M') and pat_id_positives is not null then pid end)) as 'Overall Total'
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
select 'PITC Inpatient Tested',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex in ('F','M')  then pid end)) as 'Overall Total'
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
select 'PITC Inpatient +ve',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and pat_id_positives is not null then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and pat_id_positives is not null then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex in ('F','M') and pat_id_positives is not null then pid end)) as 'Overall Total'
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
select 'PITC Pediatric Tested',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex in ('F','M')  then pid end)) as 'Overall Total'
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
select 'PITC Pediatric +ve',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and pat_id_positives is not null then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and pat_id_positives is not null then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex in ('F','M') and pat_id_positives is not null then pid end)) as 'Overall Total'
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
select 'PITC (STI Clinic) Tested',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex in ('F','M')  then pid end)) as 'Overall Total'
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
select 'PITC (STI Clinic) +ve',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and pat_id_positives is not null then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and pat_id_positives is not null then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex in ('F','M') and pat_id_positives is not null then pid end)) as 'Overall Total'
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
select 'PITC ANC Tested',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 1 and age <= 4  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 5 and age <= 9  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 10 and age <= 14  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 15 and age <= 19  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 20 and age <= 24  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 25 and age <= 29  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 30 and age <= 34  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 35 and age <= 39  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 40 and age <= 44  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 45 and age <= 49  then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 50  then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F'  then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex in ('F','M')  then pid end)) as 'Overall Total'
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
select 'PITC ANC +ve',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and pat_id_positives is not null then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age < 1 and pat_id_positives is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 1 and age <= 4 and pat_id_positives is not null then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 5 and age <= 9 and pat_id_positives is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 10 and age <= 14 and pat_id_positives is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 15 and age <= 19 and pat_id_positives is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 20 and age <= 24 and pat_id_positives is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 25 and age <= 29 and pat_id_positives is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 30 and age <= 34 and pat_id_positives is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 35 and age <= 39 and pat_id_positives is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 40 and age <= 44 and pat_id_positives is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 45 and age <= 49 and pat_id_positives is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 50 and pat_id_positives is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and pat_id_positives is not null then pid end)) as 'Total FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex in ('F','M') and pat_id_positives is not null then pid end)) as 'Overall Total'
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




