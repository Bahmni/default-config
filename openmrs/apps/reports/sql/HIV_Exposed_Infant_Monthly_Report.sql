-- HIV-exposed Infants Monthly Report
select 'Number of New HIV-Exposed Infants enrolled',
count(distinct(case when pid is not null and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and sex in ('M','F') then pid end)) as 'Total'
from (
select person_id  , dateStartedProphylaxis from (
select  person_id, (SELECT @a:= 0) AS a , concept_id, value_datetime as 'dateStartedProphylaxis' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and value_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and value_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateStartedProphylaxis
inner join (
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff('#endDate#',p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name = 'HeiRelationship' and concept_name_type = 'FULLY_SPECIFIED')
and (datediff('#endDate#',p.birthdate) / 365) < 2 
)tDemogrpahics on tDateStartedProphylaxis.person_id = tDemogrpahics.pid
inner join (
select person_id, isEnrolled from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isEnrolled', voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Clinic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Clinic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsEnrolled on tDemogrpahics.pid = tIsEnrolled.person_id


UNION ALL


select 'Number Of HIV-Exposed Infants seen (New And Old)',
count(distinct(case when pid is not null and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and sex in ('M','F') then pid end)) as 'Total'
from (
select person_id  , dateStartedProphylaxis from (
select  person_id, (SELECT @a:= 0) AS a , concept_id, value_datetime as 'dateStartedProphylaxis' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and value_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and value_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateStartedProphylaxis
inner join (
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff('#endDate#',p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and (datediff('#endDate#',p.birthdate) / 365) < 2 
)tDemogrpahics on tDateStartedProphylaxis.person_id = tDemogrpahics.pid
left join (
select person_id, isEnrolled from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isEnrolled', voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Clinic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Clinic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsEnrolled on tDemogrpahics.pid = tIsEnrolled.person_id


UNION ALL
SELECT
   'PCR test for HIV-Exposed Infants Upto 2 Months of age' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and pcrDateResult between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')) THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and pcrDateResult between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')) THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and pcrDateResult between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')) THEN 1 END totalAll 
  FROM person pn 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_datetime AS 'pcrDateResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="HEI Testing (First PCR Test Date)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'heiResultDate', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'heiResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (First PCR Results)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
 ) p

 UNION ALL


Select 
'PCR test for HIV-Exposed Infants between 2-12 Months of age',
count(distinct(case when pid is not null and firstPcrTest is not null and TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) >= 2 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) <= 12 and TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) >= 2 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) <= 12 and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and firstPcrTest is not null and TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) >= 2 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) <= 12 and TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) >= 2 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) <= 12 and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and firstPcrTest is not null and TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) >= 2 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) <= 12 and TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) >= 2 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) <= 12 and sex in ('F','M') then pid end)) as 'Total'

 from (
select pa.person_id as pidd, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,TIMESTAMPDIFF(MONTH, p.birthdate, DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))  as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and TIMESTAMPDIFF(MONTH, p.birthdate, DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) >= 2 and  TIMESTAMPDIFF(MONTH, p.birthdate, DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) <= 12 
)tDemographics
inner join (
select pid , tConceptname.name as 'firstPcrTest', obs_datetime as 'firstpcrTestResultDate'   from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tFirstPCrTest on tDemographics.pidd = tFirstPCrTest.pid
left join (
select person_id , firstPcrTestDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'firstPcrTestDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tFirstPCRTestDate on tDemographics.pidd = tFirstPCRTestDate.person_id


UNION ALL

Select 
'PCR test for HIV-Exposed Infants between 12-18 Months of age',
count(distinct(case when pid is not null and firstPcrTest is not null and TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) >= 12 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) <= 18 and TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) >= 12 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) <= 18 and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and firstPcrTest is not null and TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) >= 12 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) <= 18 and TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) >= 12 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) <= 18 and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and firstPcrTest is not null and TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) >= 12 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstpcrTestResultDate) <= 18 and TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) >= 12 and  TIMESTAMPDIFF(MONTH,date_of_birth, firstPcrTestDate) <= 18 and sex in ('F','M') then pid end)) as 'Total'

 from (
select pa.person_id as pidd, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,TIMESTAMPDIFF(MONTH, p.birthdate, DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'))  as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and TIMESTAMPDIFF(MONTH, p.birthdate, DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) >= 12 and  TIMESTAMPDIFF(MONTH, p.birthdate, DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) <= 18 
)tDemographics
inner join (
select pid , tConceptname.name as 'firstPcrTest', obs_datetime as 'firstpcrTestResultDate'   from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tFirstPCrTest on tDemographics.pidd = tFirstPCrTest.pid
left join (
select person_id , firstPcrTestDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'firstPcrTestDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tFirstPCRTestDate on tDemographics.pidd = tFirstPCRTestDate.person_id


UNION ALL

SELECT
   'Total number of results received from Public Health laboratory\n(regardless sample collected)' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M'  and datePhl is not null ) THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and datePhl is not null)  THEN 1 END femaleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and datePhl is not null) THEN 1 END totalAll 
  
  FROM visit v 
  JOIN person pn on pn.person_id = v.patient_id
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_datetime AS 'datePhl' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date sample receipt by PHL confirmed(First PCR Test)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
   'Number of results received from Public Health Laboratory\n (Only from sample collected this month)' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and datePhl is not null ) THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and datePhl is not null)  THEN 1 END femaleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and datePhl is not null) THEN 1 END totalAll 
  
  FROM visit v 
  JOIN person pn on pn.person_id = v.patient_id
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_datetime AS 'datePhl' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date sample receipt by PHL confirmed(First PCR Test)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
   'Total number of positive results received' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM (
    SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE())  between 0 and 18) and gender = 'M' and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id) THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id) THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and  heiResult = cnpr.concept_id and  rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id) THEN 1 END totalAll 
    FROM person pn 

    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',  o.obs_datetime AS 'obsDate', o.value_coded AS 'heiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (First PCR Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'rapidheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Rapid Test At 9 Months Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS rr ON (rr.visitPatientId = pn.person_id)
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'secondheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Second PCR Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS sr ON (sr.visitPatientId = pn.person_id)
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'repeatheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Repeat PCR Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS er ON (er.visitPatientId = pn.person_id)   
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'eightrapidheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (18Months Rapid Test Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id) 
    JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
    JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")  
    JOIN concept_name cnpr ON (cnpr.concept_name_type = "FULLY_SPECIFIED" AND cnpr.voided is false AND cnpr.name="HEI Results Positive") 
 ) p 

