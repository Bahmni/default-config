-- ANC Partner Index contact HIV Counseling and testing

SELECT
  'Couples Pre-test counseled jointly' as 'Title',
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
  'Partners who had HIV testing' as 'Title',
  count(unkownage) as 'Unknown age',
  count(tenTofourteen) as '10-14 YRS',
  count(fifteenTonineteen) as '15-19 YRS',
  count(twentyTotwentyfour) as '20-24 YRS',
  count(twentyfiveTotwentynine) as '25-29 YRS',
  count(thirtyTothirtyfour) as '30-34 YRS',
  count(thirtyfiveTothirtynine) as '35-39 YRS',
  count(fourtyToFourtyfour) as '40-44 YRS',
  count(fourtyfiveToFourtynine) as '45-49 YRS',
  count(overFifty) as '50+ YRS',
  count(totalAll) as 'Total'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult in ("Positive","Negative") and enrollmentResult is not null) THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'sexResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Sexual Partner?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'sexPaResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Sexual Partner Relationship" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'famARTResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Is Family Member in ART Care?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS kr ON (kr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'famStatusResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Family Member - HIV Status" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS fr ON (fr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'negpostResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Result" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS nr ON (nr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'enrollmentDate', o.value_datetime AS 'enrollmentResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date Tested HIV" and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS dr ON (dr.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Partners testing HIV positive' as 'Title',
  count(unkownage) as 'Unknown age',
  count(tenTofourteen) as '10-14 YRS',
  count(fifteenTonineteen) as '15-19 YRS',
  count(twentyTotwentyfour) as '20-24 YRS',
  count(twentyfiveTotwentynine) as '25-29 YRS',
  count(thirtyTothirtyfour) as '30-34 YRS',
  count(thirtyfiveTothirtynine) as '35-39 YRS',
  count(fourtyToFourtyfour) as '40-44 YRS',
  count(fourtyfiveToFourtynine) as '45-49 YRS',
  count(overFifty) as '50+ YRS',
  count(totalAll) as 'Total'

FROM (
 SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "True" and famStatusResult = "Known" and negpostResult = "Positive") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'sexResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Sexual Partner?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'sexPaResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Sexual Partner Relationship" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'famARTResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Is Family Member in ART Care?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS kr ON (kr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'famStatusResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Family Member - HIV Status" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS fr ON (fr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'negpostResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Result" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS nr ON (nr.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Partners with discordant results' as 'Title',
  count(unkownage) as 'Unknown age',
  count(tenTofourteen) as '10-14 YRS',
  count(fifteenTonineteen) as '15-19 YRS',
  count(twentyTotwentyfour) as '20-24 YRS',
  count(twentyfiveTotwentynine) as '25-29 YRS',
  count(thirtyTothirtyfour) as '30-34 YRS',
  count(thirtyfiveTothirtynine) as '35-39 YRS',
  count(fourtyToFourtyfour) as '40-44 YRS',
  count(fourtyfiveToFourtynine) as '45-49 YRS',
  count(overFifty) as '50+ YRS',
  count(totalAll) as 'Total'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and sexPaResult = "Spouse" and sexResult = "True" and famARTResult = "False" and famStatusResult = "Known" and negpostResult = "Negative") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'sexResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Sexual Partner?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'sexPaResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Sexual Partner Relationship" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'famARTResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Is Family Member in ART Care?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS kr ON (kr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'famStatusResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Family Member - HIV Status" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS fr ON (fr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'negpostResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Result" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS nr ON (nr.visitPatientId = pn.person_id)
  ) p
  
UNION ALL

 select 
'Index Case Contact Tested' as 'Title',
count(distinct(case when Names is not null and ContactsAge is null and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as 'Unknown age',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '10 - 14 YRS',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '15 - 19 YRS',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES' and PatnerGender in ('M','F') then Names end)) as '20 - 24 YRS',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '25 - 29 YRS',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '30 - 34 YRS',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 40 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '35 - 39 YRS',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '40 - 44 YRS',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '45 - 49 YRS',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '50+ YRS',
count(distinct(case when Names is not null and ContactsAge >= 10 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as 'Total'

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

UNION ALL

select 
'Index Case contacts positive'as'Title',
count(distinct(case when Names is not null and ContactsAge is null and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as 'Unknown age',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '10 - 14 YRS',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '15 - 19 YRS',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F') then Names end)) as '20 - 24 YRS',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '25 - 29 YRS',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '30 - 34 YRS',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 40 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '35 - 39 YRS',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '40 - 44 YRS',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '45 - 49 YRS',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '50+ YRS',
count(distinct(case when Names is not null and ContactsAge >= 10 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as 'Total'

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