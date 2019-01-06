SELECT 
    first_answers.category AS 'Category',
    IFNULL(SUM(IF (method IN ('Condoms', 'Pills', 'Depo Provera'), method_count, 0)), 0) as 'short term',
  IFNULL(SUM(IF (method IN ('Male sterilization', 'IUCD', 'Implant', 'Female sterilization'), method_count, 0)), 0) as 'long term'	
	

FROM
    (SELECT DISTINCT
        ca.answer_concept AS answer,
            IFNULL(answer_concept_short_name.name, answer_concept_fully_specified_name.name) AS answer_name,
            question_concept_name.name AS category
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    INNER JOIN concept_answer ca ON c.concept_id = ca.concept_id
    INNER JOIN concept_name answer_concept_fully_specified_name ON ca.answer_concept = answer_concept_fully_specified_name.concept_id
        AND answer_concept_fully_specified_name.concept_name_type = 'FULLY_SPECIFIED'
        AND answer_concept_fully_specified_name.name NOT IN ('Not Applicable')
        AND answer_concept_fully_specified_name.voided
        IS FALSE
    LEFT JOIN concept_name answer_concept_short_name ON ca.answer_concept = answer_concept_short_name.concept_id
        AND answer_concept_short_name.concept_name_type = 'SHORT'
        AND answer_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('Safe abortion-Surgical procedure' , 'Safe abortion-Medical Procedure')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
        LEFT OUTER JOIN
    (SELECT DISTINCT
        (o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Safe abortion-Surgical procedure' , 'Safe abortion-Medical Procedure')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name NOT IN ('Not Applicable')
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    WHERE
        CAST(v1.date_started AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#') group by person_id) first_concept ON first_concept.answer = first_answers.answer
        LEFT OUTER JOIN
    (SELECT 
    distinct  o1.person_id as per_id,
      count(distinct(o1.person_id)) as method_count,
            cn2.concept_id AS answer,
            cn2.name as method
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Accepted Family Planning methods'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    WHERE
        CAST(v1.date_started AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#') group by method) second_concept ON 
        first_concept.person_id = second_concept.per_id
GROUP BY first_answers.category;


