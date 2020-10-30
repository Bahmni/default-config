-- ANC Visits, Syphilis and HBV Testing

SELECT
  'Total ANC Visits' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitNumberResult is not null) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitNumberResult is not null) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitNumberResult is not null) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F'and visitNumberResult is not null) THEN 1 END overFifty,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitNumberResult is not null) THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'visitNumberResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Visit Number" and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
  'First ANC visits' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult = "1 = Second Contact") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  ) p

UNION ALL

SELECT
  'First ANC Mothers tested for Syphilis' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'First ANC Mothers testing Syphilis positive' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult = "1 = Second Contact" and rprvdrlResult = "Positive") THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Mothers tested for Syphilis (None First ANC visit mothers)' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Mothers testing Syphilis positive (None First ANC visit mothers)' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult not in ("1 = Second Contact") and rprvdrlResult = "Positive") THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Attending ANC four visits' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult = "4 = Fourth Contact") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  ) p

UNION ALL

SELECT
  'Attending ANC more than four visits' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult in ("5 = Fifth Contact","6 = Sixth Contact","7 = Seventh Contact","8 = Eight Contact","9 = Eight Contact")) THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  ) p

UNION ALL

SELECT
  'Mothers tested for HBV ' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitNumberResult is not null) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitNumberResult is not null) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitNumberResult is not null) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F'and visitNumberResult is not null) THEN 1 END overFifty,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitNumberResult is not null) THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_text AS 'visitNumberResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Hepatitis - B Sample" and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
  'Mothers tested HBV Positive' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END overFifty,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and hepBResult is not null and visitNumberResult is not null  and rprvdrlResult = "Positive") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_text AS 'hepBResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Hepatitis - B Sample" and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'visitNumberResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Visit Number" and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr1 ON (vr1.visitPatientId = pn.person_id)
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
  'Known positive status (at entry into) - ANC' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and entrypoint = "ANC Clinic") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'entrypoint' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV - Entry Point" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  ) p

UNION ALL

SELECT
  'Known positive status at entry into ANC on ART' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and entrypoint = "ANC Clinic" and artResult = "True") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'entrypoint' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV - Entry Point" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'artResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Transferred in on ART?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Women of unknown status tested for HIV (1st ANC Visit)' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult is not null) THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'hivSampleResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV Sample" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
  'Women of unknown status testing HIV positive (1st ANC visit)' as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'hivSampleResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV Sample" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p
  
UNION ALL
  
SELECT
  'Total of HIV Positive women \n attending ANC (a+b)'as 'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and entrypointhiv = "ANC Clinic" and visitResult = "1 = Second Contact" and hivSampleResult ="Positive") THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'entrypointhiv' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV - Entry Point" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS hr ON (hr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'hivSampleResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV Sample" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
 'HIV infected pregnant women newly started on ART (Option B+)'as'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and entrypoint not in ("ANC Clinic") and artResult = "True" and arvsResult = "True") THEN 1 END totalAll

  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'entrypoint' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV - Entry Point" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'artResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Transferred in on ART?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'arvsResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Were ARVS Received?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS ar ON (ar.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
 'Total of HIV Positive \n Pregnant women enrolled in PMTCT'as'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" and pmtcrResult = "True") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'entrypoint' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV - Entry Point" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="FP Pregnant" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pmtcrResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="PMTCT - HIV & ART Follow up" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS ar ON (ar.visitPatientId = pn.person_id)
  ) p

UNION ALL

SELECT
 'Known positive status on ART Breastfeeding 'as'Title',
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
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True" ) THEN 1 END overFifty,
    CASE WHEN (gender = 'F' and entrypoint not in ("ANC Clinic") and pregResult = "True") THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'entrypoint' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HIV - Entry Point" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id 
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'pregResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Currently Breastfeeding?" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
  ) p