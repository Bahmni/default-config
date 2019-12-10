-- ART Monthly Report - New and cumulative number of persons started on ART

SELECT 
  '<1 YRS' as 'Age Group',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END maleGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END femaleGenderPreviousReportingPeriod,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and MONTH(artStartDate) < MONTH(CURDATE())) THEN 1 END totalGenderPreviousReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END maleGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END femaleGenderCurrentReportingPeriod,
    CASE WHEN (pregnant = 1 and TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END pregnantWomens,
    CASE WHEN (breastFeeding = 1 AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END breastFeedingWomens,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and MONTH(artStartDate) = MONTH(CURDATE()) AND YEAR(artStartDate) = YEAR(CURDATE())) THEN 1 END totalGenderCurrentReportingPeriod,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'M' and artStartDate is not NULL) THEN 1 END maleGenderSoFar,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and gender = 'F' and artStartDate is not NULL) THEN 1 END femaleGenderSoFar,
	CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE())< 1 and artStartDate is not NULL) THEN 1 END totalGenderSoFar
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
) p; 
 