-- Parameters
SET @start_date = '2014-09-01';
SET @end_date = '2014-10-01';

-- Constants
SET @discharge_encounter_type = 'DISCHARGE';
SET @report_group_name = 'Inpatient Discharge Reports';

-- Query for disease age group count
SELECT diagnosis_concept_view.icd10_code, diagnosis_concept_view.concept_full_name as disease,
observed_age_group.name AS age_group,
SUM(IF(person.gender = 'F', 1, 0)) AS female,
SUM(IF(person.gender = 'M', 1, 0)) AS male
FROM diagnosis_concept_view
JOIN confirmed_patient_diagnosis_view ON confirmed_patient_diagnosis_view.diagnois_concept_id = diagnosis_concept_view.concept_id 
JOIN person ON confirmed_patient_diagnosis_view.person_id = person.person_id
JOIN encounter_view as discharge_encounter ON discharge_encounter.visit_id = confirmed_patient_diagnosis_view.visit_id
											AND discharge_encounter.encounter_type_name = @discharge_encounter_type
JOIN possible_age_group as observed_age_group ON observed_age_group.report_group_name = @report_group_name AND
					confirmed_patient_diagnosis_view.obs_datetime BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY)) 
					AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))  
WHERE discharge_encounter.encounter_datetime BETWEEN @start_date AND @end_date
GROUP BY diagnosis_concept_view.concept_id, diagnosis_concept_view.concept_full_name, diagnosis_concept_view.icd10_code, observed_age_group.id
ORDER BY disease;

-- Query for disease and death count
SELECT diagnosis_concept_view.icd10_code, diagnosis_concept_view.concept_full_name as disease,
SUM(IF(person.gender = 'F', 1, 0)) AS female_death,
SUM(IF(person.gender = 'M', 1, 0)) AS male_death
FROM diagnosis_concept_view
JOIN confirmed_patient_diagnosis_view ON confirmed_patient_diagnosis_view.diagnois_concept_id = diagnosis_concept_view.concept_id 
JOIN person ON confirmed_patient_diagnosis_view.person_id = person.person_id AND person.dead = 1
					   AND person.death_date BETWEEN @start_date AND @end_date
JOIN encounter_view as discharge_encounter ON discharge_encounter.visit_id = confirmed_patient_diagnosis_view.visit_id
											AND discharge_encounter.encounter_type_name = @discharge_encounter_type
WHERE discharge_encounter.encounter_datetime BETWEEN @start_date AND @end_date
GROUP BY diagnosis_concept_view.concept_id, diagnosis_concept_view.concept_full_name, diagnosis_concept_view.icd10_code
ORDER BY disease;