-- Malaria report

-- Parameters
SET @start_date = '2014-11-01';
SET @end_date = '2014-12-30';

-- Query
-- Concepts: 'Types of Malaria: Plasmodium Vivax - Indigenous, Plasmodium Vivax - Imported, Plasmodium Falciparum - Indigenous, Plasmodium Falciparum - Imported '
-- Treatment - Pregnant woman
SELECT
	SUM(IF(person.person_id IS NOT NULL, 1, 0)) AS Total,
    SUM(IF(pregnancy_status.value_coded = 1 , 1, 0)) AS 'Pregnant women'
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS malaria_type ON encounter.encounter_id = malaria_type.encounter_id
	AND malaria_type.concept_full_name = 'Malaria Kalaazar, Malaria Type'
LEFT OUTER JOIN coded_obs_view AS pregnancy_status ON pregnancy_status.person_id = person.person_id
	AND pregnancy_status.concept_full_name = 'Malaria Kalaazar, Pregnant'
	AND pregnancy_status.value_coded = 1
    AND pregnancy_status.obs_datetime BETWEEN @start_date AND @end_date;


-- Treatment 

SELECT
	malaria_types_list.child_concept_name AS 'Type of Malaria',
    SUM(IF(entries.gender = 'F' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) < 5, 1, 0)) AS 'Female, <5 years',
    SUM(IF(entries.gender = 'M' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) < 5, 1, 0)) AS 'Male, <5 years',
    SUM(IF(entries.gender = 'F' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) >= 5, 1, 0)) AS 'Female, >= 5 years',
    SUM(IF(entries.gender = 'M' && TIMESTAMPDIFF(YEAR, entries.birthdate, entries.date_started) >= 5, 1, 0)) AS 'Male, >=5 years'
FROM
(SELECT
 IF(malaria_type.value_concept_full_name = 'Plasmodium Vivax' && malaria_classification.value_concept_full_name = 'Indigenous','Plasmodium Vivax - Indigenous',
	IF(malaria_type.value_concept_full_name = 'Plasmodium Vivax' && malaria_classification.value_concept_full_name = 'Imported', 'Plasmodium Vivax - Imported',
		IF(malaria_type.value_concept_full_name = 'Plasmodium Falciparum' && malaria_classification.value_concept_full_name = 'Indigenous','Plasmodium Falciparum - Indigenous',
		   IF(malaria_type.value_concept_full_name = 'Plasmodium Falciparum' && malaria_classification.value_concept_full_name = 'Imported', 'Plasmodium Falciparum - Imported', null)))) AS malaria,
 person.person_id, person.gender, person.birthdate, visit.date_started
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS malaria_type ON encounter.encounter_id = malaria_type.encounter_id
	AND malaria_type.concept_full_name = 'Malaria Kalaazar, Malaria Type'
LEFT OUTER JOIN coded_obs_view AS malaria_classification ON malaria_classification.person_id = person.person_id
	AND malaria_classification.concept_full_name = 'Malaria Kalaazar, Classification'
    AND malaria_classification.obs_datetime BETWEEN @start_date AND @end_date
) AS entries
RIGHT OUTER JOIN (SELECT child_concept_name FROM concept_children_view WHERE parent_concept_name = 'Types of Malaria' ) AS malaria_types_list ON entries.malaria = malaria_types_list.child_concept_name
GROUP BY malaria_types_list.child_concept_name
