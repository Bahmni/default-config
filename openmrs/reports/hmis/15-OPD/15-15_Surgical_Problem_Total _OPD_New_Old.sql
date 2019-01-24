

SELECT 
    COUNT(DISTINCT IF((gender = 'F' AND Type = 'New'),
            obs_id,
            NULL)) AS 'Total New OPD Visits Female',
    COUNT(DISTINCT IF((gender = 'M' AND Type = 'New'),
            obs_id,
            NULL)) AS 'Total New OPD Visits Male',
    COUNT(DISTINCT IF((gender = 'F' AND Type = 'Returning'),
            obs_id,
            NULL)) AS 'Total Old OPD Visits Female',
    COUNT(DISTINCT IF((gender = 'M' AND Type = 'Returning'),
            obs_id,
            NULL)) AS 'Total Old OPD Visits Male'
FROM
    (SELECT 
        dcv.concept_full_name,
            dcv.icd10_code,
            o.obs_id,
            p.gender,
            IF(DATE(p.date_created) = DATE(v.date_started) AND DATE(p.date_created)BETWEEN DATE('#startDate#') AND DATE('#endDate#'), 'New', 'Returning') AS 'Type'
    FROM
        person p
    INNER JOIN visit v ON p.person_id = v.patient_id
        AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id
        AND o.voided = 0
        AND DATE(o.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
    INNER JOIN concept_name cn ON cn.concept_id = o.concept_id
        AND cn.name IN ('Coded Diagnosis')
    LEFT JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded
    WHERE
        p.voided = 0
    GROUP BY o.obs_id , dcv.icd10_code) a;