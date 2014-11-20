-- Parameters
SET @start_date = '2014-11-01';
SET @end_date = '2014-11-30';

-- Query
-- Children aged less than 2 months 

SELECT total.name AS 'Less than 2 months Children',
	   total.total_cases AS 'Total Cases',
       diagnoses.PSBI AS 'PSBI',
       diagnoses.LBI AS 'LBI',
       diagnoses.Jaundice AS 'Jaundice',
       diagnoses.LWDF AS 'Low weight/ Feeding Prob.',
       treatment.cotrim AS 'Treatment - Cotrim Paediatrics',
       treatment.gentamycin AS 'Treatment - Gentamycin',
       total.refer AS 'Refer',
       total.follow_up AS 'Follow-up'
FROM
-- Total cases, Refer, Follow -up
(SELECT possible_age_group.name,
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness( Children aged below 2 months)',1,0))) AS total_cases,
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness, Referred to',1,0))) AS refer,
       SUM(IF(reference_concept.concept_full_name IS NULL, 0, IF(reference_concept.concept_full_name = 'Childhood Illness, Follow up result',1,0))) AS follow_up
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
LEFT OUTER JOIN obs ON encounter.encounter_id = obs.encounter_id
INNER JOIN concept_view AS reference_concept ON obs.concept_id = reference_concept.concept_id
	AND reference_concept.concept_full_name IN ('Childhood Illness( Children aged below 2 months)','Childhood Illness, Referred to', 'Childhood Illness, Follow up result')    
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order) AS total
INNER JOIN

