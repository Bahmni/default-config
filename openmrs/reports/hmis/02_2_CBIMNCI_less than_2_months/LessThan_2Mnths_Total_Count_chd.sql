SELECT 
    IFNULL(SUM(CASE
        WHEN age_days < 29 THEN 1
        ELSE 0
    END),0) AS 'Total children less than 29 days',
    IFNULL(SUM(CASE
        WHEN age_days > 28 AND age_days < 60 THEN 1
        ELSE 0
    END),0) AS 'Total children between 29-59 days'
FROM
    (SELECT 
        p.person_id,
            TIMESTAMPDIFF(DAY, p.birthdate, v.date_started) AS age_days
    FROM
        obs o
    INNER JOIN person p ON o.person_id = p.person_id
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (<2 months child)'
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
        
    WHERE
         DATE(o.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#') ) a ; 