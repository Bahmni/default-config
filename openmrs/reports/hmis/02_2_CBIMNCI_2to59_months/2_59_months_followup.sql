SELECT 
    IFNULL(COUNT(o1.person_id), 0) AS 'Total Follow-Up'
FROM
    obs o1
        INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness-2 to 59 months-Case')
        AND o1.voided = 0
        AND cn1.voided = 0
		INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
		AND cn2.name IN ('Follow-up Visit')
        AND cn2.voided = 0
        INNER JOIN
    encounter e ON o1.encounter_id = e.encounter_id
        INNER JOIN
    person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
WHERE
      TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
         AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
	
    AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
	