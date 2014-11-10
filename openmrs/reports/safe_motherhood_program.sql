-- Parameters
SET @start_date = '2014-11-01';
SET @end_date = '2014-11-30';

-- Query

-- Delivery Service

SELECT delivery.delivery_service_worker AS 'Delivery Service', COUNT(*) as Facility
FROM  
(SELECT obs_delivery_service.value_concept_full_name as delivery_service_worker
FROM coded_obs_view as obs_delivery_service
WHERE obs_delivery_service.concept_full_name = 'Delivery service done by'
	  AND DATE(obs_delivery_service.obs_datetime) BETWEEN @start_date AND @end_date)
AS delivery
GROUP BY delivery.delivery_service_worker;

-- Type of Delivery

SELECT delivery_presentation.delivery_method AS 'Type of Delivery',
	   SUM(IF(delivery_presentation.presentation = 'Cephalic Presentation',1,0)) as Cephalic,
	   SUM(IF(delivery_presentation.presentation = 'Shoulder Presentation',1,0)) as Shoulder,
	   SUM(IF(delivery_presentation.presentation = 'Breech Presentation',1,0)) as Breech
FROM
(SELECT obs_presentation.value_concept_full_name as presentation,
		delivery_type_list.answer_concept_name as delivery_method
FROM coded_obs_view as obs_delivery_method
INNER JOIN obs_view as obs_delivery_time ON obs_delivery_time.obs_group_id = obs_delivery_method.obs_group_id
	AND obs_delivery_time.concept_full_name = 'Delivery date and time'
	AND DATE(obs_delivery_time.value_datetime) BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view as obs_presentation ON obs_delivery_method.obs_group_id = obs_presentation.obs_group_id
	AND obs_presentation.concept_full_name = 'Fetal Presentation'
   	AND obs_delivery_method.concept_full_name = 'Method of Delivery'
RIGHT OUTER JOIN (SELECT answer_concept_name FROM concept_answer_view WHERE question_concept_name = 'Method of Delivery') AS delivery_type_list ON delivery_type_list.answer_concept_name = obs_delivery_method.value_concept_full_name
    ) AS delivery_presentation
GROUP BY delivery_presentation.delivery_method; 


-- Gestation and Delivery Outcome
(SELECT 'Number of Mothers' AS name,
 SUM(IF(delivery_outcome_total.delivery_outcome_type = 'Single live birth'||'Single stillbirth',1,0)) AS 'Single',
 SUM(IF(delivery_outcome_total.delivery_outcome_type = 'Twins both liveborn' || 'Twins one liveborn and one stillborn' || 'Twins both stillborn',1,0)) AS 'Twin',
 SUM(IF(delivery_outcome_total.delivery_outcome_type = 'Other multiple births all liveborn' || 'Other multiple births some liveborn' || 'Other multiple births all stillborn',1,0)) AS '>/Triplet'
FROM
(SELECT obs_delivery_outcome.value_concept_full_name as delivery_outcome_type
FROM coded_obs_view as obs_delivery_outcome
INNER JOIN obs_view ON obs_delivery_outcome.obs_group_id = obs_view.obs_group_id 
	AND	obs_delivery_outcome.concept_full_name = 'Outcome of Delivery'
    AND obs_view.concept_full_name = 'Delivery date and time'
	AND DATE(obs_view.value_datetime) BETWEEN @start_date AND @end_date)
AS delivery_outcome_total)

UNION

(SELECT 'Number of live births' AS name,
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Single live birth',1,0)) AS 'Single',
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Twins both liveborn' || 'Twins one liveborn and one stillborn',1,0)) AS 'Twin',
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Other multiple births all liveborn' || 'Other multiple births some liveborn',1,0)) AS '>/Triplet'
FROM
(SELECT obs_delivery_outcome.value_concept_full_name AS delivery_outcome_type
FROM coded_obs_view as obs_delivery_outcome
INNER JOIN obs_view ON obs_delivery_outcome.obs_group_id = obs_view.obs_group_id
	AND obs_delivery_outcome.concept_full_name = 'Outcome of Delivery'
    AND obs_view.concept_full_name = 'Delivery date and time'
	AND DATE(obs_view.value_datetime) BETWEEN @start_date AND @end_date
    AND obs_delivery_outcome.value_concept_full_name IN ('Single live birth','Twins both liveborn','Twins one liveborn and one stillborn', 'Other multiple births all liveborn','Other multiple births some liveborn'))
AS delivery_outcome_liveborn)