UNION ALL

SELECT
   'Total number of positive results received\n(only from samples collected this reporting months)' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM (
    SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE())  between 0 and 18) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id) THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id) THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and heiResult = cnpr.concept_id and  rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id) THEN 1 END totalAll 
    FROM person pn 

    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',  o.obs_datetime AS 'obsDate', o.value_coded AS 'heiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (First PCR Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'rapidheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Rapid Test At 9 Months Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS rr ON (rr.visitPatientId = pn.person_id)
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'secondheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Second PCR Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS sr ON (sr.visitPatientId = pn.person_id)
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'repeatheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Repeat PCR Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS er ON (er.visitPatientId = pn.person_id)   
    LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',o.value_coded AS 'eightrapidheiResult' FROM obs o 
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (18Months Rapid Test Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id) 
    JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
    JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")  
    JOIN concept_name cnpr ON (cnpr.concept_name_type = "FULLY_SPECIFIED" AND cnpr.voided is false AND cnpr.name="HEI Results Positive") 
 ) p 

UNION ALL

SELECT
   'Number of HIV Infected Infants started on ART' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M'  and arvDateProphylaxis is not null ) THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and arvDateProphylaxis is not null)  THEN 1 END femaleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and arvDateProphylaxis is not null) THEN 1 END totalAll 
  
  FROM visit v 
  JOIN person pn on pn.person_id = v.patient_id
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_datetime AS 'arvDateProphylaxis' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date of ARV Prophylaxis Start" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  ) p


