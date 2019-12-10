-- Number of PMTCT Clients who received ART during  this reporting period by Regimen (Current on OptionB+)

SELECT
  'Adult 1st Line Regimens:' as 'Regimen',
  'M' as '<10 Male',
  'F' as '<10 Female',
  'M' as'10-15 Male' ,
  'F' as'10-15 Female',
  'M' as '15-49 Male',
  'F' as '15-49 Female',
  'M' as '50+ Male',
  'F' as '50+ Female',
  '' as 'Total',
  '' as'BreastFeeding',
  '' as 'Pregnant'
  From DUAL

UNION All

SELECT
  '1a = AZT/3TC+ EFV' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1a") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1a") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1a") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1a") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1a") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1a") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1a") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1a") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1a") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1a" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1a" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
  '1b = AZT/3TC/NVP' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1b") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1b") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1b") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1b") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1b") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1b") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1b") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1b") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1b") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1b" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1b" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '1c = TDF/3TC/DTG' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1c") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1c") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1c") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1c") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1c") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1c") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1c") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1c") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1c") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1c" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1c" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '1d = ABC/3TC (600/300) /DTG' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1d") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1d") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1d") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1d") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1d") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1d") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1d") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1d") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1d") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1d" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1d" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '1e = AZT/3TC + DTG' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1e") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1e") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1e") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1e") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1e") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1e") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1e") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1e") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1e") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1e" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1e" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '1f  = TDF/3TC/EFV' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1f") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1f") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1f") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1f") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1f") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1f") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1f") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1f") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1f") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1f" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1f" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '1g = TDF/3TC+NVP' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1g") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1g") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1g") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1g") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1g") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1g") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1g") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1g") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1g") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1g" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1g" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '1h = TDF/FTC/ EFV' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1h") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1h") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1h") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1h") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1h") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1h") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1h") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1h") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1h") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1h" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1h" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '1J  = TDF/FTC+NVP' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "1j") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "1j") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "1j") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "1j") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "1j") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "1j") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "1j") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "1j") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "1j") THEN 1 END totalAll,
    CASE WHEN (arvResult = "1j" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "1j" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Adult 2nd Line Regimens:' as 'Regimen',
  '' as '<10 Male',
  '' as '<10 Female',
  '' as'10-15 Male' ,
  '' as'10-15 Female',
  '' as '15-49 Male',
  '' as '15-49 Female',
  '' as '50+ Male',
  '' as '50+ Female',
  '' as 'Total',
  '' as'BreastFeeding',
  '' as 'Pregnant'
From DUAL

UNION ALL

SELECT
  '2a = AZT/3TC + DTG' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2a") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2a") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2a") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2a") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2a") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2a") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2a") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2a") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2a") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2a" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2a" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2b = ABC/3TC + DTG' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2b") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2b") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2b") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2b") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2b") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2b") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2b") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2b") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2b") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2b" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2b" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2c = TDF+3TC+LPV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2c") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2c") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2c") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2c") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2c") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2c") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2c") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2c") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2c") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2c" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2c" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2d = TDF/3TC+ATV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2d") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2d") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2d") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2d") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2d") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2d") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2d") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2d") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2d") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2d" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2d" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2e = TDF/FTC-LPV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2e") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2e") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2e") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2e") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2e") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2e") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2e") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2e") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2e") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2e" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2e" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2f = TDF/FTC-ATV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2f") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2f") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2f") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2f") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2f") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2f") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2f") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2f") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2f") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2f" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2f" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2g = AZT/3TC+LPV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2g") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2g") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2g") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2g") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2g") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2g") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2g") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2g") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2g") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2g" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2g" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2h = AZT/3TC+ATV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2h") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2h") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2h") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2h") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2h") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2h") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2h") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2h") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2h") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2h" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2h" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2i = ABC/3TC + LPV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2i") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2i") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2i") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2i") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2i") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2i") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2i") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2i") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2i") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2i" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2i" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2J = ABC/3TC + ATV/r' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2j") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2j") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2j") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2j") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2j") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2j") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2j") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2j") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2j") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2j" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2j" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  '2k = TDF/3TC/DTG' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and arvResult = "2k") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and arvResult = "2k") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and arvResult = "2k") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and arvResult = "2k") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and arvResult = "2k") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and arvResult = "2k") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and arvResult = "2k") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and arvResult = "2k") THEN 1 END overFiftyfemale,
    CASE WHEN (arvResult = "2k") THEN 1 END totalAll,
    CASE WHEN (arvResult = "2k" and bresResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (arvResult = "2k" and pregResult = "True") THEN 1 END Pregnant
 
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="ARV Regimen" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  Left JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'bresResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr2 ON (pr2.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'No signs of TB' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END overFiftyfemale,
    CASE WHEN (cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END totalAll,
    CASE WHEN (cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END breastfeeding,
    CASE WHEN (cuCoughResult = "False" and tbFeverResult = "False" and tbWeightResult = "False" and tbNightsResult = "False") THEN 1 END Pregnant
FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'cuCoughResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Current Cough" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS cr ON (cr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbFeverResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Fever" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS fr ON (fr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbWeightResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening ,Weight loss" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS wr ON (wr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbNightsResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Night Sweats" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS nr ON (nr.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
  'Presumptive TB case' as 'Regimen',
  count(belowtenmale) as '<10 Male',
  count(belowtenfemale) as '<10 Female',
  count(tenTofifteenmale) as '10-15 Male',
  count(tenTofifteenfemale) as '10-15 Female',
  count(fifteenTOfourtyninemale) as '15-49 Male',
  count(fifteenTOfourtyninefemale) as '15-49 Female',
  count(overFiftymale) as '50+ Male',
  count(overFiftyfemale) as '50+ Female',
  count(totalAll) as 'Total',
  count(breastfeeding) as 'BreastFeeding',
  count(pregnant) as 'Pregnant'
FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END belowtenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 10 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END belowtenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END tenTofifteenmale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 15 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END tenTofifteenfemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END fifteenTOfourtyninemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 49 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END fifteenTOfourtyninefemale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'M' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END overFiftymale,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 115 and gender = 'F' and cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END overFiftyfemale,
    CASE WHEN (cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END totalAll,
    CASE WHEN (cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END breastfeeding,
    CASE WHEN (cuCoughResult = "True" and tbFeverResult = "True" and tbWeightResult = "True" and tbNightsResult = "True") THEN 1 END Pregnant
FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'cuCoughResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Current Cough" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS cr ON (cr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbFeverResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Fever" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS fr ON (fr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbWeightResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening ,Weight loss" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS wr ON (wr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'tbNightsResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="TB Screening , Night Sweats" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS nr ON (nr.visitPatientId = pn.person_id)
) p

