SELECT 
    gender_group.gender,
    COUNT(DISTINCT (a.ip)) AS count_referred_out_ER
FROM
    (SELECT 'M' AS gender UNION SELECT 'F' AS gender) gender_group
    
    LEFT JOIN (SELECT DISTINCT
          p1.person_id AS ip,
            p1.gender AS gender
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name IN ('Referred for Investigations' , 'Referred for Further Care', 'Referred for Surgery')
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
	JOIN visit_type vt ON v1.visit_type_id = vt.visit_type_id AND vt.name = 'Emergency'
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
       -- DATE(o1.obs_datetime) BETWEEN '2017-01-01' AND '2018-01-01') a ON a.gender = gender_group.gender
        DATE(o1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#') a ON a.gender = gender_group.gender
GROUP BY gender_group.gender
ORDER BY gender_group.gender;