UNION ALL

SELECT
   'Number of EID Samples rejected by Public Health Laboratory' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M'  and pcrResult is not null and pcrResult = 1 and rapidTestresult is not null and rapidTestresult = 1 and secondresult is not null and secondresult = 1 and repeatresult is not null and repeatresult = 1 and 18repeatresult is not null and 18repeatresult = 1) THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and pcrResult is not null and pcrResult = 1 and rapidTestresult is not null and rapidTestresult = 1 and secondresult is not null and secondresult = 1 and repeatresult is not null and repeatresult = 1 and 18repeatresult is not null and 18repeatresult = 1 ) THEN 1 END femaleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and pcrResult is not null and pcrResult = 1 and rapidTestresult is not null and rapidTestresult = 1 and secondresult is not null and secondresult = 1 and repeatresult is not null and repeatresult = 1 and 18repeatresult is not null and 18repeatresult = 1 ) THEN 1 END totalAll 
  
  FROM person pn 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_coded AS 'pcrResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Was Sample Rejected(First PCR Test)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate2', o.value_coded AS 'rapidTestresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Was Sample Rejected(Rapid Test At 9 Months)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
   JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate3', o.value_coded AS 'secondresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Was Sample Rejected(Second PCR Test)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS sr ON (sr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS 'repeatresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Was Sample Rejected(Repeat PCR Test)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS rr ON (rr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS '18repeatresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Was Sample Rejected(18Months Rapid Test)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS rs ON (rs.visitPatientId = pn.person_id)
 ) p


UNION ALL

SELECT
   'HIV-Exposed Infants Upto 2 Months on Cotrimoxazole' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
   CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and cotrimoxazoleResult is not null and cotrimoxazoleResult = 1 ) THEN 1 END maleGender,
   CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and cotrimoxazoleResult is not null and cotrimoxazoleResult = 1 ) THEN 1 END femaleGender,
   CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and cotrimoxazoleResult is not null and cotrimoxazoleResult = 1 ) THEN 1 END totalAll
  FROM person pn 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_coded AS 'cotrimoxazoleResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Cotrimoxazole/Dapsone" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
 ) p

UNION ALL

