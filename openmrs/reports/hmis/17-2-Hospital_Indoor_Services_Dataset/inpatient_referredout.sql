SELECT 
    client_visits.age_group AS 'Age Group',
    IF(client_visits.patient_id IS NULL,
        0,
        SUM(IF(client_visits.patient_gender = 'F',
            1,
            0))) AS 'Total Referred out Clients Female',
    IF(client_visits.patient_id IS NULL,
        0,
        SUM(IF(client_visits.patient_gender = 'M',
            1,
            0))) AS 'Total Referred out Clients Male'
FROM
    (SELECT DISTINCT
        patient.patient_id AS patient_id,
            observed_age_group.name AS age_group,
            observed_age_group.id AS age_group_id,
            patient.date_created AS first_visit_date,
            person.gender AS patient_gender,
            observed_age_group.sort_order AS sort_order
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
    INNER JOIN visit visit ON visit.visit_id = e.visit_id
    INNER JOIN patient ON visit.patient_id = patient.patient_id
        AND DATE(visit.date_stopped) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
        AND patient.voided = 0
        AND visit.voided = 0
    INNER JOIN person ON person.person_id = patient.patient_id
        AND person.voided = 0
    RIGHT OUTER JOIN reporting_age_group AS observed_age_group ON DATE(visit.date_stopped) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY)) AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
    WHERE
        observed_age_group.report_group_name = 'Inpatient') AS client_visits
GROUP BY client_visits.age_group
ORDER BY client_visits.sort_order;