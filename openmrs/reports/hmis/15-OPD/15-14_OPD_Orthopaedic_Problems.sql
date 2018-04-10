SELECT 
    c.concept_full_name as Disease,
    c.icd10_code as 'ICD CODE',
    ifnull(b.Female,0) as Female,
	ifnull(b.Male,0) as Male
    
FROM
    (SELECT 
        concept_full_name,icd10_code
    FROM
        diagnosis_concept_view
    WHERE
        icd10_code IN ('V89','M06','M13','M19','M54.9')
    ORDER BY FIELD(icd10_code,'V89','M06','M13','M19','M54.9')) c
        LEFT OUTER JOIN
    (SELECT 
        concept_full_name,
            IF(icd10_code IS NULL, 'R69', icd10_code) AS 'ICD Code',
            COUNT(DISTINCT IF((gender = 'F' ), person_id, NULL)) AS Female,
            COUNT(DISTINCT IF((gender = 'M' ), person_id, NULL)) AS Male
            FROM
        (SELECT 
        dcv.concept_full_name,
            dcv.icd10_code,
            p.person_id,
            p.gender
    FROM
        person p
    INNER JOIN visit v ON p.person_id = v.patient_id
        AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id
        AND o.voided = 0
        AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
        AND cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.name IN ('Non-coded Diagnosis' , 'Coded Diagnosis')
        AND o.voided = 0
        AND cn.voided = 0
    LEFT JOIN diagnosis_concept_view dcv ON
    dcv.concept_id = o.value_coded
    and dcv.icd10_code IN ('V89','M06','M13','M19','M54.9')
    WHERE
        p.voided = 0
    GROUP BY o.obs_id , dcv.icd10_code) a
    GROUP BY concept_full_name) b ON c.concept_full_name = b.concept_full_name

union all 
SELECT 
	 'Fracture/Fall/Injuries' as Disease,
    'T14' as 'ICD CODE',
    ifnull(SUM(male),0) AS Male, 
    ifnull(SUM(Female),0) AS Female
FROM
    (SELECT 
        concept_full_name,
            COUNT(DISTINCT IF((gender = 'F'), obs_id, NULL)) AS Female,
            COUNT(DISTINCT IF((gender = 'M'), obs_id, NULL)) AS Male
    FROM
        (SELECT 
        dcv.concept_full_name, dcv.icd10_code, o.obs_id, p.gender
    FROM
        person p
    INNER JOIN visit v ON p.person_id = v.patient_id
        AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id
        AND o.voided = 0
        AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
        AND cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.name IN ('Non-coded Diagnosis' , 'Coded Diagnosis')
        AND o.voided = 0
        AND cn.voided = 0
    LEFT JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded
        AND dcv.icd10_code IN ('T14.2' , 'T14.1', 'W19')
    WHERE
        p.voided = 0
            AND dcv.icd10_code IS NOT NULL
    GROUP BY o.obs_id , dcv.icd10_code) a
    GROUP BY concept_full_name) b;