
SELECT 
    gender.gender, COUNT(DISTINCT a.person_id) AS 'Total Count'
FROM
    (SELECT 
        p.gender, first_concept.person_id
    FROM
        (SELECT 
        o1.person_id, v1.visit_id AS visit_id
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('DRTB Intake-Diagnosis category')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
        AND v1.date_stopped IS NOT NULL
    WHERE
        CAST(v1.date_stopped AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) first_concept
    JOIN person p ON first_concept.person_id = p.person_id
    WHERE
        first_concept.person_id NOT IN (SELECT 
                first_concept.person_id
            FROM
                (SELECT 
                o1.person_id, v1.visit_id AS visit_id
            FROM
                obs o1
            INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
                AND cn1.concept_name_type = 'FULLY_SPECIFIED'
                AND cn1.name = 'DRTB Intake-Diagnosis category'
                AND o1.voided = 0
                AND cn1.voided = 0
            INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
                AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                AND cn2.voided = 0
            INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
            INNER JOIN visit v1 ON v1.visit_id = e.visit_id
            WHERE
                CAST(e.encounter_datetime AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) first_concept
            JOIN (SELECT 
                o1.person_id, v1.visit_id AS visit_id
            FROM
                obs o1
            INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
                AND cn1.concept_name_type = 'FULLY_SPECIFIED'
                AND cn1.name = 'DRTB FU-Treatment outcome'
                AND o1.voided = 0
                AND cn1.voided = 0
            INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
                AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                AND cn2.voided = 0
            INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
            INNER JOIN visit v1 ON v1.visit_id = e.visit_id
            WHERE
                CAST(e.encounter_datetime AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON first_concept.person_id = second_concept.person_id
                AND first_concept.visit_id = second_concept.visit_id
            JOIN person p ON first_concept.person_id = p.person_id)) a
        RIGHT OUTER JOIN
    (SELECT 'M' AS gender UNION SELECT 'F' AS gender) gender ON a.gender = gender.gender
GROUP BY gender.gender
;