
SELECT total.name AS 'Less than 2 months Children',
	   total.total_cases AS 'Total Cases',
       diagnoses.PSBI AS 'PSBI',
       diagnoses.LBI AS 'LBI',
       diagnoses.Jaundice AS 'Jaundice',
       hyp_count.hypothermia AS 'Hypothermia',
       diagnoses.LWDF AS 'Low weight/ Feeding Prob.',
       total.refer AS 'Refer',
       total.follow_up AS 'Follow-up'
FROM
-- Total cases, Refer, Follow -up
(SELECT reporting_age_group.name,
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness( Children aged below 2 months)',1,0))) AS total_cases,
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness, Referred out',1,0))) AS refer,
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness, Follow up result',1,0))) AS follow_up
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
LEFT OUTER JOIN obs ON obs.voided = 0 AND encounter.encounter_id = obs.encounter_id
INNER JOIN concept_view AS reference_concept ON obs.concept_id = reference_concept.concept_id
	AND reference_concept.concept_full_name IN ('Childhood Illness( Children aged below 2 months)','Childhood Illness, Referred out', 'Childhood Illness, Follow up result')    
RIGHT OUTER JOIN reporting_age_group ON DATE(visit.date_stopped) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY))
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY reporting_age_group.name
ORDER BY reporting_age_group.sort_order) AS total
INNER JOIN

-- PSBI, LBI, Jaundice, Low weight/Feeding Prob
(SELECT reporting_age_group.name, 
		SUM(IF(PSBI_count>0,1,0)) AS PSBI,
	    SUM(IF(LBI_count>0,1,0)) AS LBI,
	    SUM(IF(Jaundice_count>0,1,0)) AS Jaundice,
        SUM(IF(LWDF_count>0,1,0)) AS LWDF
FROM 
(SELECT person.person_id, person.birthdate, visit.date_stopped, visit.visit_id,
   SUM(IF((reference_concept.concept_full_name = 'Temperature' && obs.value_numeric > 99.5) || (value_concept.concept_full_name = 'Severe and larger than 10mm' || value_concept.concept_full_name = 'Umbilicus infection to skin' ),1,0)) AS PSBI_count,
   SUM(IF((reference_concept.concept_full_name = 'Temperature' && obs.value_numeric < 95.9) || (value_concept.concept_full_name = 'Umbilicus red' || value_concept.concept_full_name = 'Blood Umbilicus with pus' || value_concept.concept_full_name = 'Less than 10mm'),1,0)) AS LBI_count,
   SUM(IF(value_concept.concept_full_name = 'Jaundice present' || value_concept.concept_full_name = 'Jaundice upto hands and feet', 1,0 )) AS Jaundice_count,
   SUM(IF((value_concept.concept_full_name = 'Low weight' || value_concept.concept_full_name = 'Very low weight') || (reference_concept.concept_full_name = 'Difficult feeding' && value_concept.concept_full_name = 'True'), 1,0 )) AS LWDF_count
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
LEFT OUTER JOIN obs ON obs.voided = 0 AND encounter.encounter_id = obs.encounter_id
INNER JOIN concept_view AS reference_concept ON obs.concept_id = reference_concept.concept_id
	AND reference_concept.concept_full_name IN ('Umbilicus Infection','PSBI/LBI/NBI, Skin Pustules', 'PSBI/LBI/NBI, Jaundice', 'Weight condition', 'Difficult feeding', 'Temperature')    
LEFT OUTER JOIN concept_view AS value_concept ON obs.value_coded = value_concept.concept_id
GROUP BY visit.visit_id) AS table1
RIGHT OUTER JOIN reporting_age_group ON DATE(table1.date_stopped) BETWEEN (DATE_ADD(DATE_ADD(table1.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY))
						AND (DATE_ADD(DATE_ADD(table1.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY reporting_age_group.name
ORDER BY reporting_age_group.sort_order) AS diagnoses
ON total.name = diagnoses.name

INNER JOIN 
(SELECT reporting_age_group.name, 
COUNT(distinct person.person_id) AS hypothermia
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN coded_obs_view AS diagnosis_obs ON diagnosis_obs.voided = 0 AND diagnosis_obs.person_id = person.person_id
	AND diagnosis_obs.concept_full_name = 'Coded Diagnosis'
	AND diagnosis_obs.value_concept_full_name IN ('Hypothermia')
    AND DATE(diagnosis_obs.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN coded_obs_view AS certainty_obs ON diagnosis_obs.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN reporting_age_group ON DATE(visit.date_stopped) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY))
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY reporting_age_group.name
ORDER BY reporting_age_group.sort_order) AS hyp_count
ON diagnoses.name = hyp_count.name;