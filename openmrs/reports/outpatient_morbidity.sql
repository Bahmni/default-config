-- Parameters
SET @start_date = '2014-09-01';
SET @end_date = '2014-10-01';

-- Constants
SET @admission_encounter_type = 'ADMISSION';

-- Query
SELECT diagnosis_concept_view.concept_full_name, diagnosis_concept_view.icd10_code, concept_reference_term_map_view.concept_reference_term_name AS group_name,
SUM(IF(person.gender = 'F', 1, 0)) AS female,
SUM(IF(person.gender = 'M', 1, 0)) AS male
FROM diagnosis_concept_view
LEFT OUTER JOIN concept_reference_term_map_view ON concept_reference_term_map_view.concept_id = diagnosis_concept_view.concept_id
			AND concept_reference_term_map_view.concept_reference_source_name = 'ICD 10 - WHO' AND concept_reference_term_map_view.concept_map_type_name = 'NARROWER-THAN'
LEFT OUTER JOIN	confirmed_patient_diagnosis_view AS patient_diagnosis ON patient_diagnosis.diagnois_concept_id = diagnosis_concept_view.concept_id 
	AND NOT EXISTS (SELECT * 
					FROM encounter_view 
					WHERE encounter_view.visit_id = patient_diagnosis.visit_id AND encounter_view.encounter_type_name = @admission_encounter_type)
	AND (patient_diagnosis.obs_datetime BETWEEN @start_date AND @end_date)
LEFT OUTER JOIN person ON patient_diagnosis.person_id = person.person_id
GROUP BY diagnosis_concept_view.concept_id, diagnosis_concept_view.concept_full_name, diagnosis_concept_view.icd10_code, concept_reference_term_map_view.concept_reference_term_name
ORDER BY group_name, concept_full_name;