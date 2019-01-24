SELECT 
    gender.gender as gender,
	count(DISTINCT( a.ip)) as 'Asymptomatic Partners Treated'
FROM

    (SELECT 'M' AS gender UNION SELECT 'F' AS gender UNION 	SELECT '0' AS gender ) gender 
        LEFT  JOIN
(select 
DISTINCT o1.person_id as ip,
p1.gender as gender
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'STI, Asymptomatic Partners Treated'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
		-- DATE(e.encounter_datetime) BETWEEN DATE('2016-6-16') AND DATE('2017-7-16')

        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#') group by p1.gender) a on a.gender = gender.gender
        
        group by gender.gender  order by gender.gender desc;