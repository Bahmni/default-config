SELECT  leprosy.type_leprosy AS 'leprosy type',
        total_female-deducted_female AS 'Female at the end of month',
		total_male-deducted_male AS 'Male at the end of month'
FROM
(SELECT
	first_answers.answer_name AS type_leprosy,
	SUM(IF(p.gender = 'F', 1, 0)) AS total_female,
    SUM(IF(p.gender = 'M', 1, 0)) AS total_male
 
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
        question_concept_name.name IN ('Leprosy, Leprosy Type')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
    LEFT OUTER JOIN
    reporting_age_group rag ON rag.report_group_name = 'Leprosy Control'
            AND rag.name = '< 14 Years'
        LEFT OUTER JOIN
    (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id,
            v1.date_stopped AS datetime
            
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Leprosy, Leprosy Type'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
        AND v1.date_stopped IS NOT NULL
    WHERE
        CAST(v1.date_stopped AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) first_concept ON first_concept.answer = first_answers.answer
        LEFT OUTER JOIN
    (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id,
            v1.date_stopped AS datetime
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Leprosy, Case Type'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
        AND v1.date_stopped IS NOT NULL
    WHERE
        CAST(v1.date_stopped AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON 
        first_concept.person_id = second_concept.person_id
        AND first_concept.visit_id = second_concept.visit_id
        LEFT OUTER JOIN
    person p ON first_concept.person_id = p.person_id
     AND CAST(first_concept.datetime AS DATE) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate,
            INTERVAL rag.min_years YEAR),
        INTERVAL rag.min_days DAY)) AND (DATE_ADD(DATE_ADD(p.birthdate,
            INTERVAL rag.max_years YEAR),
        INTERVAL rag.max_days DAY))
        AND rag.report_group_name = 'Leprosy Control'
GROUP BY  first_answers.answer_name) AS leprosy
INNER JOIN

(SELECT
	first_answers.answer_name AS type_leprosy,
	SUM(IF(p.gender = 'F', 1, 0)) AS deducted_female,
    SUM(IF(p.gender = 'M', 1, 0)) AS deducted_male
FROM
( SELECT 
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
        question_concept_name.name IN ('Leprosy, Leprosy Type')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
     LEFT OUTER JOIN
    reporting_age_group rag ON rag.report_group_name = 'Leprosy Control'
            AND rag.name = '< 14 Years'
        LEFT OUTER JOIN
        (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id,
            v1.date_stopped AS datetime
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Leprosy, Leprosy Type'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
        AND v1.date_stopped IS NOT NULL
    WHERE
        CAST(v1.date_stopped AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) first_concept ON first_concept.answer = first_answers.answer
        LEFT OUTER JOIN
    (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id,
            v1.date_stopped AS datetime
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Leprosy, Patient Deduction Type'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
        AND v1.date_stopped IS NOT NULL
    WHERE
        CAST(v1.date_stopped AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON 
        first_concept.person_id = second_concept.person_id
        AND first_concept.visit_id = second_concept.visit_id
        LEFT OUTER JOIN
    person p ON first_concept.person_id = p.person_id
     AND CAST(first_concept.datetime AS DATE) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate,
            INTERVAL rag.min_years YEAR),
        INTERVAL rag.min_days DAY)) AND (DATE_ADD(DATE_ADD(p.birthdate,
            INTERVAL rag.max_years YEAR),
        INTERVAL rag.max_days DAY))
        AND rag.report_group_name = 'Leprosy Control'
GROUP BY  first_answers.answer_name) AS deducted ON deducted.type_leprosy = leprosy.type_leprosy
