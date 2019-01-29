SELECT 
    gender.gender,    
    count(distinct(first_concept.person_id)) as existing_users
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
         And answer_concept_fully_specified_name.name in ('Vasectomy','Mini-lap')
        AND answer_concept_fully_specified_name.voided
        IS FALSE
    LEFT JOIN concept_name answer_concept_short_name ON ca.answer_concept = answer_concept_short_name.concept_id
        AND answer_concept_short_name.concept_name_type = 'SHORT'
        AND answer_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('FRH-Long acting and permanent method')
            AND cd.name = 'Coded' 
    ORDER BY answer_name DESC) first_answers
    
    
  INNER JOIN (SELECT 'M' AS gender
              UNION SELECT 'F' AS gender) gender
              
              
        LEFT JOIN
    (SELECT DISTINCT
    cn2.concept_id AS answer,
    cn2.name AS method_name,
    o.person_id,
	p1.gender
FROM
    obs o
        INNER JOIN
    concept_name cn ON o.concept_id = cn.concept_id
        AND cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method',
        'FRH-New method chosen',
        'FRH-Existing continued')
        AND o.voided = 0
        AND cn.voided = 0
        INNER JOIN
    concept_name cn2 ON o.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name IN ('Vasectomy' , 'Mini-lap')
        AND cn2.voided = 0
        INNER JOIN
    encounter e ON o.encounter_id = e.encounter_id
        INNER JOIN
    visit v1 ON v1.visit_id = e.visit_id
        INNER JOIN
    person p1 ON o.person_id = p1.person_id
WHERE
    o.obs_datetime <= DATE('#endDate#')) first_concept 
            ON first_concept.answer = first_answers.answer
            and first_concept.gender = gender.gender
GROUP BY gender
order by gender;
					