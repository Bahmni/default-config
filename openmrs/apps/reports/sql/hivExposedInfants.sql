-- HIV-exposed Infants Monthly Report
SELECT
  'Number of New HIV-Exposed Infants Enrolled' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2 and gender = 'M' and MONTH(enrollmentDate) = MONTH(CURDATE()) AND YEAR(enrollmentDate) = YEAR(CURDATE()) and enrollmentResult is not null) THEN 1 END maleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2 and gender = 'F' and MONTH(enrollmentDate) = MONTH(CURDATE()) AND YEAR(enrollmentDate) = YEAR(CURDATE()) and enrollmentResult is not null) THEN 1 END femaleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2 and MONTH(enrollmentDate) = MONTH(CURDATE()) AND YEAR(enrollmentDate) = YEAR(CURDATE()) and enrollmentResult is not null) THEN 1 END totalAll 
  FROM visit v
  JOIN person pn on pn.person_id = v.patient_id 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'enrollmentDate', o.value_coded AS 'enrollmentResult' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Entry Point(Enrollement)" 
	and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
) p 

UNION ALL

SELECT
  'Number of HIV-Exposed Infants seen (New And Old)' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M' and enrollmentResult is not null)  THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and enrollmentResult is not null)  THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and enrollmentResult is not null)  THEN 1 END totalAll
  FROM visit v 
  JOIN person pn on pn.person_id = v.patient_id
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'enrollmentDate', o.value_coded AS 'enrollmentResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Entry Point(Enrollement)" 
  and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
   'PCR test received for Total HIV-Exposed Infants Upto 2 Months' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END totalAll 
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

SELECT
   'PCR test received for Total HIV-Exposed Infants Upto 2-12 Months' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END totalAll 
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

SELECT
   'PCR test received for Total HIV-Exposed Infants Upto 12-18 Months' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 12 and 18) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 12 and 18) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 12 and 18) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and pcrDateResult is not null and MONTH(heiResultDate) = MONTH(CURDATE()) AND YEAR(heiResultDate) = YEAR(CURDATE()) and heiResult = "HEI Results Positive") THEN 1 END totalAll 
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

SELECT
   'Total HIV-Exposed Infants this Month who where started on Cotrimoxazole' as 'Title',
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

SELECT
   '(ARV Prophylaxils) Number HIV-exposed infants received NVP' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and nvpDateResult is not null and MONTH(nvpResultDate) = MONTH(CURDATE()) AND YEAR(nvpResultDate) = YEAR(CURDATE()) and nvpResult = "Daily NVP") THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and nvpDateResult is not null and MONTH(nvpResultDate) = MONTH(CURDATE()) AND YEAR(nvpResultDate) = YEAR(CURDATE()) and nvpResult = "Daily NVP") THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and nvpDateResult is not null and MONTH(nvpResultDate) = MONTH(CURDATE()) AND YEAR(nvpResultDate) = YEAR(CURDATE()) and nvpResult = "Daily NVP" ) THEN 1 END totalAll 
  FROM person pn 
  LEFT JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  LEFT JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_datetime AS 'nvpDateResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Daily NVP Date" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'nvpResultDate', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'nvpResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Infant's PMTCT ARVS" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
 ) p

UNION ALL

SELECT
   '(ARV Prophylaxils) Number HIV-exposed infants received AZT+NVP' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult = "AZT+NV") THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult = "AZT+NV" ) THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult = "AZT+NV" ) THEN 1 END totalAll 
  FROM person pn 
  LEFT JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  LEFT JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_datetime AS 'aztnvpDateResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="AZT+NV Date" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'aztnvpResultDate', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'aztnvpResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Infant's PMTCT ARVS" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
 ) p
 
 UNION ALL
 
SELECT
   'Number HIV-exposed infants received ARV Prophylaxils (NVP and AZT+NVP)' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'M' and  MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult  in ("AZT+NV", "Daily NVP")) THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult  in ("AZT+NV", "Daily NVP")) THEN 1 END femaleGender,
   CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult  in ("AZT+NV", "Daily NVP")) THEN 1 END totalAll 	
  FROM person pn 
  LEFT JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  LEFT JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_datetime AS 'aztnvpDateResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name IN ("AZT+NV Date", "Daily NVP Date") AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'aztnvpResultDate', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'aztnvpResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Infant's PMTCT ARVS" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
 ) p