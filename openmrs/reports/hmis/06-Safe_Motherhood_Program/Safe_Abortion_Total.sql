SELECT
    IFNULL(SUM(CASE WHEN age_yr < 20 AND first_answers.category = 'Safe abortion-Medical Procedure' THEN 1 ELSE 0 END),0) AS 'less than 20 Medical',
	IFNULL(SUM(CASE WHEN age_yr < 20 AND first_answers.category = 'Safe abortion-Surgical procedure' THEN 1 ELSE 0 END),0) AS 'less than 20 Surgical',
	IFNULL(SUM(CASE WHEN age_yr >= 20 AND first_answers.category = 'Safe abortion-Medical Procedure' THEN 1 ELSE 0 END),0) AS 'greater than 20 Medical',
	IFNULL(SUM(CASE WHEN age_yr >= 20 AND first_answers.category = 'Safe abortion-Surgical procedure' THEN 1 ELSE 0 END),0) AS 'greater than 20 Surgical'

FROM
       (SELECT 
        DISTINCT(o1.person_id),
            cn2.concept_id AS answer,
            cn1.concept_id AS question,
			cn1.name as category,
			TIMESTAMPDIFF(YEAR, p.birthdate, v1.date_started) AS age_yr

    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Safe abortion-Surgical procedure','Safe abortion-Medical Procedure')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
		AND cn2.name NOT IN ('Not Applicable')
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p ON o1.person_id = p.person_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    WHERE
        CAST(v1.date_started AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) as first_answers
