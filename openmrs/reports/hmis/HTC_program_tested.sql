
SELECT entries.name AS 'HTC Programme - Tested',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Sex Worker' && entries.gender = 'M',1,0)) AS 'Sex Workers - Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Sex Worker' && entries.gender = 'F',1,0)) AS 'Sex Workers - Female',		
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Sex Worker' && entries.gender = 'O',1,0)) AS 'Sex Workers - TG',		
        SUM(IF(entries.tested = 1 && entries.risk_group = 'People Who Inject Drugs' && entries.gender = 'M',1,0)) AS 'People Who Inject Drugs - Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'People Who Inject Drugs' && entries.gender = 'F',1,0)) AS 'People Who Inject Drugs - Female',		
        SUM(IF(entries.tested = 1 && entries.risk_group = 'People Who Inject Drugs' && entries.gender = 'O',1,0)) AS 'People Who Inject Drugs - TG',		
        SUM(IF(entries.tested = 1 && entries.risk_group = 'MSM and Transgenders' && entries.gender = 'M',1,0)) AS 'MSM and Transgenders - Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'MSM and Transgenders' && entries.gender = 'F',1,0)) AS 'MSM and Transgenders - Female',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'MSM and Transgenders' && entries.gender = 'O',1,0)) AS 'MSM and Transgenders - TG',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Blood or Organ Recipient' && entries.gender = 'M',1,0)) AS 'Blood or Organ Recipient - Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Blood or Organ Recipient' && entries.gender = 'F',1,0)) AS 'Blood or Organ Recipient - Female',		
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Blood or Organ Recipient' && entries.gender = 'O',1,0)) AS 'Blood or Organ Recipient - TG',		
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Client of Sex Worker' && entries.gender = 'M',1,0)) AS 'Client of Sex Worker - Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Client of Sex Worker' && entries.gender = 'F',1,0)) AS 'Client of Sex Worker - Female',
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Client of Sex Worker' && entries.gender = 'O',1,0)) AS 'Client of Sex Worker - TG',
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Migrant' && entries.gender = 'M',1,0)) AS 'Migrant- Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Migrant' && entries.gender = 'F',1,0)) AS 'Migrant- Female',
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Migrant' && entries.gender = 'O',1,0)) AS 'Migrant- TG',
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Spouse/Partner of Migrant' && entries.gender = 'M',1,0)) AS 'Spouse/Partner of Migrant- Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Spouse/Partner of Migrant' && entries.gender = 'F',1,0)) AS 'Spouse/Partner of Migrant- Female',
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Spouse/Partner of Migrant' && entries.gender = 'O',1,0)) AS 'Spouse/Partner of Migrant- TG',
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Others' && entries.gender = 'M',1,0)) AS 'Others - Male',
		SUM(IF(entries.tested = 1 && entries.risk_group = 'Others' && entries.gender = 'F',1,0)) AS 'Others - Female',		        
        SUM(IF(entries.tested = 1 && entries.risk_group = 'Others' && entries.gender = 'O',1,0)) AS 'Others - TG'	
FROM
(SELECT 	
	 patients.person_id,
	 patients.gender,
     patients.birthdate,
     patients.risk_group,
	 IF(tested_now.order_id IS NOT NULL || tested_before.tested = 'True', 1, 0) AS tested,
     reporting_age_group.name,
     reporting_age_group.sort_order
FROM
(SELECT 	
	 person.person_id,
     person.gender,
     person.birthdate,
     risk_group_values.concept_full_name AS risk_group,
     visit.date_stopped
FROM visit 
JOIN encounter ON visit.visit_id = encounter.visit_id
	AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN obs AS risk_group ON risk_group.encounter_id = encounter.encounter_id
	AND risk_group.voided = 0
INNER JOIN concept_view ON risk_group.concept_id = concept_view.concept_id
	AND concept_view.concept_full_name = 'HTC, Risk Group'
INNER JOIN concept_view AS risk_group_values ON risk_group.value_coded = risk_group_values.concept_id
INNER JOIN person ON risk_group.person_id = person.person_id) AS patients
LEFT OUTER JOIN 
(SELECT 	
	 person.person_id,
     value_tested.concept_full_name AS tested
FROM visit 
JOIN encounter ON visit.visit_id = encounter.visit_id
	AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN obs AS previously_tested ON previously_tested.encounter_id = encounter.encounter_id
INNER JOIN concept_view AS previously_tested_concept ON previously_tested.concept_id = previously_tested_concept.concept_id
  	AND previously_tested_concept.concept_full_name = 'HTC, Tested before'
    AND previously_tested.voided = 0
INNER JOIN concept_view AS value_tested ON value_tested.concept_id = previously_tested.value_coded
INNER JOIN person ON previously_tested.person_id = person.person_id) AS tested_before
ON patients.person_id = tested_before.person_id
LEFT OUTER JOIN
(SELECT 	
	 person.person_id,
	 test_order.order_id
FROM visit 
JOIN encounter ON visit.visit_id = encounter.visit_id
	AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN orders AS test_order ON test_order.encounter_id = encounter.encounter_id
 	AND test_order.order_type_id = 3
INNER JOIN concept_view test_concept ON test_order.concept_id = test_concept.concept_id
   	AND test_concept.concept_full_name IN ('HIV (Blood)', 'HIV (Serum)')
INNER JOIN person ON test_order.patient_id = person.person_id) AS tested_now
ON tested_now.person_id = patients.person_id
RIGHT OUTER JOIN reporting_age_group ON patients.date_stopped BETWEEN (DATE_ADD(DATE_ADD(patients.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(patients.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'HTC Programme'
) AS entries
GROUP BY entries.name
ORDER BY entries.sort_order;
