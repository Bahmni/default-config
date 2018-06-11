SELECT 
	first_answers.answer_name AS first_concept_name,
   rag.name as 'Age Group',
   COUNT(DISTINCT first_concept.person_id) AS patient_count
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
        question_concept_name.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method', 'FRH-New method chosen')
            AND cd.name = 'Coded' UNION SELECT 
        answer_concept_fully_specified_name.concept_id AS answer,
            answer_concept_fully_specified_name.name AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    INNER JOIN global_property gp ON gp.property IN ('concept.true' , 'concept.false')
    INNER JOIN concept_name answer_concept_fully_specified_name ON answer_concept_fully_specified_name.concept_id = gp.property_value
        AND answer_concept_fully_specified_name.concept_name_type = 'FULLY_SPECIFIED'
        AND answer_concept_fully_specified_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method', 'FRH-New method chosen')
            AND cd.name = 'Boolean'
    ORDER BY answer_name DESC) first_answers
        INNER JOIN
    reporting_age_group rag ON rag.report_group_name = 'Abortion Services Report'
        LEFT OUTER JOIN
    (SELECT DISTINCT
        o1.person_id,
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
           rag.name as age_grp
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method', 'FRH-New method chosen')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
	INNER JOIN person ON o1.person_id = person.person_id
            INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
            INNER JOIN visit v ON e.visit_id = v.visit_id
			
			INNER JOIN reporting_age_group rag ON DATE(v.date_started) BETWEEN (DATE_ADD(
                     DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days DAY)) AND (DATE_ADD(
                     DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
                                                       AND rag.report_group_name = 'Abortion Services Report'
    WHERE
        -- DATE(e.encounter_datetime) BETWEEN DATE('2018-04-14') AND DATE('2018-05-14')
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) first_concept ON first_concept.answer = first_answers.answer
            and  rag.name = first_concept.age_grp

GROUP BY first_answers.answer_name , rag.name;
