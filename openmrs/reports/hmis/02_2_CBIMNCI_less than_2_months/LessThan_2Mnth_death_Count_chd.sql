
SELECT 
    IFNULL(SUM(CASE WHEN age_days < 29 THEN 1 ELSE 0 END),0) AS 'Death of Children less than 29 days',
    IFNULL(SUM(CASE WHEN age_days > 28 AND age_days < 60 THEN 1 ELSE 0 END),0) AS 'Death of Children between 29-59 days'
    FROM
    
(SELECT DISTINCT
		p1.person_id,
		TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) AS age_days,
		(select distinct name from concept_name where concept_id=cn2.concept_id limit 1) as causes_for_death
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Death Note, Primary Cause of Death',
        'Death Note, Secondary Cause of Death',
        'Death Note, Tertiary Cause of Death')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
	INNER JOIN visit v ON v.visit_id = e.visit_id

    WHERE
		 TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 2 
         -- AND DATE(e.encounter_datetime) BETWEEN DATE('2014-01-01') AND DATE('2018-11-30'))a;
		 AND DATE(e.encounter_datetime)  BETWEEN DATE('#startDate#') AND DATE('#endDate#'))a;
 

