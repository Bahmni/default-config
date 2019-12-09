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
  'Number Of HIV-Exposed Infants seen (New And Old)' as 'Title',
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
   'PCR test for HIV-Exposed Infants Upto 2 Months of age' as 'Title',
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
   'PCR test for HIV-Exposed Infants between 2-12 Months of age' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12) and gender = 'M'  and pcrResult is not null and rapidTestresult is not null and secondresult is not null and repeatresult is not null ) THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12) and gender = 'F' and pcrResult is not null and rapidTestresult is not null and secondresult is not null and repeatresult is not null ) THEN 1 END femaleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 2 and 12) and pcrResult is not null and rapidTestresult is not null and secondresult is not null and repeatresult is not null ) THEN 1 END totalAll 
  
  FROM person pn 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_coded AS 'pcrResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="HEI Testing (First PCR Feeding Method)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate2', o.value_coded AS 'rapidTestresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Rapid Test At 9 Months Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
   JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate3', o.value_coded AS 'secondresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Second PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS sr ON (sr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS 'repeatresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Repeat PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS rr ON (rr.visitPatientId = pn.person_id)
 ) p

UNION ALL

SELECT
   'PCR test for HIV-Exposed Infants between 12-18 Months of age' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 12 and 18) and gender = 'M'  and pcrResult is not null and rapidTestresult is not null and secondresult is not null and repeatresult is not null and 18repeatresult is not null) THEN 1 END maleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 12 and 18) and gender = 'F' and pcrResult is not null and rapidTestresult is not null and secondresult is not null and repeatresult is not null and 18repeatresult is not null ) THEN 1 END femaleGender,
    CASE WHEN ( (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 12 and 18) and pcrResult is not null and rapidTestresult is not null and secondresult is not null and repeatresult is not null and 18repeatresult is not null ) THEN 1 END totalAll 
  
  FROM person pn 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_coded AS 'pcrResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="HEI Testing (First PCR Feeding Method)" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate2', o.value_coded AS 'rapidTestresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Rapid Test At 9 Months Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
   JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate3', o.value_coded AS 'secondresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Second PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS sr ON (sr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS 'repeatresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Repeat PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS rr ON (rr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS '18repeatresult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (18Months Rapid Test Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS rs ON (rs.visitPatientId = pn.person_id)
 ) p

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

SELECT
   'Number HIV-exposed infants received NVP' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and nvpDateResult is not null and MONTH(nvpResultDate) = MONTH(CURDATE()) AND YEAR(nvpResultDate) = YEAR(CURDATE()) and nvpResult = "Daily NVP") THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and nvpDateResult is not null and MONTH(nvpResultDate) = MONTH(CURDATE()) AND YEAR(nvpResultDate) = YEAR(CURDATE()) and nvpResult = "Daily NVP") THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and nvpDateResult is not null and MONTH(nvpResultDate) = MONTH(CURDATE()) AND YEAR(nvpResultDate) = YEAR(CURDATE()) and nvpResult = "Daily NVP" ) THEN 1 END totalAll 
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
   'Number HIV-exposed infants received AZT+NVP' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM(
  SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'M' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult = "AZT+NV") THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult = "AZT+NV" ) THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and MONTH(obsDate) = MONTH(CURDATE()) AND YEAR(obsDate) = YEAR(CURDATE()) and aztnvpDateResult is not null and MONTH(aztnvpResultDate) = MONTH(CURDATE()) AND YEAR(aztnvpResultDate) = YEAR(CURDATE()) and aztnvpResult = "AZT+NV" ) THEN 1 END totalAll 
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
  'HIV-exposed infants whose \n feeding practice was assessed' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2 and gender = 'M' and infantFeedResult is not null) THEN 1 END maleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2 and gender = 'F' and infantFeedResult is not null) THEN 1 END femaleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 2 and infantFeedResult is not null) THEN 1 END totalAll 
  FROM visit v
  JOIN person pn on pn.person_id = v.patient_id 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_coded AS 'infantFeedResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Infant Feeding" AND o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  ) p 


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

SELECT
  'Received rapid HIV antibody test 9 months' as 'Title',
  count(maleGender) as 'Male',
  count(femaleGender) as 'Female',
  count(totalAll) as 'Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 9 and gender = 'M' and rapidTestResult is not null) THEN 1 END maleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 9 and gender = 'F' and rapidTestResult is not null) THEN 1 END femaleGender,
    CASE WHEN (TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 9 and rapidTestResult is not null) THEN 1 END totalAll 
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

