-- Tuberculosis report

-- Parameters
SET @start_date = '2015-02-01';
SET @end_date = '2015-03-20';

-- Query
-- Case Registration (1)
 SELECT case_types.name_value AS 'Case Registration',
	SUM(IF(diagnosis_category.value_concept_full_name = 'New Diagnosis' && person.gender = 'F',1,0)) AS 'New-F',
	SUM(IF(diagnosis_category.value_concept_full_name = 'New Diagnosis' && person.gender = 'M',1,0)) AS 'New-M',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Relapse' && person.gender = 'F',1,0)) AS 'Relapse-F',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Relapse' && person.gender = 'M',1,0)) AS 'Relapse-M',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Treatment after failure' && person.gender = 'F',1,0)) AS 'Treatment after failure-F',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Treatment after failure' && person.gender = 'M',1,0)) AS 'Treatment after failure-M',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Treatment after loss to follow-up' && person.gender = 'F',1,0)) AS 'Treatment after loss to follow-up-F',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Treatment after loss to follow-up' && person.gender = 'M',1,0)) AS 'Treatment after loss to follow-up-M',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Other previously treated' && person.gender = 'F',1,0)) AS 'Other previously treated-F',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Other previously treated' && person.gender = 'M',1,0)) AS 'Other previously treated-M',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Previous treatment history unknown' && person.gender = 'F',1,0)) AS 'Previous treatment history unknown-F',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Previous treatment history unknown' && person.gender = 'M',1,0)) AS 'Previous treatment history unknown-M',
   	SUM(IF(diagnosis_category.value_concept_full_name = 'Transfer in' && person.gender = 'F',1,0)) AS 'Transfer in-F',
	SUM(IF(diagnosis_category.value_concept_full_name = 'Transfer in' && person.gender = 'M',1,0)) AS 'Transfer in-M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.obs_group_id = tuberculosis_type.obs_group_id
	AND diagnosis_category.concept_full_name = 'Tuberculosis, Diagnosis Category'
