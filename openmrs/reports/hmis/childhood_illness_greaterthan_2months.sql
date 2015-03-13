SELECT total.name AS '2-59 months Children',
	   total.total AS 'Total',
       ari.ari_no_pneumonia AS 'ARI - No pneumonia',
       ari.ari_pneumonia AS 'ARI - Pneumonia',
       ari.ari_severe_pneumonia AS 'ARI - Severe Pneumonia',
       diarrhoea.diarrhoea_no_dehydration AS 'Diarrhoea - No Dehydration',
       diarrhoea.diarrhoea_some_dehydration AS 'Diarrhoea - Some Dehydration',
       diarrhoea.diarrhoea_severe_dehydration AS 'Diarrhoea - Severe Dehydration',
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
       refer.refer_ari AS 'Refer - ARI',
       refer.refer_diarrhoea AS 'Refer - Diarrhoea',
       refer.refer_others AS 'Refer - Others',
       total.follow_up AS 'Follow-up'
FROM 
(SELECT reporting_age_group.name,
	   SUM(IF(obs_view.concept_full_name IS NULL, 0, IF(obs_view.concept_full_name = 'Childhood Illness( Children aged 2 months to 5 years)',1,0))) AS total,
       SUM(IF(obs_view.concept_full_name IS NULL, 0, IF(obs_view.concept_full_name = 'Childhood Illness, Follow up result',1,0))) AS follow_up
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN( 'Childhood Illness( Children aged 2 months to 5 years)', 'Childhood Illness, Follow up result')  
RIGHT OUTER JOIN reporting_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 59months'
GROUP BY reporting_age_group.name
ORDER BY reporting_age_group.sort_order) AS total
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
(SELECT obs_view.concept_full_name, encounter.encounter_id, reporting_age_group.name
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name = 'Childhood Illness, Referred out'
RIGHT OUTER JOIN reporting_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 59months') AS reference_obs
LEFT OUTER JOIN
obs_view AS reason_obs ON reason_obs.encounter_id = reference_obs.encounter_id
AND reason_obs.concept_full_name IN ('Childhood Illness, Acute Respiratory Infection present', 'Childhood Illness, Diarrhoea present')
GROUP BY reference_obs.encounter_id) AS referral_reason
GROUP BY name) AS refer
ON total.name = refer.name

-- Classification-ARI
INNER JOIN
(SELECT 
	reporting_age_group.name,
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
    AND coded_obs_view.obs_datetime BETWEEN #startDate# AND #endDate#
LEFT OUTER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN reporting_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 59months') AS ari
ON refer.name = ari.name
INNER JOIN

-- Classification - Diarrhoea
(SELECT 
	reporting_age_group.name,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Diarrhoea present' && dehydration_type.value_concept_full_name = 'No Dehydration', 1, 0)) AS diarrhoea_no_dehydration,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Diarrhoea present' && dehydration_type.value_concept_full_name = 'Some Dehydration', 1, 0)) AS diarrhoea_some_dehydration,
    SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Diarrhoea present' && dehydration_type.value_concept_full_name = 'Severe Dehydration', 1, 0)) AS diarrhoea_severe_dehydration,
	SUM(IF(obs_view.concept_full_name = 'Childhood Illness, Diarrhoea present' && (coded_obs_view.value_concept_full_name = 'Amoebic Dysentery' || coded_obs_view.value_concept_full_name = 'Bacillary Dysentery'), 1, 0)) AS diarrhoea_dysentery
    
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN #startDate# AND #endDate#
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN ('Childhood Illness, Diarrhoea present') AND obs_view.value_coded = 1
LEFT OUTER JOIN coded_obs_view dehydration_type ON dehydration_type.obs_group_id = obs_view.obs_group_id
	AND dehydration_type.concept_full_name = 'Childhood Illness, Dehydration Status'
LEFT OUTER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Amoebic Dysentery', 'Bacillary Dysentery')
    AND coded_obs_view.obs_datetime BETWEEN #startDate# AND #endDate#
LEFT OUTER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN reporting_age_group ON visit.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 59months') AS diarrhoea
ON ari.name = diarrhoea.name
INNER JOIN

-- Malaria
(SELECT 
 	 reporting_age_group.name,
     SUM(IF(coded_obs_view.value_concept_full_name = 'Plasmodium Falciparum', 1, 0)) AS malaria_falciparum,
     SUM(IF(coded_obs_view.value_concept_full_name = 'Plasmodium Vivax' || coded_obs_view.value_concept_full_name = 'Clinical Malaria', 1, 0)) AS malaria_non_falciparum
FROM person 
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
 	AND coded_obs_view.value_concept_full_name IN ('Clinical Malaria', 'Plasmodium Falciparum', 'Plasmodium Vivax')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
LEFT OUTER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN reporting_age_group ON DATE(coded_obs_view.obs_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
 						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 59months') AS malaria
ON diarrhoea.name = malaria.name
INNER JOIN
-- Very severe febrile disease, ear infection ,other fever, severe malnutrition
(SELECT 
	reporting_age_group.name,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Clinical Malaria' ||
			coded_obs_view.value_concept_full_name = 'Plasmodium Falciparum' ||
            coded_obs_view.value_concept_full_name = 'Typhoid' ||
            coded_obs_view.value_concept_full_name = 'Severe Pneumonia' ||
            coded_obs_view.value_concept_full_name = 'Meningitis' ||
            coded_obs_view.value_concept_full_name = 'Lower Respiratory Tract Infection', 1, 0)) AS febrile_disease,
	SUM(IF( coded_obs_view.value_concept_full_name = 'Acute Suppurative Otitis Media' ||
	        coded_obs_view.value_concept_full_name = 'Chronic Suppurative Otitis Media', 1, 0)) AS ear_infection,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Pyrexia Of Unknown Origin', 1, 0)) AS other_fever,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Anaemia / Polyneuropathy', 1, 0)) AS anaemia,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Malnutrition', 1, 0)) AS severe_malnutrition,
    SUM(IF( coded_obs_view.value_concept_full_name = 'Measles', 1, 0)) AS measles,
    SUM(IF( coded_obs_view.value_concept_full_name NOT IN ( 'Clinical Malaria', 'Plasmodium Falciparum', 'Typhoid', 'Severe Pneumonia', 'Meningitis', 'Lower Respiratory Tract Infection', 'Acute Suppurative Otitis Media', 'Chronic Suppurative Otitis Media', 'Pyrexia Of Unknown Origin', 'Anaemia', 'Malnutrition', 'Measles'), 1, 0)) AS others
    FROM person 
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN reporting_age_group ON DATE(coded_obs_view.obs_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'Childhood Illness 59months') AS diseases
ON malaria.name = diseases.name;
