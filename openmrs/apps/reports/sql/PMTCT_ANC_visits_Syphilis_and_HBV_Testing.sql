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
    CASE WHEN birthdate is null and gender = 'F' and visitNumberResult is not null THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and visitNumberResult is not null) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and visitNumberResult is not null) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50 and gender = 'F'and visitNumberResult is not null) THEN 1 END overFifty,
    CASE WHEN birthdate is not null and gender = 'F' and visitNumberResult is not null THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_coded AS 'visitNumberResult' , obs_datetime FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Visit Number" and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
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
    CASE WHEN  birthdate is null and gender = 'F' and visitResult = "1 = First Contact" THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50 and gender = 'F' and visitResult = "1 = First Contact") THEN 1 END overFifty,
    CASE WHEN birthdate is not null and (gender = 'F' and visitResult = "1 = First Contact") THEN 1 END totalAll
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
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
    CASE WHEN  birthdate is null and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END overFifty,
    CASE WHEN birthdate is not null and (gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult in ("Positive","Negative")) THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
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
    CASE WHEN  birthdate is null and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive" THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50 and gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END overFifty,
    CASE WHEN birthdate is not null and (gender = 'F' and visitResult = "1 = First Contact" and rprvdrlResult = "Positive") THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
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
    CASE WHEN  birthdate is null and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative") THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50  and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END overFifty,
    CASE WHEN birthdate is not null and (gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult in ("Positive","Negative")) THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
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
    CASE WHEN  birthdate is null and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive" THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50 and gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END overFifty,
    CASE WHEN birthdate is not null and (gender = 'F' and visitResult not in ("1 = First Contact") and rprvdrlResult = "Positive") THEN 1 END totalAll
   
  FROM person pn 
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="Visit Number" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id) 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId',(select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'rprvdrlResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="RPR/VDRL" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr1 ON (pr1.visitPatientId = pn.person_id)
  ) p

UNION ALL

select 
'Attending ANC four visits' as 'Title',
count(distinct(case when personid is not null and Age is null and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as 'Unknown age',
count(distinct(case when personid is not null and Age >= 10 and Age < 15 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '10 - 14 YRS',
count(distinct(case when personid is not null and Age >= 15 and Age < 20 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '15 - 19 YRS',
count(distinct(case when personid is not null and Age >= 20 and Age < 25 and visitNumber = 'Fourth Visit' and gender = 'F' then personid end)) as '20 - 24 YRS',
count(distinct(case when personid is not null and Age >= 25 and Age < 30 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '25 - 29 YRS',
count(distinct(case when personid is not null and Age >= 30 and Age < 35 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '30 - 34 YRS',
count(distinct(case when personid is not null and Age >= 35 and Age < 40 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '35 - 39 YRS',
count(distinct(case when personid is not null and Age >= 40 and Age < 45 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '40 - 44 YRS',
count(distinct(case when personid is not null and Age >= 45 and Age < 50 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '45 - 49 YRS',
count(distinct(case when personid is not null and Age >= 50 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as '50+ YRS',
count(distinct(case when personid is not null and Age >= 10 and visitNumber = 'Fourth Visit' and gender = 'F'  then personid end)) as 'Total'
from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'TypeofPatient') and pa.value  in ((select concept_id from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED'),(select concept_id from concept_name where name = 'ExistingPatient' and concept_name_type = 'FULLY_SPECIFIED'),
(select concept_id from concept_name where name = 'Transfer-In' and concept_name_type = 'FULLY_SPECIFIED')) and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created >= '#startDate#' and  ob.date_created <= (DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')) 
)tDemographics
inner join (
select pid , tConceptname.name as 'visitNumber' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Visit Number' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Visit Number' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tMaternityVisitNumber on tDemographics.personid = tMaternityVisitNumber.pid

UNION ALL

select 
'Attending ANC more than four visits' as 'Title',
count(distinct(case when personid is not null and Age is null and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as 'Unknown age',
count(distinct(case when personid is not null and Age >= 10 and Age < 15 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '10 - 14 YRS',
count(distinct(case when personid is not null and Age >= 15 and Age < 20 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '15 - 19 YRS',
count(distinct(case when personid is not null and Age >= 20 and Age < 25 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F' then personid end)) as '20 - 24 YRS',
count(distinct(case when personid is not null and Age >= 25 and Age < 30 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '25 - 29 YRS',
count(distinct(case when personid is not null and Age >= 30 and Age < 35 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '30 - 34 YRS',
count(distinct(case when personid is not null and Age >= 35 and Age < 40 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '35 - 39 YRS',
count(distinct(case when personid is not null and Age >= 40 and Age < 45 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '40 - 44 YRS',
count(distinct(case when personid is not null and Age >= 45 and Age < 50 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '45 - 49 YRS',
count(distinct(case when personid is not null and Age >= 50 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as '50+ YRS',
count(distinct(case when personid is not null and Age >= 10 and visitNumber in ('Fifth Visit','Sixth Visit','Seventh Visit','Eighth Visit','Ninth Visit') and gender = 'F'  then personid end)) as 'Total'
from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'TypeofPatient') and pa.value  in ((select concept_id from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED'),(select concept_id from concept_name where name = 'ExistingPatient' and concept_name_type = 'FULLY_SPECIFIED'),
(select concept_id from concept_name where name = 'Transfer-In' and concept_name_type = 'FULLY_SPECIFIED')) and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created >= '#startDate#' and  ob.date_created <= (DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')) 
)tDemographics
inner join (
select pid , tConceptname.name as 'visitNumber' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Visit Number' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Visit Number' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tMaternityVisitNumber on tDemographics.personid = tMaternityVisitNumber.pid



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
    CASE WHEN birthdate is null and gender = 'F' and visitNumberResult is not null THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and visitNumberResult is not null) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and visitNumberResult is not null) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50 and gender = 'F'and visitNumberResult is not null) THEN 1 END overFifty,
    CASE WHEN birthdate is not null and gender = 'F' and visitNumberResult is not null THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'visitNumberResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HBV" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
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
    CASE WHEN  birthdate is null and gender = 'F' and hbvResult = "Positive" THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 10 and 14 and gender = 'F' and hbvResult = "Positive") THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 15 and 19 and gender = 'F' and hbvResult = "Positive") THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 20 and 24 and gender = 'F' and hbvResult = "Positive") THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 25 and 29 and gender = 'F' and hbvResult = "Positive") THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 30 and 34 and gender = 'F' and hbvResult = "Positive") THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 35 and 39 and gender = 'F' and hbvResult = "Positive") THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 40 and 44 and gender = 'F' and hbvResult = "Positive") THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') between 45 and 49 and gender = 'F' and hbvResult = "Positive") THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, '#endDate#') >= 50 and gender = 'F' and hbvResult = "Positive") THEN 1 END overFifty,
    CASE WHEN  birthdate is not null and gender = 'F' and hbvResult = "Positive" THEN 1 END totalAll
   
  FROM person pn 
  JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'hbvResult' FROM obs o 
  JOIN concept_name cnr ON (cnr.concept_name_type = "FULLY_SPECIFIED" AND cnr.voided is false AND cnr.name="HBV" and o.concept_id = cnr.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id where obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS pr ON (pr.visitPatientId = pn.person_id)
) p
