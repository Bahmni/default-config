SELECT 
    age_years_grp.age_years AS 'Age Group',
    IFNULL(SUM(22_27), 0) AS '22 - 27',
    IFNULL(SUM(28_36), 0) AS '28 - 36',
    IFNULL(SUM(37_41), 0) AS '37 - 41',
    IFNULL(SUM(above41), 0) AS '>= 42'
FROM
    (SELECT '< 20 years' AS age_years UNION SELECT '20 - 34 years' AS age_years UNION SELECT '> 34 years' AS age_years) age_years_grp
        LEFT outer JOIN
    (SELECT 
		
            a.agegroup AS age_grp,
        SUM(IF(a.gestation_period BETWEEN 22 AND 27, 1, 0)) AS 22_27,
            SUM(IF(a.gestation_period BETWEEN 28 AND 36, 1, 0)) AS 28_36,
            SUM(IF(a.gestation_period BETWEEN 37 AND 41, 1, 0)) AS 37_41,
            SUM(IF(a.gestation_period >= 42, 1, 0)) AS above41
    FROM
        (SELECT 
        distinct p.person_id AS ip,
                    gestation_period_obs.value_numeric AS gestation_period,

            TIMESTAMPDIFF(YEAR, p.birthdate, o.value_datetime) AS age,
            CASE
                WHEN TIMESTAMPDIFF(YEAR, p.birthdate, o.value_datetime) < 20 THEN '< 20 years'
                WHEN
                    TIMESTAMPDIFF(YEAR, p.birthdate, o.value_datetime) > 19
                        AND TIMESTAMPDIFF(YEAR, p.birthdate, o.value_datetime) < 35
                THEN
                    '20 - 34 years'
                WHEN TIMESTAMPDIFF(YEAR, p.birthdate, o.value_datetime) > 34 THEN '> 34 years'
            END AS agegroup
    FROM
        obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Delivery Note, Delivery date and time'
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON o.person_id = p.person_id
        AND p.voided = 0
	LEFT OUTER JOIN obs gestation_period_obs ON gestation_period_obs.encounter_id = e.encounter_id
        AND gestation_period_obs.concept_id = (SELECT 
            concept_id
        FROM
            concept_view
        WHERE
            concept_full_name = 'Delivery Note, Gestation period')
        AND gestation_period_obs.voided = FALSE
    WHERE
        (o.value_datetime IS NOT NULL)
            AND DATE(e.encounter_datetime)
            BETWEEN  DATE('#startDate#') AND DATE('#endDate#') group by ip) a
    GROUP BY a.agegroup) simpler_form ON simpler_form.age_grp = age_years_grp.age_years
GROUP BY age_years_grp.age_years
ORDER BY age_years_grp.age_years;