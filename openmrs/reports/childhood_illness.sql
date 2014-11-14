-- Parameters
SET @start_date = '2014-11-01';
SET @end_date = '2014-11-30';

-- Query

-- Children aged less than 2 months 
-- Total cases, PSBI, LBI, Jaundice, Low weight/Feeding Prob, Refer, Follow-up

SELECT possible_age_group.name AS 'Less than 2 months Children',
	   COUNT( DISTINCT visit.visit_id) AS 'Total cases',
	   SUM(IF(value_concept.concept_full_name IS NULL, 0, IF(value_concept.concept_full_name = 'Umbilicus infection to skin' || 'Greater than 99.5F' || 'Severe and larger than 10mm',1,0))) AS 'PSBI',       
       SUM(IF(value_concept.concept_full_name IS NULL, 0, IF(value_concept.concept_full_name = 'Umbilicus red' || 'Blood Umbilicus with pus' || 'Less than 99.5F' || 'Less than 10mm',1,0))) AS 'LBI',
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'PSBI/LBI/NBI, Jaundice',1,0))) AS 'Jaundice',
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Difficult feeding',IF(value_concept.concept_full_name = 1,1,IF(reference_concept.concept_full_name = 'Weight condition',IF(value_concept.concept_full_name = 'Low weight'||'Very low weight',1,0),0)),0))) AS 'Low weight/ Feeding Problem',
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness, Referred to',1,0))) AS 'Refer',
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness, Follow up result',1,0))) AS 'Follow - up'
       
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
LEFT OUTER JOIN obs ON encounter.encounter_id = obs.encounter_id
INNER JOIN concept_view AS reference_concept ON obs.concept_id = reference_concept.concept_id
LEFT OUTER JOIN concept_view AS value_concept ON obs.value_coded = value_concept.concept_id
	AND value_concept.concept_full_name IN ('Umbilicus Infection', 'PSBI/LBI/NBI, Temperature', 'PSBI/LBI/NBI, Skin Pustules', 'PSBI/LBI/NBI, Jaundice', 'Weight condition', 'Difficult feeding', 'Childhood Illness, Referred to', 'Childhood Illness, Follow up result')    
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order;


-- Treatment -Cotrim, Gentamycin

SELECT possible_age_group.name AS 'Less than 2 months Children',
	SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Cotrimaxazole',1,0))) AS 'Cotrim Paediatrics',
    SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Gentamycin',1,0))) AS 'Gentamycin'
FROM orders
INNER JOIN person ON orders.patient_id = person.person_id
	AND orders.date_activated BETWEEN @start_date AND @end_date
    AND orders.order_action IN ('NEW', 'REVISED')
INNER JOIN drug_order ON orders.order_id = drug_order.order_id
INNER JOIN concept_view ON drug_order.concept_id = comcept_view.concept_id
	AND concept_view.concept_full_name IN ('Cotrimaxazole', 'Gentamycin')
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order;


-- Children aged between 2months and 5 years
-- Total, Follow-up
SELECT possible_age_group.name AS 'Children aged between 2 months and 5 years',
	   COUNT( DISTINCT visit.visit_id) AS 'Total cases',
	   SUM(IF(obs_view.obs_id IS NULL, 0, 1)) AS 'Follow -up'       
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
LEFT OUTER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name = 'Childhood Illness, Follow up result'  
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order;

-- Refer- ARI, Diarrhoea, Others
 SELECT possible_age_group.name AS 'Children aged between 2 months and 5 years',
	   SUM(IF(reason_obs.concept_full_name = 'Childhood Illness, Acute Respiratory Infection present', IF(reason_obs.value_concept_full_name = 1,1,0),0)) AS 'Refer - ARI',       
       SUM(IF(reason_obs.concept_full_name = 'Childhood Illness, Diarrhoea present', IF(reason_obs.value_concept_full_name = 1,1,0),0)) AS 'Refer - Diarrhoea',
       SUM(IF(reason_obs.concept_full_name IS NULL,IF(refer_obs.concept_full_name IS NULL,0,1),IF(reason_obs.concept_full_name = 'Childhood Illness, Acute Respiratory Infection present',IF(reason_obs.value_concept_full_name = 2,1,0),IF(reason_obs.concept_full_name = reason_obs.concept_full_name = 'Childhood Illness, Diarrhoea present',IF(reason_obs.value_concept_full_name = 2,1,0),0)))) AS 'Refer - Others'
FROM
(SELECT *
FROM obs_view
WHERE obs_view.concept_full_name = 'Childhood Illness, Referred to'
	AND DATE(obs_view.obs_datetime) BETWEEN @start_date AND @end_date) AS refer_obs
LEFT OUTER JOIN coded_obs_view AS reason_obs ON refer_obs.encounter_id = reason_obs.encounter_id
	AND reason_obs.concept_full_name IN ('Childhood Illness, Acute Respiratory Infection present', 'Childhood Illness, Diarrhoea present')
INNER JOIN person ON refer_obs.person_id = person.person_id
RIGHT OUTER JOIN possible_age_group ON DATE(refer_obs.obs_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order;

   
-- Classification



-- Treatment

SELECT possible_age_group.name AS 'Children aged between 2 months and 5 years',
	SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Cotrimaxazole',1,0))) AS 'Cotrim Paediatrics',
    SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Gentamycin',1,0))) AS 'Gentamycin'
FROM orders
INNER JOIN person ON orders.patient_id = person.person_id
	AND orders.date_activated BETWEEN @start_date AND @end_date
    AND orders.order_action IN ('NEW', 'REVISED')
INNER JOIN drug_order ON orders.order_id = drug_order.order_id
INNER JOIN concept_view ON drug_order.concept_id = comcept_view.concept_id
	AND concept_view.concept_full_name IN ('Cotrimaxazole', 'Gentamycin', 'ORS', 'Zinc', 'Anit-helmintes', 'Vitamin-A')
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order;