RIGHT OUTER JOIN (SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Tuberculosis-Case Registration') AS case_types ON case_types.name_key = tuberculosis_type.value_concept_full_name
GROUP BY case_types.name_value
ORDER BY case_types.sort_order;

-- Registration(BC or CD) [2]
SELECT diagnosis_types.name_value AS 'Registration(BC or CD)',
	   SUM(IF(possible_age_group.name = '0 - 4 years' && person.gender = 'F',1,0)) AS '0-4Years, F',
       SUM(IF(possible_age_group.name = '0 - 4 years' && person.gender = 'M',1,0)) AS '0-4Years, M',
       SUM(IF(possible_age_group.name = '5 - 14 years' && person.gender = 'F',1,0)) AS '5-14Years, F',
       SUM(IF(possible_age_group.name = '5 - 14 years' && person.gender = 'M',1,0)) AS '5-14Years, M',
       SUM(IF(possible_age_group.name = '15 - 24 years' && person.gender = 'F',1,0)) AS '15-24Years, F',
       SUM(IF(possible_age_group.name = '15 - 24 years' && person.gender = 'M',1,0)) AS '15-24Years, M',
       SUM(IF(possible_age_group.name = '25 - 34 years' && person.gender = 'F',1,0)) AS '25-34Years, F',
       SUM(IF(possible_age_group.name = '25 - 34 years' && person.gender = 'M',1,0)) AS '25-34Years, M',
       SUM(IF(possible_age_group.name = '35 - 44 years' && person.gender = 'F',1,0)) AS '35-44Years, F',
       SUM(IF(possible_age_group.name = '35 - 44 years' && person.gender = 'M',1,0)) AS '35-44Years, M',
       SUM(IF(possible_age_group.name = '45 - 54 years' && person.gender = 'F',1,0)) AS '45-54Years, F',
       SUM(IF(possible_age_group.name = '45 - 54 years' && person.gender = 'M',1,0)) AS '45-54Years, M',
       SUM(IF(possible_age_group.name = '55 - 64 years' && person.gender = 'F',1,0)) AS '55-64Years, F',
       SUM(IF(possible_age_group.name = '55 - 64 years' && person.gender = 'M',1,0)) AS '55-64Years, M',
       SUM(IF(possible_age_group.name = '>/65 years' && person.gender = 'F',1,0)) AS '>/65Years, F',
       SUM(IF(possible_age_group.name = '>/65 years' && person.gender = 'M',1,0)) AS '>/65Years, M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
    AND tuberculosis_type.value_concept_full_name IN ('Pulmonary BC', 'Pulmonary CD')
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.obs_group_id = tuberculosis_type.obs_group_id
	AND diagnosis_category.concept_full_name = 'Tuberculosis, Diagnosis Category'
    AND diagnosis_category.value_concept_full_name IN ('New Diagnosis', 'Relapse')
INNER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
						AND possible_age_group.report_group_name = 'Tuberculosis registration'
RIGHT OUTER JOIN (SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Tuberculosis-Registration') AS diagnosis_types ON diagnosis_types.name_key = tuberculosis_type.value_concept_full_name
GROUP BY diagnosis_types.name_value
ORDER BY diagnosis_types.sort_order;

-- Private sector and Community involvement in Referral/Diagnosis[5]
SELECT referral_types.name_value AS 'Pri. sector & Comm. involvement in Ref./Diag.',
	   SUM(IF(tuberculosis_type.value_concept_full_name = 'Pulmonary BC' && diagnosis_category.value_concept_full_name = 'New Diagnosis' && person.gender = 'F',1,0)) AS 'PBC(New)-F',
       SUM(IF(tuberculosis_type.value_concept_full_name = 'Pulmonary BC' && diagnosis_category.value_concept_full_name = 'New Diagnosis' && person.gender = 'M',1,0)) AS 'PBC(New)-M',
	   SUM(IF(tuberculosis_type.value_concept_full_name = 'Pulmonary BC' && diagnosis_category.value_concept_full_name != 'New Diagnosis' && person.gender = 'F',1,0)) AS 'PBC(Excl. New)-F',       
       SUM(IF(tuberculosis_type.value_concept_full_name = 'Pulmonary BC' && diagnosis_category.value_concept_full_name != 'New Diagnosis' && person.gender = 'M',1,0)) AS 'PBC(Excl. New)-M',
	   SUM(IF(tuberculosis_type.value_concept_full_name = 'Pulmonary CD' && person.gender = 'F',1,0)) AS 'PCD(All)-F',       
       SUM(IF(tuberculosis_type.value_concept_full_name = 'Pulmonary CD' && person.gender = 'M',1,0)) AS 'PCD(All)-M',
       SUM(IF(tuberculosis_type.value_concept_full_name = 'Extra pulmonary' && person.gender = 'F',1,0)) AS 'EP(All)-F',
       SUM(IF(tuberculosis_type.value_concept_full_name = 'Extra pulmonary' && person.gender = 'M',1,0)) AS 'EP(All)-M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.obs_group_id = tuberculosis_type.obs_group_id
	AND diagnosis_category.concept_full_name = 'Tuberculosis, Diagnosis Category'
INNER JOIN coded_obs_view AS referral_type ON referral_type.encounter_id = tuberculosis_type.encounter_id
	AND referral_type.concept_full_name = 'Tuberculosis, Referred by'
RIGHT OUTER JOIN (SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Tuberculosis-Referral') AS referral_types ON referral_types.name_key = referral_type.value_concept_full_name
GROUP BY referral_types.name_value
ORDER BY referral_types.sort_order;

-- Registration by treatment category[3]
 SELECT treatment_category.name_value AS 'Sex of Patient',
	   SUM(IF(tuberculosis_treatment.value_concept_full_name = 'Category I' && visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 15 YEAR), INTERVAL 0 DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 999 YEAR), INTERVAL 0 DAY)) ,1,0)) AS 'Adult-Cat I',
	   SUM(IF(tuberculosis_treatment.value_concept_full_name = 'Category II' && visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 15 YEAR), INTERVAL 0 DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 999 YEAR), INTERVAL 0 DAY)) ,1,0)) AS 'Adult-Cat II',
	   SUM(IF(tuberculosis_treatment.value_concept_full_name = 'Category I' && visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 0 YEAR), INTERVAL 0 DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 15 YEAR), INTERVAL -1 DAY)) ,1,0)) AS 'Child(0-14years)-Cat I',
	   SUM(IF(tuberculosis_treatment.value_concept_full_name = 'Category II' && visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 0 YEAR), INTERVAL 0 DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 15 YEAR), INTERVAL -1 DAY)) ,1,0)) AS 'Child(0-14years)-Cat II',
	   SUM(IF(tuberculosis_treatment.value_concept_full_name = 'Category III' && visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 0 YEAR), INTERVAL 0 DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 15 YEAR), INTERVAL -1 DAY)) ,1,0)) AS 'Child(0-14years)-Cat III'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_treatment ON tuberculosis_treatment.encounter_id = encounter.encounter_id
	AND tuberculosis_treatment.concept_full_name = 'Tuberculosis, Treatment Type'
