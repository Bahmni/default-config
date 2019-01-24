SELECT 
    first_answers.answer_name AS method,
    COUNT(DISTINCT (first_concept.person_id)) AS defaulters_count
FROM
    (SELECT 
        ca.answer_concept AS answer,
            IFNULL(answer_concept_short_name.name, answer_concept_fully_specified_name.name) AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    INNER JOIN concept_answer ca ON c.concept_id = ca.concept_id
    INNER JOIN concept_name answer_concept_fully_specified_name ON ca.answer_concept = answer_concept_fully_specified_name.concept_id
        AND answer_concept_fully_specified_name.concept_name_type = 'FULLY_SPECIFIED'
        AND answer_concept_fully_specified_name.voided
        IS FALSE
    LEFT JOIN concept_name answer_concept_short_name ON ca.answer_concept = answer_concept_short_name.concept_id
        AND answer_concept_short_name.concept_name_type = 'SHORT'
        AND answer_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
        LEFT OUTER JOIN
    (SELECT 
        answer, method_name, ov.person_id
    FROM
        openmrs.obs_view ov
    INNER JOIN (SELECT 
        cn2.concept_id AS answer,
            cn2.name AS method_name,
            o.encounter_id
    FROM
        obs o
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
        AND cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method', 'FRH-New method chosen', 'FRH-Existing continued')
        AND o.voided = 0
        AND cn.voided = 0
    INNER JOIN concept_name cn2 ON o.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0) method_view ON ov.encounter_id = method_view.encounter_id
        AND ov.voided = 0
    WHERE
        ov.concept_full_name = 'FRH-Procedure Follow Up'
            AND DATE(ov.value_datetime) BETWEEN '#startDate#' AND '#endDate#'
            AND ov.person_id NOT IN (SELECT DISTINCT
                o.person_id
            FROM
                obs o
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
                AND cn.concept_name_type = 'FULLY_SPECIFIED'
                AND cn.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method', 'FRH-New method chosen', 'FRH-Existing continued')
                AND o.voided = 0
                AND cn.voided = 0
            INNER JOIN concept_name cn2 ON o.value_coded = cn2.concept_id
                AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                AND cn2.voided = 0
            WHERE
                DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#') UNION ALL (SELECT 
        cn2.concept_id AS answer,
            cn2.name AS method_name,
            o1.person_id
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'FRH-Discontinued'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN '#startDate#' AND '#endDate#'
            AND o1.value_coded IS NOT NULL)) first_concept ON first_concept.answer = first_answers.answer
GROUP BY method
ORDER BY method;
					