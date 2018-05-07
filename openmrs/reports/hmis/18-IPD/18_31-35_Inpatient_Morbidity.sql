SELECT 
    first_answers.answer_name AS 'ICD name',
    first_answers.icd10_code AS 'ICD CODE',
    rag.name AS 'Age Group',
    IFNULL(SUM(CASE
                WHEN
                    second_concept.gender = 'F'
                        AND second_concept.person_id IS NOT NULL
                THEN
                    1
                ELSE 0
            END),
            0) AS 'FEMALE PATIENT',
    IFNULL(SUM(CASE
                WHEN
                    second_concept.gender = 'M'
                        AND second_concept.person_id IS NOT NULL
                THEN
                    1
                ELSE 0
            END),
            0) AS 'MALE PATIENT'
FROM
    (SELECT 
        concept_full_name AS answer_name, icd10_code
    FROM
        diagnosis_concept_view
    WHERE
        icd10_code IN ('B07' , 'B15.9', 'B16', 'B17.2', 'B20')) first_answers
        INNER JOIN
    reporting_age_group rag ON rag.report_group_name = 'Inpatient'
        LEFT OUTER JOIN
    (SELECT DISTINCT
        (p.person_id),
            dcv.concept_full_name,
            icd10_code,
            v.visit_id AS visit_id,
            p.gender AS gender
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
        AND cn.name IN ('Non-coded Diagnosis' , 'Coded Diagnosis')
        AND o.voided = 0
        AND cn.voided = 0
    LEFT JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded
        AND dcv.icd10_code IN ('B07' , 'B15.9', 'B16', 'B17.2', 'B20')
    WHERE
        p.voided = 0
    GROUP BY o.obs_id , dcv.icd10_code) first_concept ON first_concept.icd10_code = first_answers.icd10_code
        LEFT OUTER JOIN
    (SELECT DISTINCT
        (person.person_id) AS person_id,
            obs.value_coded AS answer,
            obs.concept_id AS question,
            obs.obs_datetime AS datetime,
            visit.visit_id AS visit_id,
            person.gender AS gender
    FROM
        obs
    INNER JOIN concept_view question ON obs.concept_id = question.concept_id
        AND question.concept_full_name IN ('Discharge note, Inpatient outcome')
    INNER JOIN person ON obs.person_id = person.person_id
    INNER JOIN encounter ON obs.encounter_id = encounter.encounter_id
    INNER JOIN visit ON encounter.visit_id = visit.visit_id
    WHERE
        CAST(obs.obs_datetime AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON first_concept.person_id = second_concept.person_id
        AND first_concept.visit_id = second_concept.visit_id
        LEFT OUTER JOIN
    person p ON first_concept.person_id = p.person_id
        AND CAST(second_concept.datetime AS DATE) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate,
            INTERVAL rag.min_years YEAR),
        INTERVAL rag.min_days DAY)) AND (DATE_ADD(DATE_ADD(p.birthdate,
            INTERVAL rag.max_years YEAR),
        INTERVAL rag.max_days DAY))
        AND rag.report_group_name = 'Inpatient'
GROUP BY first_answers.answer_name , rag.name
ORDER BY FIELD(first_answers.icd10_code,'B07','B15.9','B16','B17.2','B20') , first_answers.answer_name , rag.sort_order