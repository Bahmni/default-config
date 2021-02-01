
select 'First Time Testers' as 'Title',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age < 1 and pat_id_tested is not null then pid end)) as '< 1 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 1 and age < 5 and pat_id_tested is not null then pid end)) as '1 - 4 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 5 and age < 10 and pat_id_tested is not null then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 10 and age < 15 and pat_id_tested is not null then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 15 and age < 20 and pat_id_tested is not null then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 20 and age < 25 and pat_id_tested is not null then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 25 and age < 30 and pat_id_tested is not null then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 30 and age < 35 and pat_id_tested is not null then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 35 and age < 40 and pat_id_tested is not null then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 40 and age < 45 and pat_id_tested is not null then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 45 and age < 50 and pat_id_tested is not null then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and age >= 50 and pat_id_tested is not null then pid end)) as '50+ YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'M' and pat_id_tested is null then pid end)) as 'Total MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age < 1 and pat_id_tested is not null then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 1 and age < 5 and pat_id_tested is not null then pid end)) as '1 - 4 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 5 and age < 10 and pat_id_tested is not null then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 10 and age < 15 and pat_id_tested is not null then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 15 and age < 20 and pat_id_tested is not null then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 20 and age < 25 and pat_id_tested is not null then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 25 and age < 30 and pat_id_tested is not null then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 30 and age < 35 and pat_id_tested is not null then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 35 and age < 40 and pat_id_tested is not null then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 40 and age < 45 and pat_id_tested is not null then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 45 and age < 50 and pat_id_tested is not null then pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and age >= 50 and pat_id_tested is not null then pid end)) as '50+ YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex = 'F' and pat_id_tested is not null then pid end)) as 'Total FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and first_testing_date is not null and retesting_date is null and sex in ('F','M') and pat_id_tested is not null then pid end)) as 'Overall Total'
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
left join (
select first_testing_date , firsttime_pid from (
select  person_id as firsttime_pid, concept_id, value_datetime as 'first_testing_date' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date First Tested HIV +' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pidd , concept_id as cid, max(encounter_id) maxdate from obs where concept_id =
 (select concept_id from concept_name where name = 'Date First Tested HIV +' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pidd) c on 
a.firsttime_pid = c.pidd and a.encounter_id = c.maxdate 
)tFirstTestingDate on tDemographics.pid = tFirstTestingDate.firsttime_pid 
left join (
select retesting_date , secondTime_pid from (
select  person_id as secondTime_pid, concept_id, value_datetime as 'retesting_date' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime < DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pidd , concept_id as cid, max(encounter_id) maxdate from obs where concept_id =
 (select concept_id from concept_name where name = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and obs_datetime < DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pidd) c on 
a.secondTime_pid = c.pidd and a.encounter_id = c.maxdate 
)tRepeatTestingDate on tDemographics.pid = tRepeatTestingDate.secondTime_pid 

union all 

select 'Repeat Testers' as 'Title',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age < 1 and pat_id_tested is not null then firsttime_pid end)) as '< 1 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 1 and age < 5 and pat_id_tested is not null then firsttime_pid end)) as '1 - 4 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 5 and age < 10 and pat_id_tested is not null then firsttime_pid end)) as '5 - 9 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 10 and age < 15 and pat_id_tested is not null then firsttime_pid end)) as '10 - 14 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 15 and age < 20 and pat_id_tested is not null then firsttime_pid end)) as '15 - 19 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 20 and age < 25 and pat_id_tested is not null then firsttime_pid end)) as '20 - 24 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 25 and age < 30 and pat_id_tested is not null then firsttime_pid end)) as '25 - 29 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 30 and age < 35 and pat_id_tested is not null then firsttime_pid end)) as '30 - 34 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 35 and age < 40 and pat_id_tested is not null then firsttime_pid end)) as '35 - 39 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 40 and age < 45 and pat_id_tested is not null then firsttime_pid end)) as '40 - 44 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 45 and age < 50 and pat_id_tested is not null then firsttime_pid end)) as '45 - 49 YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and age >= 50 and pat_id_tested is not null then firsttime_pid end)) as '50+ YRS MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'M' and pat_id_tested is not null then firsttime_pid end)) as 'Total MALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age < 1 and pat_id_tested is not null then firsttime_pid end)) as '< 1 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 1 and age < 5 and pat_id_tested is not null then firsttime_pid end)) as '1 - 4 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 5 and age < 10 and pat_id_tested is not null then firsttime_pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 10 and age < 15 and pat_id_tested is not null then firsttime_pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 15 and age < 20 and pat_id_tested is not null then firsttime_pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 20 and age < 25 and pat_id_tested is not null then firsttime_pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 25 and age < 30 and pat_id_tested is not null then firsttime_pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 30 and age < 35 and pat_id_tested is not null then firsttime_pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 35 and age < 40 and pat_id_tested is not null then firsttime_pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 40 and age < 45 and pat_id_tested is not null then firsttime_pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 45 and age < 50 and pat_id_tested is not null then firsttime_pid end)) as '45 - 49 YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and age >= 50 and pat_id_tested is not null then firsttime_pid end)) as '50+ YRS FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex = 'F' and pat_id_tested is not null then firsttime_pid end)) as 'Total FEMALE',
count(distinct(case when pat_id_tested = 'Newly Tested' and retesting_date is not null  and sex in ('F','M') and pat_id_tested is not null then firsttime_pid end)) as 'Overall Total'
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
left join (
select retesting_date , firsttime_pid from (
select  person_id as firsttime_pid, concept_id, value_datetime as 'retesting_date' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pidd , concept_id as cid, max(encounter_id) maxdate from obs where concept_id =
 (select concept_id from concept_name where name = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pidd) c on 
a.firsttime_pid = c.pidd and a.encounter_id = c.maxdate 
)tRepeatTestingDate on tDemographics.pid = tRepeatTestingDate.firsttime_pid 

union all
select 'VCT(CITC)  Tested ',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'VCT Clinic' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'TB Clinic'  and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic'  and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic'  and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 1 and age < 5 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 5 and age < 10 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 10 and age < 15 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 15 and age < 20 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 20 and age < 25 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 25 and age < 30 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 30 and age < 35 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 35 and age < 40 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 40 and age < 45 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 45 and age < 50 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and age >= 50 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'M' and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age < 1 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 1 and age < 5 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 5 and age < 10 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 10 and age < 15 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 15 and age < 20 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 20 and age < 25 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 25 and age < 30 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 30 and age < 35 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 35 and age < 40 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 40 and age < 45 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'TB Clinic' and sex = 'F' and age >= 45 and age < 50 and pat_tb_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Entry Point - OPD' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'In Patient' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Nutrition Unit' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Pediatric Clinic' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'STI Clinic' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'ANC Clinic' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Other Entry Point (Specify)' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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

select 
'Index Case Contact Tested' as 'Title',
count(distinct(case when Names is not null and ContactsAge < 1 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 1 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '1 - 4 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '5 - 9 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '10 - 14 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 15 - 19 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 20 - 24 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 25 - 29 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 30 - 34 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 36 - 40 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 40 - 44  YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 45 - 49 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as '< 50+ YRS MALE',
count(distinct(case when Names is not null and wasContactTested = 'YES' and PatnerGender = 'M'  then Names end)) as 'TOTAL MALE',
count(distinct(case when Names is not null and ContactsAge < 1 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 1 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '1 - 4 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '5 - 9 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '10 - 14 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 15 - 19 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 20 - 24 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 25 - 29 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 30 - 34 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 36 - 40 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 40 - 44  YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 45 - 49 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as '< 50+ YRS FEMALE',
count(distinct(case when Names is not null and wasContactTested = 'YES' and PatnerGender = 'F'  then Names end)) as 'TOTAL FEMALE',
count(distinct(case when Names is not null and wasContactTested = 'YES' and PatnerGender in ('F','M')  then Names end)) as 'Overall Total'

from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)tNewPatient
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') 
)tDemographics on tNewPatient.pid = tDemographics.person_id 
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b 
union all 
select 
'Index Case Contact +ve' as 'Title',
count(distinct(case when Names is not null and ContactsAge < 1 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 1 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '1 - 4 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '5 - 9 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '10 - 14 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 15 - 19 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 20 - 24 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 25 - 29 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 30 - 34 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 36 - 40 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and  PatnerGender = 'M'  then Names end)) as '< 40 - 44  YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 45 - 49 YRS MALE',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'M'  then Names end)) as '< 50+ YRS MALE',
count(distinct(case when Names is not null and wasContactTested = 'YES' and PatnerGender = 'M'  and (newHivResults is not null or KnownPositiveResults is not null)  then Names end)) as 'TOTAL MALE',
count(distinct(case when Names is not null and ContactsAge < 1 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 1 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '1 - 4 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '5 - 9 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '10 - 14 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 15 - 19 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 20 - 24 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 25 - 29 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 30 - 34 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 36 - 40 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 40 - 44  YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as '< 45 - 49 YRS FEMALE',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null)  and PatnerGender = 'F'  then Names end)) as '< 50+ YRS FEMALE',
count(distinct(case when Names is not null and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender = 'F'  then Names end)) as 'TOTAL FEMALE',
count(distinct(case when Names is not null and wasContactTested = 'YES'  and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('F','M')  then Names end)) as 'Overall Total'

from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)tNewPatient
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') 
)tDemographics on tNewPatient.pid = tDemographics.person_id 
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b 
union all
select 'Community Tested',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age < 1  then pid end)) as '< 1 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and pat_id_tested = 'Newly Tested' and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'M' and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Community' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M' and age >= 50  then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'M'  then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age < 1  then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 1 and age < 5  then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 5 and age < 10  then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 10 and age < 15  then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 15 and age < 20  then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 20 and age < 25  then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 25 and age < 30  then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 30 and age < 35  then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 35 and age < 40  then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 40 and age < 45  then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and pat_id_tested = 'Newly Tested'  and sex = 'F' and age >= 45 and age < 50  then pid end)) as '45 - 49 YRS FEMALE',
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
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and age >= 50 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '50+ YRS MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'M' and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as 'Total MALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age < 1 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '< 1 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 1 and age < 5 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '4 - 5 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 5 and age < 10 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '5 - 9 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 10 and age < 15 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '10 - 14 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 15 and age < 20 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '15 - 19 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 20 and age < 25 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '20 - 24 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 25 and age < 30 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '25 - 29 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 30 and age < 35 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '30 - 34 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 35 and age < 40 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '35 - 39 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 40 and age < 45 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '40 - 44 YRS FEMALE',
count(distinct(case when entrypoint = 'Key Population Tested' and sex = 'F' and age >= 45 and age < 50 and pat_id_positives = 'Newly Tested' and  result_positives = 'Newly Tested HIV+' then pid end)) as '45 - 49 YRS FEMALE',
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










