SELECT 
    first_answers.answer_name AS first_concept_name,
    rag.name AS age_group,
    SUM(CASE
        WHEN
            rag.name = '≥ 20 Years'
                AND first_concept.age_grp = '≥ 20 Years'
        THEN
            1
        WHEN
            rag.name = '< 20 Years'
                AND first_concept.age_grp = '< 20 Years'
        THEN
            1
        ELSE 0
    END) AS patient_count
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
        INNER JOIN
    reporting_age_group rag ON rag.report_group_name = 'Abortion Services Report'
        LEFT OUTER JOIN
    (SELECT DISTINCT
        o1.person_id,
            CASE
                WHEN TIMESTAMPDIFF(YEAR, p1.birthdate, v1.date_started) >= 20 THEN '≥ 20 Years'
                ELSE '< 20 Years'
            END AS age_grp,
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
            v1.visit_id AS visit_id,
            v1.date_stopped AS datetime
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        -- DATE(e.encounter_datetime) BETWEEN DATE('2017-01-01') AND DATE('2017-12-30') 
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) first_concept ON first_concept.answer = first_answers.answer
GROUP BY first_answers.answer_name , rag.name;
