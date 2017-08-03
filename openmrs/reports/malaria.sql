-- Malaria report

-- Parameters
SET @start_date = '2015-02-25';
SET @end_date = '2015-03-15';

-- Query


-- Treatment - Pregnant woman
SELECT
	SUM(IF(person.person_id IS NOT NULL, 1, 0)) AS Total,
    SUM(IF(pregnancy_status.value_coded = 1 , 1, 0)) AS 'Pregnant women'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS malaria_type ON encounter.encounter_id = malaria_type.encounter_id
	AND malaria_type.concept_full_name = 'Malaria, Malaria Type'
LEFT OUTER JOIN coded_obs_view AS pregnancy_status ON pregnancy_status.person_id = person.person_id
	AND pregnancy_status.concept_full_name = 'Malaria, Pregnant'
	AND pregnancy_status.value_coded = 1
    AND pregnancy_status.obs_datetime BETWEEN @start_date AND @end_date;


-- Treatment 

(SELECT
	malaria_types_list.name_value AS 'Type of Malaria',
    SUM(IF(entries.gender = 'F' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) < 5, 1, 0)) AS 'Female, <5 years',
    SUM(IF(entries.gender = 'M' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) < 5, 1, 0)) AS 'Male, <5 years',
    SUM(IF(entries.gender = 'F' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) >= 5, 1, 0)) AS 'Female, >= 5 years',
    SUM(IF(entries.gender = 'M' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) >= 5, 1, 0)) AS 'Male, >=5 years'
FROM
(SELECT
 IF(malaria_type.value_concept_full_name = 'Plasmodium Vivax' && malaria_classification.value_concept_full_name = 'Indigenous','PV - Indigenous',
	IF(malaria_type.value_concept_full_name = 'Plasmodium Vivax' && malaria_classification.value_concept_full_name = 'Imported', 'PV - Imported',
		IF(malaria_type.value_concept_full_name = 'Plasmodium Falciparum' && malaria_classification.value_concept_full_name = 'Indigenous','PF- Indigenous',
		   IF(malaria_type.value_concept_full_name = 'Plasmodium Falciparum' && malaria_classification.value_concept_full_name = 'Imported', 'PF - Imported',
			IF(malaria_type.value_concept_full_name = 'Plasmodium Mixed' && malaria_classification.value_concept_full_name = 'Indigenous','PM- Indigenous',
				IF(malaria_type.value_concept_full_name = 'Plasmodium Mixed' && malaria_classification.value_concept_full_name = 'Imported', 'PM - Imported',null)))))) AS malaria,
 person.person_id, person.gender, person.birthdate, visit.date_started
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS malaria_type ON encounter.encounter_id = malaria_type.encounter_id
	AND malaria_type.concept_full_name = 'Malaria, Malaria Type'
LEFT OUTER JOIN coded_obs_view AS malaria_classification ON malaria_classification.person_id = person.person_id
	AND malaria_classification.concept_full_name = 'Malaria, Classification'
    AND malaria_classification.obs_datetime BETWEEN @start_date AND @end_date
) AS entries
RIGHT OUTER JOIN (SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Types of Malaria' ) AS malaria_types_list ON entries.malaria = malaria_types_list.name_key
GROUP BY malaria_types_list.name_value
ORDER BY malaria_types_list.sort_order)

UNION
-- Number of malaria cases.

(SELECT
	malaria_types_list.name_value AS 'Type of Malaria',
    SUM(IF(person.gender = 'F' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) < 5, 1, 0)) AS 'Female, <5 years',
    SUM(IF(person.gender = 'M' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) < 5, 1, 0)) AS 'Male, <5 years',
    SUM(IF(person.gender = 'F' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) >= 5, 1, 0)) AS 'Female, >= 5 years',
    SUM(IF(person.gender = 'M' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) >= 5, 1, 0)) AS 'Male, >=5 years'
	-- person.person_id, person.gender, person.birthdate, visit.date_started, malaria_type.value_concept_full_name, malaria_type.value_concept_full_name
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS malaria_type ON encounter.encounter_id = malaria_type.encounter_id
	AND malaria_type.concept_full_name = 'Malaria, Finding'
RIGHT OUTER JOIN (SELECT name_key, name_value, sort_order FROM row_header_name_map WHERE report_group_name = 'Malaria-No of malaria cases' ) AS malaria_types_list ON malaria_type.value_concept_full_name = malaria_types_list.name_key
GROUP BY malaria_types_list.name_value
ORDER BY malaria_types_list.sort_order)