-- PSBI, LBI, Jaundice, Low weight/Feeding Prob
(SELECT possible_age_group.name, 
		SUM(IF(PSBI_count>0,1,0)) AS PSBI,
	    SUM(IF(LBI_count>0,1,0)) AS LBI,
	    SUM(IF(Jaundice_count>0,1,0)) AS Jaundice,
        SUM(IF(LWDF_count>0,1,0)) AS LWDF
FROM 
(SELECT person.person_id, person.birthdate, visit.date_started, visit.visit_id,
   SUM(IF((reference_concept.concept_full_name = 'Temperature' && obs.value_numeric > 99.5) || (value_concept.concept_full_name = 'Severe and larger than 10mm' || value_concept.concept_full_name = 'Umbilicus infection to skin' ),1,0)) AS PSBI_count,
   SUM(IF((reference_concept.concept_full_name = 'Temperature' && obs.value_numeric < 95.9) || (value_concept.concept_full_name = 'Umbilicus red' || value_concept.concept_full_name = 'Blood Umbilicus with pus' || value_concept.concept_full_name = 'Less than 10mm'),1,0)) AS LBI_count,
   SUM(IF(value_concept.concept_full_name = 'Jaundice present' || value_concept.concept_full_name = 'Jaundice upto hands and feet', 1,0 )) AS Jaundice_count,
   SUM(IF((value_concept.concept_full_name = 'Low weight' || value_concept.concept_full_name = 'Very low weight') || (reference_concept.concept_full_name = 'Difficult feeding' && value_concept.concept_full_name = 'True'), 1,0 )) AS LWDF_count
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
LEFT OUTER JOIN obs ON encounter.encounter_id = obs.encounter_id
INNER JOIN concept_view AS reference_concept ON obs.concept_id = reference_concept.concept_id
	AND reference_concept.concept_full_name IN ('Umbilicus Infection','PSBI/LBI/NBI, Skin Pustules', 'PSBI/LBI/NBI, Jaundice', 'Weight condition', 'Difficult feeding', 'Temperature')    
LEFT OUTER JOIN concept_view AS value_concept ON obs.value_coded = value_concept.concept_id
GROUP BY visit.visit_id) AS table1
RIGHT OUTER JOIN possible_age_group ON table1.date_started BETWEEN (DATE_ADD(DATE_ADD(table1.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(table1.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order) AS diagnoses
ON total.name = diagnoses.name
INNER JOIN

-- Treatment -Cotrim, Gentamycin
(SELECT possible_age_group.name,
	SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Cotrimoxazole',1,0))) AS cotrim,
    SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Gentamicin',1,0))) AS gentamycin
FROM orders
INNER JOIN person ON orders.patient_id = person.person_id
	AND orders.date_activated BETWEEN @start_date AND @end_date
    AND orders.order_action IN ('NEW', 'REVISED')
INNER JOIN drug_order ON orders.order_id = drug_order.order_id
INNER JOIN drug ON drug_order.drug_inventory_id = drug.drug_id
INNER JOIN concept_view ON drug.concept_id = concept_view.concept_id
	AND concept_view.concept_full_name IN ('Cotrimoxazole', 'Gentamicin')
RIGHT OUTER JOIN possible_age_group ON orders.date_activated BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 2months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order) AS treatment
ON diagnoses.name = treatment.name;

-- Children aged between 2 months and 59 months 
-- Total, Follow-up
SELECT total.name AS '2-59 months Children',
	   total.total AS 'Total',
       ari.ari_no_pneumonia AS 'ARI - No pneumonia',
       ari.ari_pneumonia AS 'ARI - Pneumonia',
       ari.ari_severe_pneumonia AS 'ARI - Severe Pneumonia',
       diarrhoea.diarrhoea_no_dehydration AS 'Diarrhoea - No Dehydration',
       diarrhoea.diarrhoea_dehydration AS 'Diarrhoea - Severe Dehydration',
       diarrhoea.diarrhoea_dysentery AS 'Diarrhoea - Dysentery',
       malaria.malaria_falciparum AS 'Malaria - Falciparum',
       malaria.malaria_non_falciparum AS 'Malaria - Non-Falciparum',
       diseases.febrile_disease AS 'Very Severe Febrile disease',
       diseases.measles AS 'Measles',
       diseases.ear_infection AS 'Ear - Infection',
       diseases.other_fever AS 'Other fever',
       diseases.severe_malnutrition AS 'Severe malnutrition',
       diseases.anaemia AS 'Anaemia',
       diseases.others AS 'Other',
	   treatment.cotrim AS 'Treatment - Cotrim Paediatrics',
	   'Treatment - Other antibiotics',
       'Treatment - IV fluid',
       treatment_ors_zinc.count AS 'Treatment - ORS and Zinc',
       treatment.ors AS 'Treatment - ORS Only',
       treatment.anti_helminthes AS 'Treatment - Anti-helminthes',
       treatment.vitamin_a AS 'Treatment - Vitamin A',
       refer.refer_ari AS 'Refer - ARI',
       refer.refer_diarrhoea AS 'Refer - Diarrhoea',
       refer.refer_others AS 'Refer - Others',
       total.follow_up AS 'Follow-up'
FROM 
(SELECT possible_age_group.name,
	   SUM(IF(obs_view.concept_full_name IS NULL, 0, IF(obs_view.concept_full_name = 'Childhood Illness( Children aged 2 months to 5 years)',1,0))) AS total,
       SUM(IF(obs_view.concept_full_name IS NULL, 0, IF(obs_view.concept_full_name = 'Childhood Illness, Follow up result',1,0))) AS follow_up
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN( 'Childhood Illness( Children aged 2 months to 5 years)', 'Childhood Illness, Follow up result')  
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order) AS total
INNER JOIN

-- Refer- ARI, Diarrhoea, Others
(SELECT  name ,
		SUM(IF(referral_reason.ARI>0,1,0)) AS refer_ari,
	    SUM(IF(referral_reason.Diarrhoea>0,1,0)) AS refer_diarrhoea,
	    SUM(IF(referral_reason.Others>0,1,0)) AS refer_others
FROM 
(SELECT 
 	reference_obs.encounter_id, 
	reference_obs.name, 
    SUM(IF(reason_obs.concept_full_name = 'Childhood Illness, Acute Respiratory Infection present', IF(reason_obs.value_coded = 1,1,0),0)) AS ARI,
    SUM(IF(reason_obs.concept_full_name = 'Childhood Illness, Diarrhoea present', IF(reason_obs.value_coded = 1,1,0),0)) AS Diarrhoea,
	SUM(IF(reason_obs.concept_full_name IS NULL, IF(reference_obs.concept_full_name IS NULL,0,1),IF(reason_obs.concept_full_name = 'Childhood Illness, Acute Respiratory Infection present',IF(reason_obs.value_coded = 2,1,0),IF(reason_obs.concept_full_name = 'Childhood Illness, Diarrhoea present',IF(reason_obs.value_coded = 2,1,0),0)))) AS Others
FROM
(SELECT obs_view.concept_full_name, encounter.encounter_id, possible_age_group.name
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name = 'Childhood Illness, Referred to'
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months') AS reference_obs
LEFT OUTER JOIN
obs_view AS reason_obs ON reason_obs.encounter_id = reference_obs.encounter_id
AND reason_obs.concept_full_name IN ('Childhood Illness, Acute Respiratory Infection present', 'Childhood Illness, Diarrhoea present')
GROUP BY reference_obs.encounter_id) AS referral_reason
GROUP BY name) AS refer
ON total.name = refer.name

-- Classification-ARI
INNER JOIN
(SELECT 
	possible_age_group.name,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Acute Respiratory Infection present' && coded_obs_view.concept_full_name IS NULL, 1, 0)) AS ARI_no_pneumonia,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Acute Respiratory Infection present' && coded_obs_view.value_concept_full_name = 'Pneumonia', 1, 0)) AS ARI_pneumonia,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Acute Respiratory Infection present' && coded_obs_view.value_concept_full_name = 'Severe pneumonia', 1, 0)) AS ARI_severe_pneumonia
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN ('Childhood Illness, Acute Respiratory Infection present') AND obs_view.value_coded = 1
LEFT OUTER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Pneumonia','Severe pneumonia')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
LEFT OUTER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months') AS ari
ON refer.name = ari.name
INNER JOIN

-- Classification - Diarrhoea
(SELECT 
	possible_age_group.name,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Diarrhoea present' && coded_obs_view.concept_full_name IS NULL, 1, 0)) AS diarrhoea_no_dehydration,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Diarrhoea present' && coded_obs_view.value_concept_full_name = 'Volume Depletion', 1, 0)) AS diarrhoea_dehydration,
	SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Diarrhoea present' && (coded_obs_view.value_concept_full_name = 'Ameobic Dysentery' || coded_obs_view.value_concept_full_name = 'Bacillary Dysentery'), 1, 0)) AS diarrhoea_dysentery
    
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN ('Childhood Illness, Diarrhoea present') AND obs_view.value_coded = 1
LEFT OUTER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Volume Depletion', 'Ameobic Dysentery', 'Bacillary Dysentery')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
LEFT OUTER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN possible_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months') AS diarrhoea
ON ari.name = diarrhoea.name
INNER JOIN

-- Malaria
(SELECT 
	possible_age_group.name,
    SUM(IF(coded_obs_view.value_concept_full_name = 'Plasmodium Falciparum', 1, 0)) AS malaria_falciparum,
    SUM(IF(coded_obs_view.value_concept_full_name = 'Plasmodium Vivax' || coded_obs_view.value_concept_full_name = 'Clinical Malaria', 1, 0)) AS malaria_non_falciparum
FROM person 
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Clinical Malaria', 'Plasmodium Falciparum', 'Plasmodium Vivax')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN possible_age_group ON DATE(coded_obs_view.obs_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months') AS malaria
ON diarrhoea.name = malaria.name
INNER JOIN
-- Very severe febrile disease, ear infection ,other fever, severe malnutrition
(SELECT 
	possible_age_group.name,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Clinical Malaria' ||
			coded_obs_view.value_concept_full_name = 'Plasmodium Falciparum' ||
            coded_obs_view.value_concept_full_name = 'Typhoid' ||
            coded_obs_view.value_concept_full_name = 'Severe pneumonia' ||
            coded_obs_view.value_concept_full_name = 'Meningitis' ||
            coded_obs_view.value_concept_full_name = 'Lower respiratory tract infection', 1, 0)) AS febrile_disease,
	SUM(IF( coded_obs_view.value_concept_full_name = 'Acute Suppurative Otitis Media' ||
	        coded_obs_view.value_concept_full_name = 'Chronic Suppurative Otitis Media', 1, 0)) AS ear_infection,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Pyrexia of Unknown Origin', 1, 0)) AS other_fever,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Anaemia', 1, 0)) AS anaemia,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Malnutrition', 1, 0)) AS severe_malnutrition,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Measles', 1, 0)) AS measles,
    SUM(IF( coded_obs_view.value_concept_full_name NOT IN ( 'Clinical Malaria', 'Plasmodium Falciparum', 'Typhoid', 'Severe pneumonia', 'Meningitis', 'Lower respiratory tract infection', 'Acute Suppurative Otitis Media', 'Chronic Suppurative Otitis Media', 'Pyrexia of Unknown Origin', 'Anaemia', 'Malnutrition', 'Measles'), 1, 0)) AS others
    FROM person 
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	-- AND coded_obs_view.value_concept_full_name IN ('Clinical Malaria', 'Plasmodium Falciparum', 'Typhoid', 'Severe pneumonia', 'Meningitis', 'Lower respiratory tract infection',
    -- 'Acute Suppurative Otitis Media', 'Chronic Suppurative Otitis Media', 'Pyrexia of Unknown Origin', 'Anaemia', 'Malnutrition', 'Measles')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN possible_age_group ON DATE(coded_obs_view.obs_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months') AS diseases
ON malaria.name = diseases.name
INNER JOIN

-- Treatment
(SELECT possible_age_group.name,
	SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Cotrimoxazole',1,0))) AS cotrim,
    SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Gentamycin',1,0))) AS gentamycin,
	SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'ORS',1,0))) AS ors,
    SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Anti-helminthes',1,0))) AS anti_helminthes,
    SUM(IF(concept_view.concept_full_name IS NULL, 0, IF(concept_view.concept_full_name = 'Vitamin-A',1,0))) AS vitamin_a
