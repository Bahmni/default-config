-- Malaria report

-- Parameters
SET @start_date = '2014-11-01';
SET @end_date = '2014-12-30';

-- Query
-- REPORT 1

-- Patients at the end of last month
	SELECT
	patient_last_month.column_name AS 'Particulars',
	SUM(IF((person.gender = 'F' && leprosy_type.value_concept_full_name = 'Multi Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Multi Bacillary, Female',
    SUM(IF((person.gender = 'M' && leprosy_type.value_concept_full_name = 'Multi Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Multi Bacillary, Male',
    SUM(IF((person.gender = 'F' && leprosy_type.value_concept_full_name = 'Pauci Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Pauci Bacillary, Female',
    SUM(IF((person.gender = 'M' && leprosy_type.value_concept_full_name = 'Pauci Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Pauci Bacillary, Male'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN DATE_SUB(@start_date, INTERVAL 1 MONTH) AND DATE_SUB(@end_date, INTERVAL 1 MONTH)
INNER JOIN encounter ON visit.visit_id = encounter.visit_id    
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_type.encounter_id = encounter.encounter_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
LEFT OUTER JOIN obs_view AS leprosy_regimen ON leprosy_regimen.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_regimen.concept_full_name = 'Leprosy, Drug Regimen'
LEFT OUTER JOIN obs_view AS leprosy_supervision ON leprosy_supervision.obs_group_id = leprosy_regimen.obs_group_id
	AND leprosy_supervision.concept_full_name = 'Leprosy, Supervised drug administration for this month'
RIGHT OUTER JOIN
(SELECT 'Patient at the end of last month' AS column_name) AS patient_last_month ON column_name = 'Patient at the end of last month'
GROUP BY patient_last_month.column_name

UNION
-- Total additions
SELECT
	leprosy_case_types_list.answer_concept_name,
	SUM(IF(person.gender = 'F' && leprosy_type.value_concept_full_name = 'Multi Bacillary', 1, 0)) AS 'Multi Bacillary, Female',
    SUM(IF(person.gender = 'M' && leprosy_type.value_concept_full_name = 'Multi Bacillary', 1, 0)) AS 'Multi Bacillary, Male',
    SUM(IF(person.gender = 'F' && leprosy_type.value_concept_full_name = 'Pauci Bacillary', 1, 0)) AS 'Pauci Bacillary, Female',
    SUM(IF(person.gender = 'M' && leprosy_type.value_concept_full_name = 'Pauci Bacillary', 1, 0)) AS 'Pauci Bacillary, Male'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.concept_full_name NOT IN ('Classification Change')
RIGHT OUTER JOIN
(SELECT answer_concept_name FROM concept_answer_view WHERE question_concept_name = 'Leprosy, Case Type' and answer_concept_name NOT IN ('Classification Change')) AS leprosy_case_types_list ON leprosy_case_type.value_concept_full_name = leprosy_case_types_list.answer_concept_name
GROUP BY leprosy_case_types_list.answer_concept_name

UNION
-- Total deducted: 
SELECT
	leprosy_deduction_types_list.answer_concept_name,
	SUM(IF(person.gender = 'F' && leprosy_type.value_concept_full_name = 'Multi Bacillary', 1, 0)) AS 'Multi Bacillary, Female',
    SUM(IF(person.gender = 'M' && leprosy_type.value_concept_full_name = 'Multi Bacillary', 1, 0)) AS 'Multi Bacillary, Male',
    SUM(IF(person.gender = 'F' && leprosy_type.value_concept_full_name = 'Pauci Bacillary', 1, 0)) AS 'Pauci Bacillary, Female',
    SUM(IF(person.gender = 'M' && leprosy_type.value_concept_full_name = 'Pauci Bacillary', 1, 0)) AS 'Pauci Bacillary, Male'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_deduction_type ON encounter.encounter_id = leprosy_deduction_type.encounter_id
	AND leprosy_deduction_type.concept_full_name = 'Leprosy, Patient Deduction Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_deduction_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
RIGHT OUTER JOIN
(SELECT answer_concept_name FROM concept_answer_view WHERE question_concept_name = 'Leprosy, Patient Deduction Type' ) AS leprosy_deduction_types_list ON leprosy_deduction_type.value_concept_full_name = leprosy_deduction_types_list.answer_concept_name
GROUP BY leprosy_deduction_types_list.answer_concept_name
UNION
-- Patient at the end of this month
SELECT
	patients_this_month.column_name,
	SUM(IF((person.gender = 'F' && leprosy_type.value_concept_full_name = 'Multi Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Multi Bacillary, Female',
    SUM(IF((person.gender = 'M' && leprosy_type.value_concept_full_name = 'Multi Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Multi Bacillary, Male',
    SUM(IF((person.gender = 'F' && leprosy_type.value_concept_full_name = 'Pauci Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Pauci Bacillary, Female',
    SUM(IF((person.gender = 'M' && leprosy_type.value_concept_full_name = 'Pauci Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Pauci Bacillary, Male'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id    
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_type.encounter_id = encounter.encounter_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
LEFT OUTER JOIN obs_view AS leprosy_regimen ON leprosy_regimen.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_regimen.concept_full_name = 'Leprosy, Drug Regimen'
LEFT OUTER JOIN obs_view AS leprosy_supervision ON leprosy_supervision.obs_group_id = leprosy_regimen.obs_group_id
	AND leprosy_supervision.concept_full_name = 'Leprosy, Supervised drug administration for this month'
JOIN
(SELECT 'Patient at the end of this month' AS column_name) AS patients_this_month ON column_name = 'Patient at the end of this month'
GROUP BY patients_this_month.column_name
UNION

-- Patient <14years at the end of this month
SELECT
	children_this_month.column_name,
	SUM(IF((person.gender = 'F' && leprosy_type.value_concept_full_name = 'Multi Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Multi Bacillary, Female',
    SUM(IF((person.gender = 'M' && leprosy_type.value_concept_full_name = 'Multi Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Multi Bacillary, Male',
    SUM(IF((person.gender = 'F' && leprosy_type.value_concept_full_name = 'Pauci Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Pauci Bacillary, Female',
    SUM(IF((person.gender = 'M' && leprosy_type.value_concept_full_name = 'Pauci Bacillary' && (leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL )), 1, 0)) AS 'Pauci Bacillary, Male'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
    AND TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) <14
INNER JOIN encounter ON visit.visit_id = encounter.visit_id    
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_type.encounter_id = encounter.encounter_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
LEFT OUTER JOIN obs_view AS leprosy_regimen ON leprosy_regimen.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_regimen.concept_full_name = 'Leprosy, Drug Regimen'
LEFT OUTER JOIN obs_view AS leprosy_supervision ON leprosy_supervision.obs_group_id = leprosy_regimen.obs_group_id
	AND leprosy_supervision.concept_full_name = 'Leprosy, Supervised drug administration for this month'
JOIN
(SELECT 'Patient <14 years at the end of this month' AS column_name) AS children_this_month ON column_name = 'Patient <14 years at the end of this month'
GROUP BY children_this_month.column_name
UNION

-- No. of <14 years patients among new cases
SELECT
	children_new.column_name,
	SUM(IF(person.gender = 'F' && leprosy_type.value_concept_full_name = 'Multi Bacillary', 1, 0)) AS 'Multi Bacillary, Female',
    SUM(IF(person.gender = 'M' && leprosy_type.value_concept_full_name = 'Multi Bacillary', 1, 0)) AS 'Multi Bacillary, Male',
    SUM(IF(person.gender = 'F' && leprosy_type.value_concept_full_name = 'Pauci Bacillary', 1, 0)) AS 'Pauci Bacillary, Female',
    SUM(IF(person.gender = 'M' && leprosy_type.value_concept_full_name = 'Pauci Bacillary', 1, 0)) AS 'Pauci Bacillary, Male'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
    AND TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) <14
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
JOIN
(SELECT 'No of < 14 years patients among new cases' AS column_name) AS children_new ON column_name = 'No of < 14 years patients among new cases'
GROUP BY children_new.column_name;

-- REPORT 2
-- New cases
SELECT
	new_cases.column_name,
	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 0', 1, 0)) AS 'Grade 0, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 0', 1, 0)) AS 'Grade 0, Male',
   	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 1', 1, 0)) AS 'Grade 1, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 1', 1, 0)) AS 'Grade 1, Male',
   	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 2', 1, 0)) AS 'Grade 2, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 2', 1, 0)) AS 'Grade 2, Male',
	SUM(IF(person.gender = 'F' && (leprosy_grade.value_concept_full_name = 'Not examined' || leprosy_grade.value_concept_full_name IS NULL), 1, 0)) AS 'Not examined, Female',
    SUM(IF(person.gender = 'M' && (leprosy_grade.value_concept_full_name = 'Not examined' || leprosy_grade.value_concept_full_name IS NULL), 1, 0)) AS 'Not examined, Male'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
LEFT OUTER JOIN coded_obs_view AS leprosy_grade ON leprosy_case_type.obs_group_id = leprosy_grade.obs_group_id
	AND leprosy_grade.concept_full_name = 'Leprosy, Disability Grade'
RIGHT OUTER JOIN
(SELECT 'New cases' AS column_name) AS new_cases ON column_name = 'New cases'
GROUP BY new_cases.column_name
UNION
-- New cases <14 years children
SELECT
	new_children.column_name,
	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 0', 1, 0)) AS 'Grade 0, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 0', 1, 0)) AS 'Grade 0, Male',
   	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 1', 1, 0)) AS 'Grade 1, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 1', 1, 0)) AS 'Grade 1, Male',
   	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 2', 1, 0)) AS 'Grade 2, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 2', 1, 0)) AS 'Grade 2, Male',
	SUM(IF(person.gender = 'F' && (leprosy_grade.value_concept_full_name = 'Not examined' || leprosy_grade.value_concept_full_name IS NULL), 1, 0)) AS 'Not examined, Female',
    SUM(IF(person.gender = 'M' && (leprosy_grade.value_concept_full_name = 'Not examined' || leprosy_grade.value_concept_full_name IS NULL), 1, 0)) AS 'Not examined, Male'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
    AND TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) < 14
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
LEFT OUTER JOIN coded_obs_view AS leprosy_grade ON leprosy_case_type.obs_group_id = leprosy_grade.obs_group_id
	AND leprosy_grade.concept_full_name = 'Leprosy, Disability Grade'
RIGHT OUTER JOIN
(SELECT 'New < 14 years children' AS column_name) AS new_children ON column_name = 'New < 14 years children'
GROUP BY new_children.column_name

UNION
-- Released from treatment(RFT)
SELECT
	rft.column_name,
	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 0', 1, 0)) AS 'Grade 0, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 0', 1, 0)) AS 'Grade 0, Male',
   	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 1', 1, 0)) AS 'Grade 1, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 1', 1, 0)) AS 'Grade 1, Male',
   	SUM(IF(person.gender = 'F' && leprosy_grade.value_concept_full_name = 'Grade 2', 1, 0)) AS 'Grade 2, Female',
    SUM(IF(person.gender = 'M' && leprosy_grade.value_concept_full_name = 'Grade 2', 1, 0)) AS 'Grade 2, Male',
	SUM(IF(person.gender = 'F' && (leprosy_grade.value_concept_full_name = 'Not examined' || leprosy_grade.value_concept_full_name IS NULL), 1, 0)) AS 'Not examined, Female',
    SUM(IF(person.gender = 'M' && (leprosy_grade.value_concept_full_name = 'Not examined' || leprosy_grade.value_concept_full_name IS NULL), 1, 0)) AS 'Not examined, Male'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_rft ON encounter.encounter_id = leprosy_rft.encounter_id
	AND leprosy_rft.concept_full_name = 'Leprosy, Patient Deduction Type'
    AND leprosy_rft.value_concept_full_name = 'Release from Treatment – RFT'
LEFT OUTER JOIN coded_obs_view AS leprosy_grade ON leprosy_rft.obs_group_id = leprosy_grade.obs_group_id
	AND leprosy_grade.concept_full_name = 'Leprosy, Disability Grade'
RIGHT OUTER JOIN
(SELECT 'Released from Treatment(RFT)' AS column_name) AS rft ON column_name = 'Released from Treatment(RFT)'
GROUP BY rft.column_name;

-- REPORT 3
-- MB, Total registered, RFT, Defaulter, Other deducted
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
   	SUM(IF(person.gender = 'F' && leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD', 1, 0)) AS other_female ,
    SUM(IF(person.gender = 'M' && leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD', 1, 0)) AS other_male 
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN DATE_SUB(@start_date, INTERVAL 18 MONTH) AND DATE_SUB(@end_date, INTERVAL 18 MONTH)
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Multi Bacillary'
LEFT OUTER JOIN visit AS visit_final ON visit.patient_id = person.person_id
	AND visit_final.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter AS encounter_final ON visit_final.visit_id = encounter_final.visit_id
INNER JOIN coded_obs_view AS leprosy_deduction_type ON encounter.encounter_id = leprosy_deduction_type.encounter_id
	AND leprosy_deduction_type.concept_full_name = 'Leprosy, Patient Deduction Type'
	AND leprosy_deduction_type.value_concept_full_name IN ('Release from Treatment – RFT', 'Defaulter – DF', 'Other Deduction - OD')
) AS table1
-- MB, currently in treatment
JOIN
(SELECT
  'MB after 18 month' AS row_name,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'F', 1, 0)) AS current_female,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'M', 1, 0)) AS current_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN DATE_SUB(@start_date, INTERVAL 18 MONTH) AND DATE_SUB(@end_date, INTERVAL 18 MONTH)
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Multi Bacillary'
INNER JOIN visit AS visit_final ON visit.patient_id = person.person_id
	AND visit_final.date_started BETWEEN @start_date AND @end_date
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
   	SUM(IF(person.gender = 'F' && leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD', 1, 0)) AS other_female ,
    SUM(IF(person.gender = 'M' && leprosy_deduction_type.value_concept_full_name = 'Other Deduction - OD', 1, 0)) AS other_male 
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN DATE_SUB(@start_date, INTERVAL 9 MONTH) AND DATE_SUB(@end_date, INTERVAL 9 MONTH)
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Pauci Bacillary'
LEFT OUTER JOIN visit AS visit_final ON visit.patient_id = person.person_id
	AND visit_final.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter AS encounter_final ON visit_final.visit_id = encounter_final.visit_id
INNER JOIN coded_obs_view AS leprosy_deduction_type ON encounter.encounter_id = leprosy_deduction_type.encounter_id
	AND leprosy_deduction_type.concept_full_name = 'Leprosy, Patient Deduction Type'
	AND leprosy_deduction_type.value_concept_full_name IN ('Release from Treatment – RFT', 'Defaulter – DF', 'Other Deduction - OD')
) AS table1

-- PB, currently in treatment
JOIN
(SELECT
  'PB after 9 month' AS row_name,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'F', 1, 0)) AS current_female,
  SUM(IF((leprosy_regimen.value_text IS NOT NULL || leprosy_supervision.value_coded IS NOT NULL) && person.gender = 'M', 1, 0)) AS current_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN DATE_SUB(@start_date, INTERVAL 9 MONTH) AND DATE_SUB(@end_date, INTERVAL 9 MONTH)
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS leprosy_case_type ON encounter.encounter_id = leprosy_case_type.encounter_id
	AND leprosy_case_type.concept_full_name = 'Leprosy, Case Type'
INNER JOIN coded_obs_view AS leprosy_type ON leprosy_case_type.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_type.concept_full_name = 'Leprosy, Leprosy Type'
    AND leprosy_type.value_concept_full_name = 'Pauci Bacillary'
INNER JOIN visit AS visit_final ON visit.patient_id = person.person_id
	AND visit_final.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter AS encounter_final ON visit_final.visit_id = encounter_final.visit_id
LEFT OUTER JOIN obs_view AS leprosy_regimen ON leprosy_regimen.obs_group_id = leprosy_type.obs_group_id
	AND leprosy_regimen.concept_full_name = 'Leprosy, Drug Regimen'
LEFT OUTER JOIN obs_view AS leprosy_supervision ON leprosy_supervision.obs_group_id = leprosy_regimen.obs_group_id
	AND leprosy_supervision.concept_full_name = 'Leprosy, Supervised drug administration for this month') 
AS table2 ON table1.row_name = table2.row_name;

