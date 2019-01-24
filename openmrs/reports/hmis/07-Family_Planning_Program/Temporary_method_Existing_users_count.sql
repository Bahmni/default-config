SELECT 
    first_answers.answer_name AS method,
    COUNT(DISTINCT (first_concept.person_id)) AS existing_users
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
        question_concept_name.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method')
            AND cd.name = 'Boolean'
    ORDER BY answer_name DESC) first_answers
        LEFT OUTER JOIN
    (SELECT 
        answer, method_name, ov.person_id
    FROM
        openmrs.obs_view ov
    LEFT JOIN (SELECT 
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
            -- AND DATE(ov.value_datetime) > DATE('2017-08-30')) first_concept ON first_concept.answer = first_answers.answer
			AND DATE(ov.value_datetime) > DATE('#endDate#')) first_concept ON first_concept.answer = first_answers.answer
GROUP BY method
order by method;
					