SELECT
   'Number of children tested HIV-positive' as 'Title',
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
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (18Months Rapid Test  Results)" and o.concept_id = cnr.concept_id) 
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
   'Number of children tested HIV- negative and breastfeeding' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM (
    SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE())  between 0 and 18) and gender = 'M' and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id and pcrResult1 is not null and rapidTestresult1 is not null and secondresult1 is not null and repeatresult1 is not null ) THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id and pcrResult1 is not null and rapidTestresult1 is not null and secondresult1 is not null and repeatresult1 is not null ) THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and  heiResult = cnpr.concept_id and  rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id and pcrResult1 is not null and rapidTestresult1 is not null and secondresult1 is not null and repeatresult1 is not null ) THEN 1 END totalAll 
    FROM person pn 
     JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
    JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient") 
     JOIN concept_name cnpr ON (cnpr.concept_name_type = "FULLY_SPECIFIED" AND cnpr.voided is false AND cnpr.name="HEI Results Positive") 
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
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (18Months Rapid Test  Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id) 
    
   
    JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_coded AS 'pcrResult1' FROM obs o 
    JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="HEI Testing (First PCR Feeding Method)" AND o.concept_id = cn.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
   JOIN visit v ON v.visit_id = enc.visit_id 
   GROUP BY v.patient_id 
   ORDER BY v.visit_id DESC) AS vr1 ON (vr1.visitPatientId = pn.person_id)
   JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate2', o.value_coded AS 'rapidTestresult1' FROM obs o 
   JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Rapid Test At 9 Months Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
   JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate3', o.value_coded AS 'secondresult1' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Second PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS sr1 ON (sr1.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS 'repeatresult1' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Repeat PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS rr1 ON (rr1.visitPatientId = pn.person_id)
 ) p 


UNION ALL

SELECT
   'Number of children tested HIV- negative and no longer breastfeeding' as 'Title',
   count(maleGender) as 'Male',
   count(femaleGender) as 'Female',
   count(totalAll) as 'Total'
  FROM (
    SELECT
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE())  between 0 and 18) and gender = 'M' and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id and heiResult1 = cnpr1.concept_id  and rapidheiResult1 = cnpr1.concept_id and  secondheiResult1 = cnpr1.concept_id and  repeatheiResult1 = cnpr1.concept_id and  eightrapidheiResult1 = cnpr1.concept_id) THEN 1 END maleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and gender = 'F' and heiResult = cnpr.concept_id  and rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id and heiResult1 = cnpr1.concept_id  and rapidheiResult1 = cnpr1.concept_id and  secondheiResult1 = cnpr1.concept_id and  repeatheiResult1 = cnpr1.concept_id and  eightrapidheiResult1 = cnpr1.concept_id) THEN 1 END femaleGender,
    CASE WHEN ((TIMESTAMPDIFF(MONTH, birthdate, CURDATE()) between 0 and 18) and  heiResult = cnpr.concept_id and  rapidheiResult = cnpr.concept_id and  secondheiResult = cnpr.concept_id and  repeatheiResult = cnpr.concept_id and  eightrapidheiResult = cnpr.concept_id and heiResult1 = cnpr1.concept_id  and rapidheiResult1 = cnpr1.concept_id and  secondheiResult1 = cnpr1.concept_id and  repeatheiResult1 = cnpr1.concept_id and  eightrapidheiResult1 = cnpr1.concept_id) THEN 1 END totalAll 
    FROM person pn 
    JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship"))
    JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")  
    JOIN concept_name cnpr ON (cnpr.concept_name_type = "FULLY_SPECIFIED" AND cnpr.voided is false AND cnpr.name="HEI Results Negative") 
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
    JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (18Months Rapid Test  Results)" and o.concept_id = cnr.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
    GROUP BY v.patient_id 
    ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id) 

    JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate', o.value_coded AS 'heiResult1' FROM obs o 
    JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="HEI Testing (First PCR Feeding Method)" AND o.concept_id = cn.concept_id) 
    JOIN encounter enc ON enc.encounter_id = o.encounter_id 
    JOIN visit v ON v.visit_id = enc.visit_id 
   GROUP BY v.patient_id 
   ORDER BY v.visit_id DESC) AS vr1 ON (vr1.visitPatientId = pn.person_id)
   JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate2', o.value_coded AS 'rapidheiResult1' FROM obs o 
   JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Rapid Test At 9 Months Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
   JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate3', o.value_coded AS 'secondheiResult1' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Second PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS sr1 ON (sr1.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS 'repeatheiresult1' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (Repeat PCR Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS rr1 ON (rr1.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'obsDate4', o.value_coded AS 'eightrapidheiResult1' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HEI Testing (18Months Rapid Test Feeding Method)" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr2 ON (vr2.visitPatientId = pn.person_id)
  JOIN concept_name cnpr1 ON (cnpr1.concept_name_type = "FULLY_SPECIFIED" AND cnpr1.voided is false AND cnpr1.name="No longer Breastfeed")
 ) p 


