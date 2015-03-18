SELECT
	table1.row_name AS 'Cohort of new registered patients',
    table1.total_female AS 'Total Registered, Female',
    table1.total_male AS 'Total Registered, Male',
    table1.rft_female AS 'RFT, Female',
    table1.rft_male AS 'RFT. Male',
    table1.defaulter_female AS 'Defaulter, Female',
    table1.defaulter_male AS 'Defaulter. Male',
    table1.other_female AS 'Other deducted, Female',
    table1.other_male AS 'Other deducted. Male',
    table2.current_female AS 'Currently in Treatment, Female',
    table2.current_male AS 'Currently in Treatment, Male'
    
FROM
(SELECT
	'MB after 18 month' AS row_name,
	SUM(IF(person.gender = 'F', 1, 0)) AS total_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS total_male,
	SUM(IF(person.gender = 'F' && leprosy_deduction_type.value_concept_full_name = 'Release from Treatment – RFT', 1, 0)) AS rft_female ,
    SUM(IF(person.gender = 'M' && leprosy_deduction_type.value_concept_full_name = 'Release from Treatment – RFT', 1, 0)) AS rft_male ,
   	SUM(IF(person.gender = 'F' && leprosy_deduction_type.value_concept_full_name = 'Defaulter – DF', 1, 0)) AS defaulter_female ,
    SUM(IF(person.gender = 'M' && leprosy_deduction_type.value_concept_full_name = 'Defaulter – DF', 1, 0)) AS defaulter_male ,
   	SUM(IF(person.gender = 'F' && (leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD'||leprosy_deduction_type.value_concept_full_name = 'Transfer Out - TO'), 1, 0)) AS other_female ,
    SUM(IF(person.gender = 'M' && (leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD'||leprosy_deduction_type.value_concept_full_name = 'Transfer Out - TO'), 1, 0)) AS other_male 
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN DATE_SUB('#startDate#', INTERVAL 18 MONTH) AND DATE_SUB('#endDate#', INTERVAL 18 MONTH)
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Multi Bacillary'
LEFT OUTER JOIN visit AS visit_final ON visit_final.patient_id = person.person_id
	AND DATE(visit_final.date_started) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN encounter AS encounter_final ON visit_final.visit_id = encounter_final.visit_id
INNER JOIN coded_obs_view AS leprosy_deduction_type ON encounter_final.encounter_id = leprosy_deduction_type.encounter_id
	AND leprosy_deduction_type.concept_full_name = 'Leprosy, Patient Deduction Type'
	AND leprosy_deduction_type.value_concept_full_name IN ('Release from Treatment – RFT', 'Defaulter – DF', 'Other Deduction - OD', 'Transfer Out - TO')
) AS table1
-- MB, currently in treatment
JOIN
(SELECT
  'MB after 18 month' AS row_name,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'F', 1, 0)) AS current_female,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'M', 1, 0)) AS current_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN DATE_SUB('#startDate#', INTERVAL 18 MONTH) AND DATE_SUB('#endDate#', INTERVAL 18 MONTH)
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Multi Bacillary'
INNER JOIN visit AS visit_final ON visit_final.patient_id = person.person_id
	AND DATE(visit_final.date_started) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN encounter AS encounter_final ON visit_final.visit_id = encounter_final.visit_id
LEFT OUTER JOIN obs_view AS leprosy_regimen ON leprosy_regimen.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_regimen.concept_full_name = 'Leprosy, Drug Regimen'
LEFT OUTER JOIN obs_view AS leprosy_supervision ON leprosy_supervision.obs_group_id = leprosy_regimen.obs_group_id
	AND leprosy_supervision.concept_full_name = 'Leprosy, Supervised drug administration for this month') 
AS table2 ON table1.row_name = table2.row_name

-- PB, Total registered, RFT, Defaulter, Other deducted
UNION

SELECT
	table1.row_name AS 'Cohort of new registered patients',
    table1.total_female AS 'Total Registered, Female',
    table1.total_male AS 'Total Registered, Male',
    table1.rft_female AS 'RFT, Female',
    table1.rft_male AS 'RFT. Male',
    table1.defaulter_female AS 'Defaulter, Female',
    table1.defaulter_male AS 'Defaulter. Male',
    table1.other_female AS 'Other deducted, Female',
    table1.other_male AS 'Other deducted. Male',
    table2.current_female AS 'Currently in Treatment, Female',
    table2.current_male AS 'Currently in Treatment, Male'
    
FROM
(SELECT
	'PB after 9 month' AS row_name,
	SUM(IF(person.gender = 'F', 1, 0)) AS total_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS total_male,
	SUM(IF(person.gender = 'F' && leprosy_deduction_type.value_concept_full_name = 'Release from Treatment – RFT', 1, 0)) AS rft_female ,
    SUM(IF(person.gender = 'M' && leprosy_deduction_type.value_concept_full_name = 'Release from Treatment – RFT', 1, 0)) AS rft_male ,
   	SUM(IF(person.gender = 'F' && leprosy_deduction_type.value_concept_full_name = 'Defaulter – DF', 1, 0)) AS defaulter_female ,
    SUM(IF(person.gender = 'M' && leprosy_deduction_type.value_concept_full_name = 'Defaulter – DF', 1, 0)) AS defaulter_male ,
   	SUM(IF(person.gender = 'F' && (leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD'||leprosy_deduction_type.value_concept_full_name = 'Transfer Out - TO'), 1, 0)) AS other_female ,
    SUM(IF(person.gender = 'M' && (leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD'||leprosy_deduction_type.value_concept_full_name = 'Transfer Out - TO'), 1, 0)) AS other_male 
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN DATE_SUB('#startDate#', INTERVAL 9 MONTH) AND DATE_SUB('#endDate#', INTERVAL 9 MONTH)
    INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Pauci Bacillary'
LEFT OUTER JOIN visit AS visit_final ON visit_final.patient_id = person.person_id
	AND DATE(visit_final.date_started) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN encounter AS encounter_final ON visit_final.visit_id = encounter_final.visit_id
INNER JOIN coded_obs_view AS leprosy_deduction_type ON encounter_final.encounter_id = leprosy_deduction_type.encounter_id
	AND leprosy_deduction_type.concept_full_name = 'Leprosy, Patient Deduction Type'
	AND leprosy_deduction_type.value_concept_full_name IN ('Release from Treatment – RFT', 'Defaulter – DF', 'Other Deduction - OD','Transfer Out - TO')
) AS table1

-- PB, currently in treatment
JOIN
(SELECT
  'PB after 9 month' AS row_name,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'F', 1, 0)) AS current_female,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'M', 1, 0)) AS current_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
 	AND DATE(visit.date_started) BETWEEN DATE_SUB('#startDate#', INTERVAL 9 MONTH) AND DATE_SUB('#endDate#', INTERVAL 9 MONTH)
	INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Pauci Bacillary'
INNER JOIN visit AS visit_final ON visit_final.patient_id = person.person_id
	AND DATE(visit_final.date_started) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN encounter AS encounter_final ON visit_final.visit_id = encounter_final.visit_id
LEFT OUTER JOIN obs_view AS leprosy_regimen ON leprosy_regimen.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_regimen.concept_full_name = 'Leprosy, Drug Regimen'
LEFT OUTER JOIN obs_view AS leprosy_supervision ON leprosy_supervision.obs_group_id = leprosy_regimen.obs_group_id
	AND leprosy_supervision.concept_full_name = 'Leprosy, Supervised drug administration for this month') 
AS table2 ON table1.row_name = table2.row_name;