UNION
(SELECT delivery_outcome_stillborn.stillbirth_type AS name,
	SUM(IF(delivery_outcome_stillborn.delivery_outcome_type = 'Single stillbirth',1,0)) AS 'Single',
	SUM(IF(delivery_outcome_stillborn.delivery_outcome_type = 'Twins one liveborn and one stillborn' || 'Twins both stillborn',1,0)) AS 'Twin',
	SUM(IF(delivery_outcome_stillborn.delivery_outcome_type = 'Other multiple births some liveborn' || 'Other multiple births all stillborn',1,0)) AS '>/Triplet'
FROM
(
SELECT stillbirth_types.answer_concept_name AS stillbirth_type, del_outcomes_with_sb_types.delivery_outcome_type
FROM
(SELECT obs_stillbirth_type.value_concept_full_name as stillbirth_type,
	   obs_delivery_outcome.value_concept_full_name as delivery_outcome_type
FROM
coded_obs_view as obs_stillbirth_type 
INNER JOIN coded_obs_view as obs_delivery_outcome ON obs_delivery_outcome.obs_group_id = obs_stillbirth_type.obs_group_id
	AND obs_stillbirth_type.concept_full_name = 'Stillbirth type'
	AND obs_delivery_outcome.concept_full_name = 'Outcome of Delivery'
    AND obs_delivery_outcome.value_concept_full_name IN ('Single stillbirth', 'Twins one liveborn and one stillborn', 'Twins both stillborn','Other multiple births some liveborn','Other multiple births all stillborn')
INNER JOIN obs_view ON obs_stillbirth_type.obs_group_id = obs_view.obs_group_id	
    AND obs_view.concept_full_name = 'Delivery date and time'
    AND DATE(obs_view.obs_datetime) BETWEEN @start_date AND @end_date)
AS del_outcomes_with_sb_types    
RIGHT OUTER JOIN
(SELECT answer_concept_name FROM concept_answer_view WHERE question_concept_name = 'Stillbirth type' AND answer_concept_name != 'Not Applicable')
AS stillbirth_types ON del_outcomes_with_sb_types.stillbirth_type = stillbirth_types.answer_concept_name

)
AS delivery_outcome_stillborn
GROUP BY delivery_outcome_stillborn.stillbirth_type
);

-- Birth Weight
SELECT birth_weight.name as 'Birth Weight',
	count(*) AS 'Number',
    IF(birth_weight.asphyxia IS NULL, 0, 1) AS 'Asphyxia',
    IF(birth_weight.defect IS NULL, 0, 1) AS 'Defect'
FROM 
(SELECT obs_weight.value_numeric as weight, obs_defect.value_coded as defect, obs_asphyxia.value_coded as asphyxia, possible_weight_group.name, possible_weight_group.sort_order as sort_order
FROM obs_view as obs_delivery_time
INNER JOIN obs_view AS obs_weight ON obs_weight.encounter_id = obs_delivery_time.encounter_id
	AND obs_delivery_time.concept_full_name = 'Delivery date and time'
    AND DATE(obs_delivery_time.value_datetime) BETWEEN @start_date AND @end_date
    AND obs_weight.concept_full_name = 'Liveborn, weight'
LEFT OUTER JOIN obs_view AS obs_defect ON obs_weight.obs_group_id = obs_defect.obs_group_id
		AND obs_defect.concept_full_name = 'Liveborn, defects present'
        AND obs_defect.value_coded = 1
LEFT OUTER JOIN obs_view AS obs_asphyxia ON obs_weight.obs_group_id = obs_asphyxia.obs_group_id
	AND obs_asphyxia.concept_full_name = 'Liveborn, asphyxia'
    AND obs_asphyxia.value_coded = 1
RIGHT OUTER JOIN possible_weight_group ON
	obs_weight.value_numeric >= possible_weight_group.min_weight AND obs_weight.value_numeric < possible_weight_group.max_weight
WHERE possible_weight_group.report_group_name = 'Birth Weight Report') AS birth_weight
GROUP BY birth_weight.name
ORDER BY birth_weight.sort_order;    

-- Chlorhexidin applied on Cord
SELECT 'Chlorhexidin applied on Cord', COUNT(obs_chlor.value_coded) as 'Number of Deliveries'
FROM obs_view as obs_delivery_time	
INNER JOIN obs_view AS obs_chlor ON obs_delivery_time.encounter_id = obs_chlor.encounter_id
	AND obs_delivery_time.concept_full_name = 'Delivery date and time'
    AND DATE(obs_delivery_time.value_datetime) BETWEEN @start_date AND @end_date
    AND obs_chlor.concept_full_name = 'Chlorhexidin applied on cord'
    AND obs_chlor.value_coded = 1;
    
-- Obstetric Complications
SELECT diagnoses_names.child_concept_name AS 'Obstetric Complications', count(obs_diagnoses.person_id) AS Number
FROM
(SELECT child_concept_name FROM concept_children_view WHERE parent_concept_name = 'Obstetrics Complications') AS diagnoses_names
LEFT OUTER JOIN confirmed_patient_diagnosis_view AS obs_diagnoses ON diagnoses_names.child_concept_name = obs_diagnoses.name
	AND obs_diagnoses.obs_datetime BETWEEN @start_date AND @end_date
