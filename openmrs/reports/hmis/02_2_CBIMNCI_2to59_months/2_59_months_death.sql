 SELECT 
    IFNULL(SUM(CASE
                WHEN LOWER(causes_for_death) LIKE '%pneumonia%'
                THEN cause_count
				WHEN LOWER(causes_for_death) LIKE '%URTI%'
                THEN cause_count
				WHEN LOWER(causes_for_death) LIKE '%LRTI%'
                THEN cause_count
                ELSE 0
            END),
            0) AS 'Death By ARI',
    IFNULL(SUM(CASE
                WHEN LOWER(causes_for_death) LIKE '%Diarrhoea%' THEN cause_count
                ELSE 0
            END),
            0) AS 'Death By Diarrhoea',
    IFNULL(SUM(CASE
                WHEN
                    LOWER(causes_for_death) NOT LIKE '%pneumonia%'
                    AND LOWER(causes_for_death) NOT LIKE '%Respiratory Tract Infection%'
                        AND LOWER(causes_for_death) NOT LIKE '%Diarrhoea%'
                THEN
                    cause_count
                ELSE 0
            END),
            0) AS 'Death By Other'
FROM
    (SELECT DISTINCT
        COUNT(DISTINCT o1.person_id) AS cause_count,
            (SELECT DISTINCT
                    name
                FROM
                    concept_name
                WHERE
                    concept_id = cn2.concept_id
                LIMIT 1) AS causes_for_death
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Death Note, Primary Cause of Death' , 'Death Note, Secondary Cause of Death', 'Death Note, Tertiary Cause of Death')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    WHERE
        TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN '#startDate#' AND '#endDate#'
    GROUP BY causes_for_death) a;