select 'Number HIV-exposed infants received AZT+NVP',
count(distinct(case when pid is not null and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and sex in ('M','F') then pid end)) as 'Total'
 from (
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and (datediff('#endDate#',p.birthdate) / 365) < 2 
)tDemogrpahics 
left join ( 
select person_b as 'mother_id' , relationship , person_a as 'hei_id' from relationship where 
relationship = (select relationship_type_id from relationship_type where a_is_to_b = 'Mother' and retired = 0) and voided = 0
)tMother on tDemogrpahics.pid = tMother.hei_id
inner join (
select person_id, (select name from concept_name where concept_id = babyArvs and concept_name_type = 'FULLY_SPECIFIED') as 'babyArvs' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'babyArvs', voided from obs where concept_id =
(select concept_id from concept_name where name = 'ARV Baby Discharged with' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'AZT+NVP' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ARV Baby Discharged with' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tArvBabyDischargedWith on tMother.mother_id = tArvBabyDischargedWith.person_id


UNION ALL

select 'Number HIV-exposed infants received NVP',
count(distinct(case when pid is not null and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and sex in ('M','F') then pid end)) as 'Total'
 from (
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and (datediff('#endDate#',p.birthdate) / 365) < 2 
)tDemogrpahics 
left join ( 
select person_b as 'mother_id' , relationship , person_a as 'hei_id' from relationship where 
relationship = (select relationship_type_id from relationship_type where a_is_to_b = 'Mother' and retired = 0) and voided = 0
)tMother on tDemogrpahics.pid = tMother.hei_id
inner join (
select person_id, (select name from concept_name where concept_id = babyArvs and concept_name_type = 'FULLY_SPECIFIED') as 'babyArvs' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'babyArvs', voided from obs where concept_id =
(select concept_id from concept_name where name = 'ARV Baby Discharged with' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'NVP' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ARV Baby Discharged with' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tArvBabyDischargedWith on tMother.mother_id = tArvBabyDischargedWith.person_id


UNION ALL


select 'Number HIV-exposed infants received ARV prophylaxis\n(NVP and AZT + NVP) within first 6 weeks',
count(distinct(case when pid is not null and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and sex in ('M','F') then pid end)) as 'Total'
from (
select person_id  , dateStartedProphylaxis from (
select  person_id, (SELECT @a:= 0) AS a , concept_id, value_datetime as 'dateStartedProphylaxis' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date of ARV Prophylaxis Start' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and value_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Date of ARV Prophylaxis Start' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and value_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateStartedProphylaxis
inner join (
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'HIVExposedInfant(HEI)No') 
and (datediff('#endDate#',p.birthdate) / 365) < 2 and (datediff(DATE_FORMAT('#endDate#','%Y-%m-01'),p.birthdate) / 7) <= 6
)tDemogrpahics on tDateStartedProphylaxis.person_id = tDemogrpahics.pid


UNION ALL

select 'HIV-exposed infants whose \n feeding practice was assessed' as 'Title',
count(distinct(case when pid is not null and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and sex in ('M','F') then pid end)) as 'Total'
from (

select person_id, infantFeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'infantFeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Infant Feeding' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Infant Feeding' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate  
)tInfantFeeding
inner join (
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and (datediff('#endDate#',p.birthdate) / 365) < 2 
)tDemogrpahics on tInfantFeeding.person_id = tDemogrpahics.pid


UNION ALL

SELECT
  'Total HIV-exposed Infants turned \n 12 months of age  in this reporting period' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN ((pa.value = (select concept_id from concept_name where name = "HeiRelationship") or pa.value = (select concept_id from concept_name where name = "ExistingHeiRelationship")) and (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 12 and gender = 'M') )  THEN 1 END maleGender,
    CASE WHEN ((pa.value = (select concept_id from concept_name where name = "HeiRelationship") or pa.value = (select concept_id from concept_name where name = "ExistingHeiRelationship")) and (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 12 and gender = 'F') )  THEN 1 END femaleGender,
    CASE WHEN ((pa.value = (select concept_id from concept_name where name = "HeiRelationship") or pa.value = (select concept_id from concept_name where name = "ExistingHeiRelationship")) and (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 12) )  THEN 1 END totalAll
  FROM visit v 
  LEFT JOIN person p1 on p1.person_id = v.patient_id
  LEFT JOIN person_attribute pa on pa.person_id = p1.person_id
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
) p


UNION ALL

SELECT
  'Received initial PCR test between 2–12 months' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12 and gender = 'M' and rapidTestResult is not null) THEN 1 END maleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12 and gender = 'F' and rapidTestResult is not null) THEN 1 END femaleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12 and rapidTestResult is not null) THEN 1 END totalAll 
  FROM visit v
  JOIN person pn on pn.person_id = v.patient_id 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'rapidTestResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="HEI Testing (First PCR Results)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
) p

UNION ALL

select 'Received rapid HIV antibody test 9 months' as 'Title',
count(distinct(case when pid is not null and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and sex in ('M','F') then pid end)) as 'Total'
from (

select person_id, infantFeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'infantFeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (Rapid Test At 9 Months Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (Rapid Test At 9 Months Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate  
)tInfantFeeding
inner join (
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and (TIMESTAMPDIFF(MONTH, p.birthdate, '#endDate#')) <= 9
)tDemogrpahics on tInfantFeeding.person_id = tDemogrpahics.pid

