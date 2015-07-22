SELECT diagnosis_concept_view.concept_full_name as disease, diagnosis_concept_view.icd10_code, parent.concept_full_name AS group_name,
SUM(IF(person.gender = 'F', 1, 0)) AS female,
SUM(IF(person.gender = 'M', 1, 0)) AS male
FROM diagnosis_concept_view
LEFT OUTER JOIN concept_set ON diagnosis_concept_view.concept_id = concept_set.concept_id
LEFT OUTER JOIN concept_view as parent ON concept_set.concept_set = parent.concept_id   
LEFT OUTER JOIN	confirmed_patient_diagnosis_view AS patient_diagnosis ON patient_diagnosis.diagnois_concept_id = diagnosis_concept_view.concept_id 
AND NOT EXISTS (SELECT * 
FROM encounter_view 
WHERE encounter_view.visit_id = patient_diagnosis.visit_id AND encounter_view.encounter_type_name = 'ADMISSION')
AND (patient_diagnosis.obs_datetime BETWEEN '#startDate#' and '#endDate#')
LEFT OUTER JOIN person ON patient_diagnosis.person_id = person.person_id
GROUP BY diagnosis_concept_view.concept_id, diagnosis_concept_view.concept_full_name, diagnosis_concept_view.icd10_code, parent.concept_full_name
ORDER BY group_name, disease;
