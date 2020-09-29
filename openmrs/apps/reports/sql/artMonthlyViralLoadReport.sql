-- ART Monthly Report - Viral Load

SELECT
  '<1 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  '1-4 YRS' as 'Age Group',
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 5 and 9 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 54 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
  count(maleGenderSampleCollected) as 'Sample Collected\n Male',
  count(femaleGenderSampleCollected) as 'Sample Collected\n Female',
  count(pregnantWomensSampleCollected) as 'Sample Collected\n Pregnant',
  count(breastFeedingWomensSampleCollected) as 'Sample Collected\n Breastfeeding',
  count(totalSampleCollected) as 'Sample Collected\n Total',
  count(maleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Male',
  count(femaleGenderResultCollected999) as 'Results Received\n <1000 copies/ml \n Female',
  count(pregnantWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected999) as 'Results Received\n <1000 copies/ml \n Breastfeeding',
  count(totalResultCollected999) as 'Results Received\n <1000 copies/ml \n Total',
  count(maleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Male',
  count(femaleGenderResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Female',
  count(pregnantWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Pregnant',
  count(breastFeedingWomensResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Breastfeeding',
  count(totalResultCollected1000) as 'Results Received\n >=1000 copies/ml \n Total',
  count(maleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Male',
  count(femaleGenderResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Female',
  count(pregnantWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Pregnant',
  count(breastFeedingWomensResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Breastfeeding',
  count(totalResultCollected11000) as 'Clients with high VL\n (>=1000copies/ml) Traced \n Total'
FROM (
  SELECT
    CASE WHEN (gender = 'M' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END maleGenderSampleCollected,
    CASE WHEN (gender = 'F' and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END femaleGenderSampleCollected,
    CASE WHEN (gender = 'F' and pregnant=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END pregnantWomensSampleCollected,
    CASE WHEN (gender = 'F' and breastFeeding=1 and MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomensSampleCollected,
    CASE WHEN (MONTH(viralSampleDate) = MONTH(CURDATE()) AND YEAR(viralSampleDate) = YEAR(CURDATE())) THEN 1 END totalSampleCollected,
    CASE WHEN (gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END maleGenderResultCollected999,
    CASE WHEN (gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END femaleGenderResultCollected999,
    CASE WHEN (gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END pregnantWomensResultCollected999,
    CASE WHEN (gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END breastFeedingWomensResultCollected999,
    CASE WHEN (MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult  < 1000) THEN 1 END totalResultCollected999,
    CASE WHEN (gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected1000,
    CASE WHEN (gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected1000,
    CASE WHEN (gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected1000,
    CASE WHEN (gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected1000,
    CASE WHEN (MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected1000,
    CASE WHEN (gender = 'M' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END maleGenderResultCollected11000,
    CASE WHEN (gender = 'F' and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END femaleGenderResultCollected11000,
    CASE WHEN (gender = 'F' and pregnant=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END pregnantWomensResultCollected11000,
    CASE WHEN (gender = 'F' and breastFeeding=1 and MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END breastFeedingWomensResultCollected11000,
    CASE WHEN (MONTH(vlResultDate) = MONTH(CURDATE()) AND YEAR(vlResultDate) = YEAR(CURDATE()) and vlResult >= 1000) THEN 1 END totalResultCollected11000
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
) p; 
