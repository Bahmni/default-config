SELECT 
    first_question.answer_name AS 'Gentamycin Dose',
    -- first_question.question as concept_id,
    COUNT(DISTINCT (first_concept.person_id)) AS 'Total Patient'
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
        question_concept_name.name IN ('Childhood Illness - Treatment - Gentamycin - 1st dose' ,'Childhood Illness - Treatment - Gentamycin - Complete Dose')
        ORDER BY answer_name DESC) first_question
        LEFT OUTER JOIN
    (SELECT DISTINCT
        o.person_id,
            cn1.concept_id AS question
           
    FROM
        obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON o.person_id = p.person_id
    and p.voided=0
    WHERE
    cn1.name IN ('Childhood Illness - Treatment - Gentamycin - 1st dose' ,'Childhood Illness - Treatment - Gentamycin - Complete Dose')
	AND TIMESTAMPDIFF(DAY, p.birthdate, v.date_started) < 60
         and 
       -- DATE(o.obs_datetime) BETWEEN DATE('2015-03-01') AND DATE('2017-03-30')
	    DATE(o.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
		
		) first_concept ON first_concept.question = first_question.question
GROUP BY first_question.answer_name 
ORDER BY first_question.answer_name ;