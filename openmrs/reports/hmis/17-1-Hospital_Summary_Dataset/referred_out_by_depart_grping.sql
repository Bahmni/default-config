SELECT 
    gender_group.gender,
    ifnull(referred_opd_patients,0) as referred_opd_patients,
	ifnull(referred_ipd_patients,0) as referred_ipd_patients,
    ifnull(referred_er_patients,0) as referred_er_patients

    
FROM
    (SELECT 'M' AS gender UNION SELECT 'F' AS gender) gender_group
        LEFT OUTER JOIN
    (SELECT 
        gender,
            IFNULL(SUM(CASE
                WHEN
                    depart IN (30 , 29, 28, 27, 26, 25, 24, 23, 22, 20, 16)
                        AND gender = 'M'
                THEN
                    number_pts
                WHEN
                    depart IN (30 , 29, 28, 27, 26, 25, 24, 23, 22, 20, 16)
                        AND gender = 'F'
                THEN
                    number_pts
                ELSE 0
            END), 0) AS referred_ipd_patients,
            IFNULL(SUM(CASE
                WHEN
                    depart IN (34 , 33, 8, 9, 10, 14, 15, 13, 12, 10, 9, 8, 4, 3)
                        AND gender = 'M'
                THEN
                    number_pts
                WHEN
                    depart IN (34 , 33, 8, 9, 10, 14, 15, 13, 12, 10, 9, 8, 4, 3)
                        AND gender = 'F'
                THEN
                    number_pts
                ELSE 0
            END), 0) AS referred_opd_patients,
            IFNULL(SUM(CASE
                WHEN depart IN (7 , 2) AND gender = 'M' THEN number_pts
                WHEN depart IN (7 , 2) AND gender = 'F' THEN number_pts
                ELSE 0
            END), 0) AS referred_er_patients
    FROM
        (SELECT 
        COUNT(DISTINCT (p1.person_id)) AS number_pts,
            o1.location_id AS depart,
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
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
       -- DATE(o1.obs_datetime) BETWEEN '2017-01-01' AND '2017-12-30'
       DATE(o1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    GROUP BY depart , gender) a
    GROUP BY gender) b ON b.gender = gender_group.gender;