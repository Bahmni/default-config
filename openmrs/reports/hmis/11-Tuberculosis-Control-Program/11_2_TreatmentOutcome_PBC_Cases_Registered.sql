SELECT 
    third_answers.answer_name AS 'Diagonasis',
    gender.gender AS Gender,
    SUM(CASE
        WHEN
            first_concept.answer IS NOT NULL
                AND second_concept.answer IS NOT NULL
                AND third_concept.answer IS NOT NULL
                AND p.gender IS NOT NULL
        THEN
            1
        ELSE 0
    END) AS 'Patient Count'
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
        question_concept_name.name IN ('TB FU-Treatment outcome')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
        INNER JOIN
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
        question_concept_name.name IN ('TB Intake-Diagnosis category')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) third_answers
        INNER JOIN
    (SELECT 'M' AS gender UNION SELECT 'F' AS gender) gender
        LEFT OUTER JOIN
    (SELECT 
       DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'TB FU-Treatment outcome'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    WHERE 
        CAST(v1.date_started AS DATE) BETWEEN DATE(DATE_SUB('#startDate#', INTERVAL 12 MONTH)) AND DATE(DATE_SUB('#endDate#', INTERVAL 12 MONTH))) first_concept ON first_concept.answer = first_answers.answer
        LEFT OUTER JOIN
    (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'TB Intake-Type'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name = 'Pulmonary BC'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    WHERE
        CAST(v1.date_started AS DATE) BETWEEN DATE(DATE_SUB('#startDate#', INTERVAL 12 MONTH)) AND DATE(DATE_SUB('#endDate#', INTERVAL 12 MONTH)))second_concept ON 
        first_concept.person_id = second_concept.person_id
        AND first_concept.visit_id = second_concept.visit_id
        LEFT OUTER JOIN
    (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id
            FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'TB Intake-Diagnosis category'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    WHERE
      CAST(v1.date_started AS DATE) BETWEEN DATE(DATE_SUB('#startDate#', INTERVAL 12 MONTH)) AND DATE(DATE_SUB('#endDate#', INTERVAL 12 MONTH))) third_concept ON third_concept.answer = third_answers.answer
        AND second_concept.person_id = third_concept.person_id
        AND second_concept.visit_id = third_concept.visit_id
        LEFT OUTER JOIN
    person p ON first_concept.person_id = p.person_id
        AND p.gender = gender.gender
GROUP BY third_answers.answer_name,gender.gender
	   
	   
	   