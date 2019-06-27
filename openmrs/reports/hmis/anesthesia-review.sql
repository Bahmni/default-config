SELECT 
    p.gender `Gender`,
    pa.county_district AS `District`,
    pa.city_village AS `Municipality`,
    e.encounter_datetime `Encounter datetime`,
    TIMESTAMPDIFF(YEAR,
        p.birthdate,
        e.encounter_datetime) AS `Age at visit`,
    MAX(CASE
        WHEN
            o.concept_id IN (SELECT 
                    concept_id
                FROM
                    concept_name
                WHERE
                    name IN ('Operative Notes, Diagnosis' , 'Procedure Notes, Diagnosis')
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND locale = 'en'
                        AND voided = 0)
        THEN
            o.value_text
    END) AS `Diagnosis`,
    MAX(CASE
        WHEN
            o.concept_id IN (SELECT 
                    concept_id
                FROM
                    concept_name
                WHERE
                    name IN ('Operative Notes, Anesthetist' , 'Procedure Notes, Anesthetist')
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND locale = 'en'
                        AND voided = 0)
        THEN
            o.value_text
    END) AS `Anesthetist`,
    MAX(CASE
        WHEN
            o.concept_id IN (SELECT 
                    concept_id
                FROM
                    concept_name
                WHERE
                    name IN ('Operative Notes, Anesthesia' , 'Procedure Notes, Anesthesia')
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND locale = 'en'
                        AND voided = 0)
        THEN
            o.value_text
    END) AS `Anesthesia`,
    MAX(CASE
        WHEN
            o.concept_id IN (SELECT 
                    concept_id
                FROM
                    concept_name
                WHERE
                    name IN ('Operative Notes, Surgeons' , 'Procedure Notes, Surgeons')
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND locale = 'en'
                        AND voided = 0)
        THEN
            o.value_text
    END) AS `Surgeons`,
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = MAX(CASE
                WHEN
                    o.concept_id IN (SELECT 
                            concept_id
                        FROM
                            concept_name
                        WHERE
                            name IN ('Operative Notes, Procedure' , 'Procedure Notes, Procedure')
                                AND concept_name_type = 'FULLY_SPECIFIED'
                                AND locale = 'en'
                                AND voided = 0)
                THEN
                    o.value_coded
            END)
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en'
                AND voided = 0) AS `Procedure`
FROM
    person p
        INNER JOIN
    person_address pa ON pa.person_id = p.person_id
        AND pa.voided = 0
        INNER JOIN
    visit v ON p.person_id = v.patient_id
        AND v.voided = 0
        INNER JOIN
    encounter e ON v.visit_id = e.visit_id AND e.voided = 0
        INNER JOIN
    obs o ON e.encounter_id = o.encounter_id
        AND o.voided = 0
        AND o.concept_id IN (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name IN ('Operative Notes, Diagnosis' , 'Operative Notes, Surgeons',
                'Operative Notes, Anesthetist',
                'Operative Notes, Anesthesia',
                'Operative Notes, Procedure',
                'Procedure Notes, Diagnosis',
                'Procedure Notes, Surgeons',
                'Procedure Notes, Anesthetist',
                'Procedure Notes, Anesthesia',
                'Procedure Notes, Procedure')
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en'
                AND voided = 0)
WHERE
    p.voided = 0
        AND e.encounter_datetime BETWEEN '#startDate#' and '#endDate#'
GROUP BY e.encounter_id
HAVING (`Anesthetist` IS NOT NULL
    OR `Anesthesia` IS NOT NULL);