RIGHT OUTER JOIN (SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Generic') AS treatment_category ON treatment_category.name_key = person.gender
GROUP BY treatment_category.name_value
ORDER BY treatment_category.sort_order;


-- HIV status at the time of TB Diagnosis
-- Patients tested for HIV

SELECT patients_tested.gender AS "Gender", patients_tested.patients_count AS "TB Patients Tested for HIV"
FROM
(SELECT person_gender.gender, COUNT(DISTINCT person.person_id) AS patients_count
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Tuberculosis','Multi Drug Resistant Tuberculosis', 'Extremely Drug Resistant Tuberculosis')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
INNER JOIN orders ON orders.patient_id = person.person_id
    AND orders.order_type_id = 3 
	AND orders.order_action IN ('NEW', 'REVISED')
    AND orders.date_created BETWEEN @start_date AND @end_date
INNER JOIN concept_view ON orders.concept_id = concept_view.concept_id
	AND concept_view.concept_full_name IN ('HIV (Blood)', 'HIV (Serum)')
RIGHT OUTER JOIN (SELECT DISTINCT gender FROM person WHERE gender != '' ) AS person_gender ON person_gender.gender = person.gender  
GROUP BY person_gender.gender) AS patients_tested;
INNER JOIN
-- With known HIV status
(SELECT person.gender,
	SUM(IF(hiv_status.value_concept_full_name != 'Unknown' ,1,0)) AS hiv_status_count
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS hiv_status ON hiv_status.encounter_id = encounter.encounter_id
	AND hiv_status.concept_full_name = 'Tuberculosis, HIV Infection'
GROUP BY person.gender) AS hiv_status ON hiv_status.gender = patients_tested.gender;

-- RIGHT OUTER JOIN (SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Generic') AS row_headers ON row_headers.name_key = person.gender
-- GROUP BY row_headers.name_value
-- ORDER BY row_headers.sort_order;



-- TB HIV activities
-- Sputum Smear Examination

--  Treatment outcome
(SELECT
	outcome_category_list.name_value AS 'Diagnosis type',		
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M', 
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'M',1,0)) AS 'Not Evaluated-M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
    AND tuberculosis_type.value_concept_full_name = 'Pulmonary BC'
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.obs_group_id = tuberculosis_type.obs_group_id
	AND diagnosis_category.concept_full_name = 'Tuberculosis, Diagnosis Category'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
	AND treatment_outcome.concept_full_name = 'Tuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN 
	(SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Tuberculosis-PBC Treatment outcome') AS outcome_category_list
	ON diagnosis_category.value_concept_full_name = outcome_category_list.name_key
GROUP BY outcome_category_list.name_value
ORDER BY outcome_category_list.sort_order)    

UNION

(SELECT 'PBC - HIV +ve, All Types' AS 'Diagnosis type',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'M',1,0)) AS 'Not Evaluated-M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
	AND tuberculosis_type.value_concept_full_name = 'Pulmonary BC'
INNER JOIN coded_obs_view AS hiv_status ON hiv_status.obs_group_id = tuberculosis_type.obs_group_id
	AND hiv_status.concept_full_name = 'Tuberculosis, HIV Infection'
    AND hiv_status.value_concept_full_name = 'Yes'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
	AND treatment_outcome.concept_full_name = 'Tuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN
	(SELECT 'PBC - HIV +ve, All Types' AS name) AS hiv_header ON hiv_header.name = 'PBC - HIV +ve, All Types'
GROUP BY hiv_header.name)

UNION

