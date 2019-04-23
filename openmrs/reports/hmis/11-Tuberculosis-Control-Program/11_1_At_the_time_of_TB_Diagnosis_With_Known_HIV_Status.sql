SELECT DISTINCT
    IFNULL(SUM(CASE
                WHEN
                    p1.gender = 'M'
                        AND o1.person_id IS NOT NULL
                THEN
                    1
                ELSE 0
            END),
            0) AS 'MALE PATIENT',
    IFNULL(SUM(CASE
                WHEN
                    p1.gender = 'F'
                        AND o1.person_id IS NOT NULL
                THEN
                    1
                ELSE 0
            END),
            0) AS 'FEMALE PATIENT'
FROM
  obs o1
        INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Tuberculosis-With known HIV status')
        AND o1.voided = 0
        AND cn1.voided = 0
        INNER JOIN
    encounter e ON o1.encounter_id = e.encounter_id
        INNER JOIN
    person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
WHERE
  DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
