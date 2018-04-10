
SELECT 
	gender.gender              AS gender,
    count(distinct(a.person_id)) as referred_in_count  
    from
    
 (SELECT 'M' AS gender
              UNION SELECT 'F' AS gender) gender
              
 LEFT OUTER JOIN
    (SELECT 
			o1.person_id,
			p1.gender
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Referred In')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v1 ON v1.visit_id = e.visit_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
    			 
                DATE(o1.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#') ) a 

    --    DATE(o1.obs_datetime) BETWEEN  DATE('2017-01-01') AND DATE('2017-12-30') ) a 
    on a.gender=gender.gender
    group by gender;