SELECT 
 new_user.method,
 new_user.less_than_20,
 new_user.More_than_20,

(CASE 
WHEN new_user.method = 'Vasectomy' THEN fp.vasectomy_user
WHEN new_user.method = 'Pills' THEN fp.pills_user
WHEN new_user.method = 'Other' THEN fp.other_user
WHEN new_user.method = 'Mini-lap' THEN fp.minilap_user
WHEN new_user.method = 'IUCD' THEN fp.IUCD_user
WHEN new_user.method = 'Implant' THEN fp.implant_user
WHEN new_user.method = 'Depo' THEN fp.depo_user
WHEN new_user.method = 'Condoms' THEN fp.condoms_user
 ELSE 0 
 END)as previous,
 
(CASE 
WHEN new_user.method = 'Vasectomy' THEN fp.vasectomy_user
WHEN new_user.method = 'Pills' THEN fp.pills_user
WHEN new_user.method = 'Other' THEN fp.other_user
WHEN new_user.method = 'Mini-lap' THEN fp.minilap_user
WHEN new_user.method = 'IUCD' THEN fp.IUCD_user
WHEN new_user.method = 'Implant' THEN fp.implant_user
WHEN new_user.method = 'Depo' THEN fp.depo_user
WHEN new_user.method = 'Condoms' THEN fp.condoms_user
 ELSE 0 
 END)+SUM(new_user.less_than_20)+SUM(new_user.More_than_20)-SUM(defaulting.defaulters_count) AS existing,
  defaulting.defaulters_count
  
FROM  
     
(SELECT first_answers.answer_name as method,
    IFNULL(SUM(CASE WHEN first_concept.age < 20  THEN 1 ELSE 0 END),0) AS less_than_20,
        IFNULL(SUM(CASE WHEN first_concept.age >= 20  THEN 1 ELSE 0 END),0) AS More_than_20

FROM
(SELECT DISTINCT
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
        question_concept_name.name IN ('FRH-Long acting and permanent method','FRH-short acting method provided')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
    LEFT OUTER JOIN
	(SELECT DISTINCT
        o1.person_id AS personid,
                    TIMESTAMPDIFF(YEAR, p1.birthdate, v.date_started) AS age,
                    
            cn2.concept_id AS answer,
            cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('FRH-Long acting and permanent method','FRH-short acting method provided')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
     INNER JOIN visit v ON v.visit_id = e.visit_id 
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL
		) first_concept ON first_concept.answer = first_answers.answer
            GROUP BY first_answers.answer
            ORDER BY first_answers.answer desc) as new_user
            JOIN 
		(SELECT 
    first_answers.answer_name AS method,
 COUNT(DISTINCT (first_concept.person_id)) AS defaulters_count
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
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
        LEFT OUTER JOIN
    (SELECT DISTINCT ov.person_id,
        answer, method_name
    FROM
        openmrs.obs_view ov
    INNER JOIN (SELECT 
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
            AND DATE(ov.value_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND ov.person_id NOT IN (SELECT DISTINCT
                o.person_id
            FROM
                obs o
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
                AND cn.concept_name_type = 'FULLY_SPECIFIED'
                AND cn.name IN ('FRH-short acting method provided' , 'FRH-Long acting and permanent method', 'FRH-New method chosen', 'FRH-Existing continued')
                AND o.voided = 0
                AND cn.voided = 0
            INNER JOIN concept_name cn2 ON o.value_coded = cn2.concept_id
                AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                AND cn2.voided = 0
            WHERE
                DATE(o.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) UNION ALL (SELECT 
        cn2.concept_id AS answer,
            cn2.name AS method_name,
            o1.person_id
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'FRH-Discontinued'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL)) first_concept ON first_concept.answer = first_answers.answer
GROUP BY method
ORDER BY method desc)
defaulting ON defaulting.method=new_user.method
LEFT JOIN familyPlanning fp ON 1=1
GROUP BY new_user.method 
order by new_user.method desc
