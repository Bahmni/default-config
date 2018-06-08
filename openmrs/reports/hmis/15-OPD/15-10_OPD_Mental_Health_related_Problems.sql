SELECT 
    first_answers.answer_name AS 'ICD name',
    first_answers.icd10_code AS 'ICD CODE',
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
        icd10_code IN ('F03','F10','F20','F29','F31','F32','F40','F41','F42','F44','F48','F79','G40','G43','F99')) first_answers
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
        AND cn.name IN ('Coded Diagnosis')
        AND o.voided = 0
        AND cn.voided = 0
     JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded
        AND dcv.icd10_code IN ('F03','F10','F20','F29','F31','F32','F40','F41','F42','F44','F48','F79','G40','G43','F99')
    WHERE
        p.voided = 0) first_concept ON first_concept.icd10_code = first_answers.icd10_code
        LEFT OUTER JOIN
    (SELECT DISTINCT
        (person.person_id) AS person_id,
            cn2.concept_id AS answer,
            obs.concept_id AS question,
            obs.obs_datetime AS datetime,
            visit.visit_id AS visit_id,
            person.gender AS gender
    FROM
        obs
    INNER JOIN concept_view question ON obs.concept_id = question.concept_id
        AND question.concept_full_name IN ('Department Sent To')
    INNER JOIN concept_name cn2 ON obs.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name IN ('OPD')
    INNER JOIN person ON obs.person_id = person.person_id
    INNER JOIN encounter ON obs.encounter_id = encounter.encounter_id
    INNER JOIN visit ON encounter.visit_id = visit.visit_id
    WHERE
        CAST(obs.obs_datetime AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON first_concept.person_id = second_concept.person_id
        AND first_concept.visit_id = second_concept.visit_id
GROUP BY first_answers.icd10_code
ORDER BY FIELD(first_answers.icd10_code,'F03','F10','F20','F29','F31','F32','F40','F41','F42','F44','F48','F79','G40','G43','F99')
