SELECT 
    age_days_grp.age_days AS 'Categories',
     gender.gender AS Gender,
    IFNULL(first_concept.count_total, 0) AS 'Total Patient'
    
FROM
        (SELECT 'M' AS gender UNION SELECT 'F' AS gender) gender 
INNER JOIN
    (SELECT 'Early Neonatal' AS age_days UNION SELECT 'Late Neonatal' AS age_days) age_days_grp
		LEFT OUTER JOIN  
    (SELECT 
    agegroup, COUNT(DISTINCT person_id) AS count_total,gender
    FROM
        (
        SELECT DISTINCT o1.person_id,
           ( CASE
                WHEN TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) < 29 THEN 'Early Neonatal'
                WHEN
                    TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) > 28
                        AND TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) < 60
                THEN
                    'Late Neonatal'
            END ) AS agegroup,
            p1.gender as gender
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Death Note, Primary Cause of Death')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#') 
        )b group by b.agegroup,b.gender) first_concept ON first_concept.agegroup=age_days_grp.age_days
        AND first_concept.gender = gender.gender
        Group BY age_days_grp.age_days,gender.gender
       
         
        
        
        
       
        