FROM orders
INNER JOIN person ON orders.patient_id = person.person_id
	AND orders.date_activated BETWEEN @start_date AND @end_date
    AND orders.order_action IN ('NEW', 'REVISED')
INNER JOIN drug_order ON orders.order_id = drug_order.order_id
INNER JOIN drug ON drug_order.drug_inventory_id = drug.drug_id
INNER JOIN concept_view ON drug.concept_id = concept_view.concept_id
	AND concept_view.concept_full_name IN ('Cotrimoxazole', 'Gentamycin', 'ORS', 'Zinc', 'Anti-helmintes', 'Vitamin-A')
RIGHT OUTER JOIN possible_age_group ON orders.date_activated BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order) AS treatment
ON diseases.name = treatment.name
INNER JOIN
-- ORS and Zinc
(SELECT possible_age_group.name,
 	SUM(IF(first_concept_view.concept_full_name IS NOT NULL && second_concept_view.concept_full_name IS NOT NULL, 1, 0)) AS count
FROM orders AS first_order
INNER JOIN person ON first_order.patient_id = person.person_id
	AND first_order.date_activated BETWEEN @start_date AND @end_date
    AND first_order.order_action IN ('NEW', 'REVISED')
INNER JOIN drug_order AS first_drug_order ON first_order.order_id = first_drug_order.order_id
INNER JOIN drug AS first_drug ON first_drug_order.drug_inventory_id = first_drug.drug_id
INNER JOIN concept_view AS first_concept_view ON first_drug.concept_id = first_concept_view.concept_id
	AND first_concept_view.concept_full_name = 'ORS'
INNER JOIN orders AS second_order ON second_order.patient_id = person.person_id
	AND second_order.order_action IN ('NEW', 'REVISED')
    AND second_order.date_activated BETWEEN @start_date AND @end_date
INNER JOIN drug_order AS second_drug_order ON second_order.order_id = second_drug_order.order_id
INNER JOIN drug AS second_drug ON second_drug_order.drug_inventory_id = second_drug.drug_id
INNER JOIN concept_view AS second_concept_view ON second_drug.concept_id = second_concept_view.concept_id
	AND second_concept_view.concept_full_name = 'Zinc'
RIGHT OUTER JOIN possible_age_group ON first_order.date_activated BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.min_years YEAR), INTERVAL possible_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL possible_age_group.max_years YEAR), INTERVAL possible_age_group.max_days DAY))
WHERE possible_age_group.report_group_name = 'Childhood Illness 59months'
GROUP BY possible_age_group.name
ORDER BY possible_age_group.sort_order) AS treatment_ors_zinc
ON treatment.name = treatment_ors_zinc.name;

