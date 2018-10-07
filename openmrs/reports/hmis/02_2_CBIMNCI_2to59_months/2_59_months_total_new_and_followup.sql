SELECT 
    COUNT(o1.person_id) AS 'Total Patient (2-59) months'
FROM
    obs o1
        INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (2 to 59 months child)'
        AND o1.voided = 0
        AND cn1.voided = 0
        INNER JOIN
    encounter e ON o1.encounter_id = e.encounter_id
        INNER JOIN
    person p1 ON o1.person_id = p1.person_id
WHERE
    DATE(o1.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')