(SELECT pcd_outcome.name_value AS 'Diagnosis type',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M', 
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'M',1,0)) AS 'Not Evaluated-M'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
	AND DATE(encounter_datetime) BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
    AND tuberculosis_type.value_concept_full_name = 'Pulmonary CD'
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.obs_group_id = tuberculosis_type.obs_group_id
	AND diagnosis_category.concept_full_name = 'Tuberculosis, Diagnosis Category'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
 	AND treatment_outcome.concept_full_name = 'Tuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN 
	(SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Tuberculosis-PCD Treatment outcome') AS pcd_outcome
	ON diagnosis_category.value_concept_full_name = pcd_outcome.name_key
GROUP BY pcd_outcome.name_value
ORDER BY pcd_outcome.sort_order)     

UNION

(SELECT 
	ep_outcome.name_value AS 'Diagnosis type',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M', 
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'M',1,0)) AS 'Not Evaluated-M'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
	AND DATE(encounter_datetime) BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
    AND tuberculosis_type.value_concept_full_name = 'Extra pulmonary'
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.obs_group_id = tuberculosis_type.obs_group_id
	AND diagnosis_category.concept_full_name = 'Tuberculosis, Diagnosis Category'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
 	AND treatment_outcome.concept_full_name = 'Tuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN 
	(SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Tuberculosis-EP Treatment outcome') AS ep_outcome
	ON diagnosis_category.value_concept_full_name = ep_outcome.name_key
GROUP BY ep_outcome.name_value
ORDER BY ep_outcome.sort_order)      

UNION

(SELECT
	'PCD & EP (BC or CD) HIV +ve, All Types' AS 'Diagnosis type',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF((treatment_outcome.value_concept_full_name = 'Transferred out' || treatment_outcome.value_concept_full_name = 'Moved to second line treatment register') && person.gender = 'M',1,0)) AS 'Not Evaluated-M'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'Tuberculosis, Type'
	AND tuberculosis_type.value_concept_full_name IN ('Pulmonary BC', 'Extra pulmonary')
INNER JOIN coded_obs_view AS hiv_status ON hiv_status.obs_group_id = tuberculosis_type.obs_group_id
	AND hiv_status.concept_full_name = 'Tuberculosis, HIV Infection'
    AND hiv_status.value_concept_full_name = 'Yes'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
	AND treatment_outcome.concept_full_name = 'Tuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN
	(SELECT 'PCD & EP (BC or CD) HIV +ve, All Types' AS name) AS hiv_header ON hiv_header.name = 'PCD & EP (BC or CD) HIV +ve, All Types'
GROUP BY hiv_header.name);


-- Drug Resistant(DR) TB Case Registration


SELECT drtb_registration.name_value AS 'Diagnosis type',
	SUM(IF(diagnosis_category.value_concept_full_name IS NOT NULL && entries.gender = 'F',1,0)) AS 'Female', 
    SUM(IF(diagnosis_category.value_concept_full_name IS NOT NULL && entries.gender = 'M',1,0)) AS 'Male' 
FROM
(SELECT person.person_id, person.gender, MAX(diagnosis_category.obs_datetime) AS latest_obs
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
-- INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Multi Drug Resistant Tuberculosis','Extremely Drug Resistant Tuberculosis')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.person_id = person.person_id
	AND diagnosis_category.concept_full_name = 'DRTuberculosis, Diagnosis Category'
GROUP BY person.person_id) AS entries
LEFT OUTER JOIN coded_obs_view AS diagnosis_category
	ON diagnosis_category.obs_datetime = entries.latest_obs
    AND diagnosis_category.concept_full_name = 'DRTuberculosis, Diagnosis Category'
    AND diagnosis_category.person_id = entries.person_id   
RIGHT OUTER JOIN 
	(SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'DRTuberculosis-Case Registration') AS drtb_registration
	ON diagnosis_category.value_concept_full_name = drtb_registration.name_key
GROUP BY drtb_registration.name_value
ORDER BY drtb_registration.sort_order;





