SELECT birth_weight.name as 'Birth Weight',
	count(*) AS 'Total Number',
    IF(birth_weight.asphyxia IS NULL, 0, 1) AS 'Asphyxia',
    IF(birth_weight.defect IS NULL, 0, 1) AS 'Defect'
FROM 
(SELECT obs_weight.value_numeric as weight,
 obs_defect.value_coded as defect,
 obs_asphyxia.value_concept_full_name as asphyxia,
 possible_weight_group.name, possible_weight_group.sort_order as sort_order
FROM obs_view as obs_delivery_time
INNER JOIN obs_view AS obs_weight ON obs_weight.encounter_id = obs_delivery_time.encounter_id
	AND obs_delivery_time.concept_full_name = 'Delivery Note, Delivery date and time'
    AND DATE(obs_delivery_time.value_datetime) BETWEEN @start_date AND @end_date
    AND obs_weight.concept_full_name = 'Delivery Note, Liveborn weight'
LEFT OUTER JOIN obs_view AS obs_defect ON obs_weight.obs_group_id = obs_defect.obs_group_id
		AND obs_defect.concept_full_name = 'Delivery Note, Liveborn defects present'
        AND obs_defect.value_coded = 1
LEFT OUTER JOIN coded_obs_view AS obs_asphyxia ON obs_weight.obs_group_id = obs_asphyxia.obs_group_id
	AND obs_asphyxia.concept_full_name = 'Delivery Note, New Born Status'
	AND obs_asphyxia.value_concept_full_name = 'Asphyxiated'
RIGHT OUTER JOIN possible_weight_group ON
	obs_weight.value_numeric >= possible_weight_group.min_weight AND obs_weight.value_numeric < possible_weight_group.max_weight
WHERE possible_weight_group.report_group_name = 'Birth Weight Report') AS birth_weight
GROUP BY birth_weight.name
ORDER BY birth_weight.sort_order;    