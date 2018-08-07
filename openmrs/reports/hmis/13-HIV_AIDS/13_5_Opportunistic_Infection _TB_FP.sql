SELECT 
    first_question.answer_name AS 'Category',
    reporting_age_group.name AS 'Age Group',
    COUNT(DISTINCT IF((patients.gender = 'F'),
            patients.person_id,
            NULL)) AS Female,
    COUNT(DISTINCT IF((patients.gender = 'M'),
            patients.person_id,
            NULL)) AS Male,
    COUNT(DISTINCT IF((patients.gender = 'O'),
            patients.person_id,
            NULL)) AS Others
FROM
    (SELECT 
        question_concept_name.concept_id AS question,
            IFNULL(question_concept_short_name.name, question_concept_name.name) AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    LEFT JOIN concept_name question_concept_short_name ON question_concept_name.concept_id = question_concept_short_name.concept_id
        AND question_concept_short_name.concept_name_type = 'SHORT'
        AND question_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('HIVTC, Any OI in past 3 months?' , 
        'HIVTC, Opportunistic Infection Diagnosis',
        'HIVTC, HIV care IPT started',
        'HIVTC, TB Screened',
        'HIVTC, TB Treatment start date',
        'HIVTC, Need Family Planning assessment',
        'HIVTC, FP methods used by the patient',
        'HIVTC-Progress Refer for FP'
        )
    ORDER BY answer_name DESC) first_question
        INNER JOIN
    (SELECT 
        '< 5 Years' AS name,
            0 AS min_years,
            0 AS min_days,
            5 AS max_years,
            - 1 AS max_days
     UNION SELECT 
        '5-14 years' AS name,
            5 AS min_years,
            0 AS min_days,
            15 AS max_years,
            - 1 AS max_days
     UNION SELECT 
        '≥ 15 years' AS name,
            15 AS min_years,
            0 AS min_days,
            999 AS max_years,
            - 1 AS max_days
    ) reporting_age_group
        LEFT OUTER JOIN
    (SELECT DISTINCT
        o1.person_id,
            cn1.concept_id AS question,
            person.birthdate,
            person.gender,
            v.date_stopped
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('HIVTC, Any OI in past 3 months?' ,
        'HIVTC, Opportunistic Infection Diagnosis',
        'HIVTC, HIV care IPT started', 
         'HIVTC, TB Screened',
        'HIVTC, TB Treatment start date',
        'HIVTC, Need Family Planning assessment', 
        'HIVTC, FP methods used by the patient',
        'HIVTC-Progress Refer for FP'
     )
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person person ON o1.person_id = person.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) patients ON patients.question = first_question.question
        AND patients.date_stopped BETWEEN (DATE_ADD(DATE_ADD(patients.birthdate,
            INTERVAL reporting_age_group.min_years YEAR),
        INTERVAL reporting_age_group.min_days DAY)) AND (DATE_ADD(DATE_ADD(patients.birthdate,
            INTERVAL reporting_age_group.max_years YEAR),
        INTERVAL reporting_age_group.max_days DAY))
GROUP BY first_question.answer_name , reporting_age_group.name;