GROUP BY diagnoses_names.child_concept_name;


-- Safe abortion service( No. of women, Post abortion FP Methods)
(SELECT abortion_procedures.age_group AS 'Safe Abortion Service',
	IF(abortion_procedures.procedure_name IS NULL, 0, SUM(IF(abortion_procedures.procedure_name = 'Medical Abortion' || abortion_procedures.procedure_name = 'Medical Induction' || abortion_procedures.procedure_name = 'Other abortion procedures', 1, 0))) as Medical,
    IF(abortion_procedures.procedure_name IS NULL, 0, SUM(IF(abortion_procedures.procedure_name = 'Manual Vacuum Aspiration' || abortion_procedures.procedure_name = 'Electric Vacuum Aspiration' || abortion_procedures.procedure_name = 'Dilation and Evacuation', 1, 0))) as Surgical
FROM  
(SELECT valid_coded_obs_view.value_concept_full_name as procedure_name,
	   observed_age_group.name AS age_group,
	   observed_age_group.id as age_group_id,
	   observed_age_group.sort_order AS sort_order
FROM valid_coded_obs_view
INNER JOIN person ON person.person_id = valid_coded_obs_view.person_id AND person.gender = 'F' AND valid_coded_obs_view.concept_full_name = 'Abortion procedure'
AND DATE(valid_coded_obs_view.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN possible_age_group AS observed_age_group ON
DATE(valid_coded_obs_view.obs_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
WHERE observed_age_group.report_group_name = 'Safe Abortion Service') AS abortion_procedures
GROUP BY abortion_procedures.age_group
ORDER BY abortion_procedures.sort_order)

UNION

(SELECT procedures_fp_methods.fp_name AS 'Post Abortion FP Methods',
	IF(procedures_fp_methods.procedure_name IS NULL, 0, SUM(IF(procedures_fp_methods.procedure_name = 'Medical Abortion' || procedures_fp_methods.procedure_name = 'Medical Induction' || procedures_fp_methods.procedure_name = 'Other abortion procedures', 1, 0))) as Medical,
    IF(procedures_fp_methods.procedure_name IS NULL, 0, SUM(IF(procedures_fp_methods.procedure_name = 'Manual Vacuum Aspiration' || procedures_fp_methods.procedure_name = 'Electric Vacuum Aspiration' || procedures_fp_methods.procedure_name = 'Dilation and Evacuation', 1, 0))) as Surgical
FROM  
(SELECT obs_procedure.value_concept_full_name as procedure_name,
	    obs_fp.value_concept_full_name as fp_name
FROM valid_coded_obs_view as obs_procedure
INNER JOIN valid_coded_obs_view AS obs_fp ON obs_procedure.obs_group_id = obs_fp.obs_group_id 
	AND obs_fp.concept_full_name = 'Accepted Family Planning methods'
	AND obs_procedure.concept_full_name = 'Abortion procedure'
	AND DATE(obs_procedure.obs_datetime) BETWEEN @start_date AND @end_date) AS procedures_fp_methods
GROUP BY procedures_fp_methods.fp_name);

-- Safe Abortion service (Post abortion care)
SELECT pac.pac_category AS 'PAC',
	SUM(IF(pac.pac_cause IS NULL, 0, IF(pac.pac_abortion IS NULL, 0, 1))) AS Facility,
    SUM(IF(pac.pac_cause IS NULL, 0, IF(pac.pac_abortion IS NULL, 1, 0))) AS Others
FROM  
(SELECT pac_cause_list.answer_concept_name AS pac_category, coded_obs_view.value_concept_full_name AS pac_cause, obs_abortion.obs_id AS pac_abortion
FROM
(SELECT answer_concept_name FROM concept_answer_view WHERE question_concept_name = 'PAC Cause') AS pac_cause_list
LEFT OUTER JOIN coded_obs_view ON pac_cause_list.answer_concept_name = coded_obs_view.value_concept_full_name
				AND coded_obs_view.concept_full_name = 'PAC Cause'
				AND DATE(coded_obs_view.obs_datetime) BETWEEN @start_date AND @end_date
LEFT OUTER JOIN obs_view AS obs_abortion ON obs_abortion.person_id = coded_obs_view.person_id
    AND obs_abortion.concept_full_name = 'Abortion procedure'
    AND DATE(obs_abortion.obs_datetime) BETWEEN DATE_SUB(@start_date, INTERVAL 1 MONTH) AND @end_date)
AS pac
GROUP BY pac.pac_category;