UNION

(SELECT
	malaria_types_list.answer_concept_name AS 'Type of Malaria',
    SUM(IF(person.gender = 'F' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) < 5, 1, 0)) AS 'Female, <5 years',
    SUM(IF(person.gender = 'M' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) < 5, 1, 0)) AS 'Male, <5 years',
    SUM(IF(person.gender = 'F' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) >= 5, 1, 0)) AS 'Female, >= 5 years',
    SUM(IF(person.gender = 'M' && TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) >= 5, 1, 0)) AS 'Male, >=5 years'

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	 AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS malaria_type ON encounter.encounter_id = malaria_type.encounter_id
	AND malaria_type.concept_full_name = 'Malaria, Finding'
 LEFT outer JOIN obs_view AS malaria_treatment ON malaria_treatment.obs_group_id = malaria_type.obs_group_id
 	AND malaria_treatment.concept_full_name = 'Malaria, Treatment Start Date'
    AND malaria_treatment.value_datetime IS NOT NULL 
RIGHT OUTER JOIN (select answer_concept_name from concept_answer_view where question_concept_name = 'Malaria, Finding' ) AS malaria_types_list ON malaria_type.value_concept_full_name = malaria_types_list.answer_concept_name
GROUP BY malaria_types_list.answer_concept_name)

UNION
    
(SELECT 		
	IF(malaria_finding.value_concept_full_name = 'Suspected / Probable' || malaria_finding.value_concept_full_name = 'Probable Severe', 'Died - Probable', 
		IF((malaria_finding.value_concept_full_name = 'Confirmed Uncomplicated' || malaria_finding.value_concept_full_name = 'Confirmed Severe') && malaria_type.value_concept_full_name = 'Plasmodium Vivax', 'Died - Confirmed PV',
			IF((malaria_finding.value_concept_full_name = 'Confirmed Uncomplicated' || malaria_finding.value_concept_full_name = 'Confirmed Severe') && malaria_type.value_concept_full_name = 'Plasmodium Falciparum', 'Died - Confirmed PF','Died - Probable'))) AS death_reason,
	SUM(IF(entries.gender = 'F' && TIMESTAMPDIFF(YEAR, entries.birthdate, latest_finding) < 5, 1, 0)) AS 'Female, <5 years',
    SUM(IF(entries.gender = 'M' && TIMESTAMPDIFF(YEAR, entries.birthdate, latest_finding) < 5, 1, 0)) AS 'Male, <5 years',
    SUM(IF(entries.gender = 'F' && TIMESTAMPDIFF(YEAR, entries.birthdate, latest_finding) >= 5, 1, 0)) AS 'Female, >= 5 years',
    SUM(IF(entries.gender = 'M' && TIMESTAMPDIFF(YEAR, entries.birthdate, latest_finding) >= 5, 1, 0)) AS 'Male, >=5 years'
FROM    
(SELECT person.person_id,
		person.gender,
        person.birthdate,
        MAX(coded_obs_view.obs_datetime) AS latest_finding,
        MAX(malaria_type.obs_datetime) AS latest_type
FROM person 
INNER JOIN obs_view AS malaria_death ON malaria_death.person_id = person.person_id
	AND malaria_death.concept_full_name = 'Malaria, Death Date'
    AND malaria_death.value_datetime BETWEEN @start_date AND @end_date
 LEFT OUTER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Malaria, Finding'
    AND DATE(coded_obs_view.obs_datetime) BETWEEN DATE_SUB(@start_date, INTERVAL 11 MONTH) AND @end_date 
 LEFT OUTER JOIN coded_obs_view AS malaria_type ON malaria_type.person_id = person.person_id
 	AND malaria_type.concept_full_name = 'Malaria, Malaria type'
    AND DATE(malaria_type.obs_datetime) BETWEEN DATE_SUB(@start_date, INTERVAL 11 MONTH) AND @end_date
GROUP BY person.person_id) AS entries
LEFT OUTER JOIN coded_obs_view AS malaria_finding
	ON malaria_finding.obs_datetime = entries.latest_finding
    AND malaria_finding.concept_full_name = 'Malaria, Finding'
    AND malaria_finding.person_id = entries.person_id
LEFT OUTER JOIN coded_obs_view AS malaria_type
 	ON malaria_type.obs_datetime = entries.latest_type
    AND malaria_type.concept_full_name = 'Malaria, Malaria type'
    AND malaria_type.person_id = entries.person_id
GROUP BY death_reason);



