SELECT 
    first_answers.answer_name AS 'ICD name',
    first_answers.icd10_code AS 'ICD CODE',
IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '≤ 28 Days'  THEN 1 ELSE 0  END), 0) AS 'F ≤ 28 Days',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '≤ 28 Days'  THEN 1 ELSE 0  END), 0) AS 'M ≤ 28 Days',


IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '29 Days ‐ 1 Year'  THEN 1 ELSE 0  END), 0) AS 'F 29 Days ‐ 1 Year',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '29 Days ‐ 1 Year' THEN 1 ELSE 0  END), 0) AS 'M 29 Days ‐ 1 Year',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '01 ‐ 04 Years'  THEN 1 ELSE 0  END), 0) AS 'F 01 ‐ 04 Years',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '01 ‐ 04 Years'  THEN 1 ELSE 0  END), 0) AS 'M 01 ‐ 04 Years',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '05 ‐ 14 years'  THEN 1 ELSE 0  END), 0) AS 'F 05 ‐ 14 years',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '05 ‐ 14 years'  THEN 1 ELSE 0  END), 0) AS 'M 05 ‐ 14 years',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '15 ‐ 19 Years'  THEN 1 ELSE 0  END), 0) AS 'F 15 ‐ 19 Years',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '15 ‐ 19 Years'  THEN 1 ELSE 0  END), 0) AS 'M 15 ‐ 19 Years',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '20 ‐ 29 Years'  THEN 1 ELSE 0  END), 0) AS 'F 20 ‐ 29 Years',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '20 ‐ 29 Years'  THEN 1 ELSE 0  END), 0) AS 'M 20 ‐ 29 Years',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '30 ‐ 39 Years'  THEN 1 ELSE 0  END), 0) AS 'F 30 ‐ 39 Years',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '30 ‐ 39 Years'  THEN 1 ELSE 0  END), 0) AS 'M 30 ‐ 39 Years',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '40 ‐ 49 Years'  THEN 1 ELSE 0  END), 0) AS 'F 40 ‐ 49 Years',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '40 ‐ 49 Years'  THEN 1 ELSE 0  END), 0) AS 'M 40 ‐ 49 Years',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '50 ‐ 59 Years'  THEN 1 ELSE 0  END), 0) AS 'F ≤ 28 Days',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '50 ‐ 59 Years'  THEN 1 ELSE 0  END), 0) AS 'M 50 ‐ 59 Years',

IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '≥ 60 Years'  THEN 1 ELSE 0  END), 0) AS 'F ≥ 60 Years',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL and second_concept.age_grp = '≥ 60 Years'  THEN 1 ELSE 0  END), 0) AS 'M ≥ 60 Years',
   combo_id
FROM
    (SELECT 
        concept_full_name AS answer_name, icd10_code
    FROM
        diagnosis_concept_view 
 ) first_answers
        INNER JOIN
   (SELECT DISTINCT
        p.person_id,
        dhis_map.attr_option_combo_id as combo_id,
            dcv.concept_full_name,
            p.gender AS gender,
            icd10_code,
            p.birthdate,
            TIMESTAMPDIFF(YEAR, p.birthdate, v.date_started) AS age
    FROM
        person p
    INNER JOIN visit v ON p.person_id = v.patient_id
        AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id
        AND o.voided = 0
        AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
        AND cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.name = 'Coded Diagnosis'
        AND o.voided = 0
        AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded
    join dhis2_icd_map dhis_map on dcv.icd10_code = dhis_map.icd_code
    WHERE
        p.voided = 0) first_concept  ON first_concept.icd10_code = first_answers.icd10_code
		
		join 
		(SELECT DISTINCT
                person.person_id AS person_id,
                rag.name as age_grp,
                person.gender as gender
            FROM
                obs
            INNER JOIN concept_view question ON obs.concept_id = question.concept_id
                AND question.concept_full_name IN ('Discharge note, Inpatient outcome')
            INNER JOIN person ON obs.person_id = person.person_id
            INNER JOIN encounter ON obs.encounter_id = encounter.encounter_id
            INNER JOIN visit ON encounter.visit_id = visit.visit_id
			
			INNER JOIN reporting_age_group rag ON DATE(visit.date_started) BETWEEN (DATE_ADD(
                     DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days DAY)) AND (DATE_ADD(
                     DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
                                                       AND rag.report_group_name = 'Inpatient'
            WHERE CAST(obs.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#') second_concept on first_concept.person_id = second_concept.person_id
GROUP BY first_answers.icd10_code 
ORDER BY first_answers.icd10_code