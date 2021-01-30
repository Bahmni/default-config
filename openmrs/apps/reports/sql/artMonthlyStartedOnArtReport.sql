-- ART Monthly Report - New and cumulative number of persons started on ART



select '<1 Yrs' as Title,
count(distinct(case when pidd is not null and sex = 'M' and ctxOrDapsonStartDate > DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#') - INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
count(distinct(case when pidd is not null and sex = 'F' and ctxOrDapsonStartDate > DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#') - INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
count(distinct(case when pidd is not null and sex in ('F','M') and ctxOrDapsonStartDate > DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#') - INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
count(distinct(case when pidd is not null and sex = 'M' and ctxOrDapsonStartDate > DATE_FORMAT('#startDate#','%Y-%m-01') and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pidd end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
count(distinct(case when pidd is not null and sex = 'F' and ctxOrDapsonStartDate > DATE_FORMAT('#startDate#','%Y-%m-01') and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pidd end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
'N/A' as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
'N/A' as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
count(distinct(case when pidd is not null and sex in ('M','F') and ctxOrDapsonStartDate > DATE_FORMAT('#startDate#','%Y-%m-01') and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pidd end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\nTotal',
count(distinct(case when pidd is not null and sex = 'M' and ctxOrDapsonStartDate is not null and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\nMale',
count(distinct(case when pidd is not null and sex = 'F' and ctxOrDapsonStartDate is not null and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\nFemale',
count(distinct(case when pidd is not null and sex in ('F','M') and ctxOrDapsonStartDate is not null and ctxOrDapsonStartDate <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\nTotal'
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
and TIMESTAMPDIFF(MONTH, p.birthdate, DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) <= 12 
)tDemographics 
inner join (
select ctxOrDapsonStartDate , ctxDapsone_pid from (
select  person_id as ctxDapsone_pid, concept_id, value_datetime as 'ctxOrDapsonStartDate' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'CTX or Dapose Start Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pidd , concept_id as cid, max(encounter_id) maxdate from obs where concept_id =
 (select concept_id from concept_name where name = 'CTX or Dapose Start Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pidd) c on 
a.ctxDapsone_pid = c.pidd and a.encounter_id = c.maxdate 
)tCtxDapsonStartDate on tDemographics.pidd = tCtxDapsonStartDate.ctxDapsone_pid


UNION ALL

SELECT 
  '1-4 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '5-9 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p 

UNION ALL

SELECT 
  '10-14 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '15-19 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p 

UNION ALL

SELECT 
  '20-24 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '25-29 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '30-34 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '35-39 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '40-44 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '45-49 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '50-54 YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  '55+ YRS' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'M'  and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F'  and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p  

UNION ALL

SELECT 
  'Total' as 'Age Group',
  count(maleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
  count(femaleGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
  count(totalGenderPreviousReportingPeriod) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
  count(maleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
  count(femaleGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
  count(pregnantWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
  count(breastFeedingWomens) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
  count(totalGenderCurrentReportingPeriod) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Total',
  count(maleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Male',
  count(femaleGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Female',
  count(totalGenderSoFar) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
FROM (
  SELECT
    CASE WHEN (gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (gender = 'M' and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (gender = 'F' and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (artStartDate is not NULL and artStartDate is not NULL) THEN 1 END totalGenderSoFar
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS asd ON (asd.visitPatientId = person_id) 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="FP Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'breastFeeding' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Currently Breastfeeding?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS bf ON (bf.visitPatientId = person_id)
) p
union all 
select 'Total Number of Clients Taking CTX ',
count(distinct(case when pid is not null and gender = 'M' and date_activated > DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#') - INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pid end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#'- INTERVAL 1 MONTH,'%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#') - INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pid end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
count(distinct(case when pid is not null and gender in ('M','F') and date_activated > DATE_FORMAT('#startDate#'- INTERVAL 1 MONTH,'%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#')- INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pid end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
count(distinct(case when pid is not null and gender = 'M' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) and edd > '#endDate#' then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) and isBreastfeeding is not null then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
count(distinct(case when pid is not null and gender in ('M','F') and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\nTotal',
count(distinct(case when pidd is not null and sex = 'M' then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\nMale',
count(distinct(case when pidd is not null and sex = 'F' then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\nFemale',
count(distinct(case when pidd is not null and sex in ('F','M') then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
from (
select person_id, arvreceivedbefore , gender from (  
select obs.person_id, obs.concept_id, obs.obs_datetime  , obs.encounter_id , obs.value_coded as 'arvreceivedbefore', obs.voided, gender from obs obs
left join person p on obs.person_id = p.person_id
where obs.concept_id =
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs.obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and obs.value_coded = 2 and obs.voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and
 obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)newStartedARTs
inner join(
select distinct(pid), firstregimen , date_activated from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'firstregimen' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'CTX Drug' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 )  
order by patient_id, date_activated) b where row_num = 1
)tfirstlinereg
)tnewStartedARTs on newStartedARTs.person_id = tnewStartedARTs.pid
left join
(
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT('#endDate#','%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIpregnant on newStartedARTs.person_id = tIpregnant.person_id
left join (
select person_id, edd from (  
select person_id, concept_id, obs_datetime as 'edd' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT('#endDate#','%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate
)tEdd on newStartedARTs.person_id = tEdd.person_id
left join(
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT('#endDate#','%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tBreastfeeding on newStartedARTs.person_id = tBreastfeeding.person_id
inner join (
select person_id as pidd, arvreceivedbefore , gender as 'sex' from (  
select obs.person_id, obs.concept_id, obs.obs_datetime  , obs.encounter_id , obs.value_coded as 'arvreceivedbefore', obs.voided, gender from obs obs
left join person p on obs.person_id = p.person_id
where obs.concept_id =
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs.obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and obs.value_coded = 2 and obs.voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and
 obs_datetime <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPersonsEverStartedCtx on tnewStartedARTs.pid = tPersonsEverStartedCtx.pidd
union all
select 'Total Number of Clients Taking Dapsone',
count(distinct(case when pid is not null and gender = 'M' and date_activated > DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#') - INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pid end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Male',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#'- INTERVAL 1 MONTH,'%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#') - INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pid end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Female',
count(distinct(case when pid is not null and gender in ('M','F') and date_activated > DATE_FORMAT('#startDate#'- INTERVAL 1 MONTH,'%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#')- INTERVAL 1 MONTH,'%Y-%m-%d 23:59:59')) then pid end)) as 'Cumulative number of persons ever started on ART at this facility\nat the end of the previous reporting period\n Total',
count(distinct(case when pid is not null and gender = 'M' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Male',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n  Female',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) and edd > '#endDate#' then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Pregnant',
count(distinct(case when pid is not null and gender = 'F' and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) and isBreastfeeding is not null then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\n Breastfeeding',
count(distinct(case when pid is not null and gender in ('M','F') and date_activated > DATE_FORMAT('#startDate#','%Y-%m-01') and date_activated <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) then pid end)) as 'New persons started on ART at this facility\nduring the reporting period (Month)\nTotal',
count(distinct(case when pidd is not null and sex = 'M' then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\nMale',
count(distinct(case when pidd is not null and sex = 'F' then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\nFemale',
count(distinct(case when pidd is not null and sex in ('F','M') then pidd end)) as 'Cumulative number of persons ever started on ART at this facility\nat end of the current reporting  period (Month)\n Total'
from (
select person_id, arvreceivedbefore , gender from (  
select obs.person_id, obs.concept_id, obs.obs_datetime  , obs.encounter_id , obs.value_coded as 'arvreceivedbefore', obs.voided, gender from obs obs
left join person p on obs.person_id = p.person_id
where obs.concept_id =
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs.obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and obs.value_coded = 2 and obs.voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and
 obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)newStartedARTs
inner join(
select distinct(pid), firstregimen , date_activated from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'firstregimen' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'Dapsone Drugs' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 )  
order by patient_id, date_activated) b where row_num = 1
)tfirstlinereg
)tnewStartedARTs on newStartedARTs.person_id = tnewStartedARTs.pid
left join
(
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT('#endDate#','%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIpregnant on newStartedARTs.person_id = tIpregnant.person_id
left join (
select person_id, edd from (  
select person_id, concept_id, obs_datetime as 'edd' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT('#endDate#','%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate
)tEdd on newStartedARTs.person_id = tEdd.person_id
left join(
select person_id, isBreastfeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isBreastfeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT('#endDate#','%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tBreastfeeding on newStartedARTs.person_id = tBreastfeeding.person_id
inner join (
select person_id as pidd, arvreceivedbefore , gender as 'sex' from (  
select obs.person_id, obs.concept_id, obs.obs_datetime  , obs.encounter_id , obs.value_coded as 'arvreceivedbefore', obs.voided, gender from obs obs
left join person p on obs.person_id = p.person_id
where obs.concept_id =
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs.obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and obs.value_coded = 2 and obs.voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and
 obs_datetime <= (DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')) group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPersonsEverStartedCtx on tnewStartedARTs.pid = tPersonsEverStartedCtx.pidd





 