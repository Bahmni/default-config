SELECT 
    first_answers.answer_name,
    gender.gender AS gender,
    COUNT(DISTINCT (a.ip)) AS count_deaths
FROM
    ((SELECT 
        question_concept_name.concept_id AS question,
            question_concept_name.NAME AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    LEFT JOIN concept_name question_concept_short_name ON question_concept_name.concept_id = question_concept_short_name.concept_id
        AND question_concept_short_name.concept_name_type = 'SHORT'
        AND question_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('Death Note, Maternal Death')
    ORDER BY answer_name DESC) first_answers
    INNER JOIN (SELECT 'M' AS gender UNION SELECT 'F' AS gender) gender
    LEFT OUTER JOIN (SELECT DISTINCT
        pi.identifier AS ip,
            cn1.concept_id AS question,
            p.gender AS gender
    FROM
        obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Death Note, Maternal Death')
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON o.person_id = p.person_id
        AND p.voided = 0
    INNER JOIN patient_identifier pi ON pi.patient_id = p.person_id
        AND pi.voided = '0'
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) a ON a.gender = gender.gender
        AND a.question = first_answers.question)
GROUP BY first_answers.question , gender.gender
ORDER BY first_answers.question , gender.gender;