SELECT 'HIV +ve RR/MDR-TB' AS 'Diagnosis type',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF(treatment_outcome.value_concept_full_name IS NULL && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF(treatment_outcome.value_concept_full_name IS NULL && person.gender = 'M',1,0)) AS 'Not Evaluated-M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'MDRTuberculosis, Type'
INNER JOIN coded_obs_view AS hiv_status ON hiv_status.obs_group_id = tuberculosis_type.obs_group_id
	AND hiv_status.concept_full_name = 'MDRTuberculosis, HIV Infection'
    AND hiv_status.value_concept_full_name = 'Yes'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
	AND treatment_outcome.concept_full_name = 'Tuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN
	(SELECT 'HIV +ve, All Types' AS name) AS hiv_header ON hiv_header.name = 'HIV +ve, All Types'
GROUP BY hiv_header.name;

SELECT 'HIV +ve RR/MDR-TB' AS 'Diagnosis type',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF(treatment_outcome.value_concept_full_name IS NULL && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF(treatment_outcome.value_concept_full_name IS NULL && person.gender = 'M',1,0)) AS 'Not Evaluated-M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'MDRTuberculosis, Type'
INNER JOIN coded_obs_view AS hiv_status ON hiv_status.obs_group_id = tuberculosis_type.obs_group_id
	AND hiv_status.concept_full_name = 'MDRTuberculosis, HIV Infection'
    AND hiv_status.value_concept_full_name = 'Yes'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
	AND treatment_outcome.concept_full_name = 'Tuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN
	(SELECT 'All confirmed XDR-TB' AS name) AS xdr_tb_header ON xdr_tb_header.name = 'All confirmed XDR-TB'
GROUP BY xdr_tb_header.name;




-- New Registered DR TB Cases
SELECT possible_age_group.name AS 'Age group',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'Female', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'Male' 
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
	AND DATE(encounter_datetime) BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'MDRTuberculosis, Type'
RIGHT OUTER JOIN possible_age_group ON DATE(encounter_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Tuberculosis registration'
GROUP BY possible_age_group.name;




-- Treatment outcome: DR TB Patient Type
SELECT diagnosis_category_list.answer_concept_name AS 'Diagnosis type',
	SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'F',1,0)) AS 'No. of cases regd.-F', 
    SUM(IF(tuberculosis_type.value_concept_full_name IS NOT NULL && person.gender = 'M',1,0)) AS 'No. of cases regd.-M', 
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'F',1,0)) AS 'Cured-F',
	SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment cured' && person.gender = 'M',1,0)) AS 'Cured-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'F',1,0)) AS 'Completed-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment completed' && person.gender = 'M',1,0)) AS 'Completed-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'F',1,0)) AS 'Failure-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment failed' && person.gender = 'M',1,0)) AS 'Failure-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'F',1,0)) AS 'Died-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Death during treatment' && person.gender = 'M',1,0)) AS 'Died-M',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'F',1,0)) AS 'Loss to follow-up-F',
    SUM(IF(treatment_outcome.value_concept_full_name = 'Treatment defaulted' && person.gender = 'M',1,0)) AS 'Loss to follow-up-M',
    SUM(IF(treatment_outcome.value_concept_full_name IS NULL && person.gender = 'F',1,0)) AS 'Not Evaluated-F',
    SUM(IF(treatment_outcome.value_concept_full_name IS NULL && person.gender = 'M',1,0)) AS 'Not Evaluated-M'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS tuberculosis_type ON encounter.encounter_id = tuberculosis_type.encounter_id
	AND tuberculosis_type.concept_full_name = 'MDRTuberculosis, Type'
INNER JOIN coded_obs_view AS diagnosis_category ON diagnosis_category.obs_group_id = tuberculosis_type.obs_group_id
	AND diagnosis_category.concept_full_name = 'MDRTuberculosis, Diagnosis Category'
LEFT OUTER JOIN coded_obs_view AS treatment_outcome ON treatment_outcome.person_id = tuberculosis_type.person_id
	AND treatment_outcome.concept_full_name = 'MDRTuberculosis, Treatment Outcome'
    AND DATE(treatment_outcome.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN 
	(SELECT answer_concept_name FROM concept_answer_view WHERE question_concept_name = 'Tuberculosis, Diagnosis Category' AND answer_concept_name != 'Transfer In') AS diagnosis_category_list
	ON diagnosis_category.value_concept_full_name = diagnosis_category_list.answer_concept_name
GROUP BY diagnosis_category_list.answer_concept_name;
