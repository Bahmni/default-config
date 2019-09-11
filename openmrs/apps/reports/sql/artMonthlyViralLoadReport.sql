-- ART Monthly Report - Viral Load

SELECT
  '<1 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '1-4 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 1 and 4 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '5-9 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '10-14 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '15-19 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '20-24 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '25-29 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '30-34 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '35-39 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '40-49 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 49 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
  '50+ YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 50 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
) p 

UNION ALL

SELECT
'Total' as 'Age_Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (gender = 'M' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (gender = 'M' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id) 
	where birthdate is not NULL
) p  

UNION ALL

SELECT
'Pregnant' as 'Age_Group',
  '' as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  '' as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  '' as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  '' as 'Clients with high VL\n (≥11000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (≥11000copies/ml) Traced \n Female'
FROM (
  SELECT
    CASE WHEN (pregnant = 1 and gender = 'F' and MONTH(viralSampleDate) < MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (pregnant = 1 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (pregnant = 1 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (pregnant = 1 and gender = 'F' and MONTH(vlResultDate) < MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 11000) THEN 1 END femaleGenderResultCollected11000
  FROM person 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'viralSampleDate' FROM obs o 
	JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date VL Sample Collected?" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vl ON (vl.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.obs_datetime AS 'vlResultDate', o.value_numeric AS 'vlResult' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="VL Results" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'pregnant' FROM obs o JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Malaria, Pregnant" and o.concept_id = cn.concept_id) 
	JOIN encounter enc ON enc.encounter_id = o.encounter_id 
	JOIN visit v ON v.visit_id = enc.visit_id  
	GROUP BY v.patient_id 
	ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = person_id)
) p;
