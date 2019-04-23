SELECT 
    gender.gender AS 'Gender',
    SUM(CASE
        WHEN
            first_concept.question IS NOT NULL
                AND p.gender IS NOT NULL
        THEN
            1
        ELSE 0
    END) AS 'Patient Count'
FROM
    (SELECT 
        question_concept_name.concept_id AS question,
            IFNULL(question_concept_short_name.name, question_concept_name.name) AS answer_name
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
        question_concept_name.name IN ('TB Intake-Is patient on art','TB Intake-Is patient on cpt')
    ORDER BY answer_name DESC) first_answers
        INNER JOIN
    (SELECT 'M' AS gender UNION SELECT 'F' AS gender) gender
        LEFT OUTER JOIN
    (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
			cn2.concept_id AS answer_name,
            v1.visit_id AS visit_id,
            v1.date_stopped AS datetime
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Tuberculosis, Is patient on ART','Tuberculosis, Is patient on CPT')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
		AND cn2.name = 'Yes'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
       ) first_concept ON first_concept.question = first_answers.question
        LEFT OUTER JOIN
    person p ON first_concept.person_id = p.person_id
        AND p.gender = gender.gender
GROUP BY  gender.gender;