UNION ALL

SELECT
  'Total HIV-exposed infants turned\n18 months in this reporting period' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18 and gender = 'M' ) THEN 1 END maleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18 and gender = 'F' ) THEN 1 END femaleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18 ) THEN 1 END totalAll 
  FROM visit v
  JOIN person pn on pn.person_id = v.patient_id 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  ) p 

UNION ALL

SELECT
  'Total number of children tested using Anti body rapid teast at 18 months' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18 and gender = 'M' and rapidTestResult is not null) THEN 1 END maleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18 and gender = 'F' and rapidTestResult is not null) THEN 1 END femaleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18 and rapidTestResult is not null) THEN 1 END totalAll 
  FROM visit v
  JOIN person pn on pn.person_id = v.patient_id 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'rapidTestResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="HEI Testing (18Months Rapid Test  Results)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  ) p

UNION ALL

select 'Exposed infant at 18months HIV- positive',
count(distinct(case when pid is not null and Results18months = 'Positive' and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and Results18months = 'Positive' and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and Results18months = 'Positive' and sex in ('M','F') then pid end)) as 'Total'
 from (
select pa.person_id as pidd, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and DATE_FORMAT(p.birthdate,'%Y-%m') = DATE_FORMAT(DATE_SUB(LAST_DAY('#endDate#'), INTERVAL 18 MONTH),'%Y-%m') 
)tDemographics 
inner join(
select pid , tConceptname.name as 'Results18months' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)t18MonthsOutcome on tDemographics.pidd = t18MonthsOutcome.pid


UNION ALL

select 'Exposed infant at 18months HIV- negative and breastfeeding',
count(distinct(case when pid is not null and Results18months = 'Negative' and breastfeedingResults = 'EBF' and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and Results18months = 'Negative' and breastfeedingResults = 'EBF' and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and Results18months = 'Negative' and breastfeedingResults = 'EBF' and sex in ('M','F') then pid end)) as 'Total'
 from (
select pa.person_id as pidd, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and DATE_FORMAT(p.birthdate,'%Y-%m') = DATE_FORMAT(DATE_SUB(LAST_DAY('#endDate#'), INTERVAL 18 MONTH),'%Y-%m') 
)tDemographics 
inner join(
select pid , tConceptname.name as 'Results18months' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)t18MonthsOutcome on tDemographics.pidd = t18MonthsOutcome.pid
left join (
select breastfeeding_pid , tConceptname.name as 'breastfeedingResults' from (
select distinct(person_id) as breastfeeding_pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tBreastFeeding on tDemographics.pidd = tBreastFeeding.breastfeeding_pid


UNION ALL

select 'Exposed infant at 18months HIV- negative and no longer breastfeeding',
count(distinct(case when pid is not null and Results18months = 'Negative' and breastfeedingResults = 'No longer Breastfeed' and sex = 'M' then pid end)) as 'Male',
count(distinct(case when pid is not null and Results18months = 'Negative' and breastfeedingResults = 'No longer Breastfeed' and sex = 'F' then pid end)) as 'Female',
count(distinct(case when pid is not null and Results18months = 'Negative' and breastfeedingResults = 'No longer Breastfeed' and sex in ('M','F') then pid end)) as 'Total'
 from (
select pa.person_id as pidd, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59'),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED')
and DATE_FORMAT(p.birthdate,'%Y-%m') = DATE_FORMAT(DATE_SUB(LAST_DAY('#endDate#'), INTERVAL 18 MONTH),'%Y-%m') 
)tDemographics 
inner join(
select pid , tConceptname.name as 'Results18months' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)t18MonthsOutcome on tDemographics.pidd = t18MonthsOutcome.pid
left join (
select breastfeeding_pid , tConceptname.name as 'breastfeedingResults' from (
select distinct(person_id) as breastfeeding_pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tBreastFeeding on tDemographics.pidd = tBreastFeeding.breastfeeding_pid

