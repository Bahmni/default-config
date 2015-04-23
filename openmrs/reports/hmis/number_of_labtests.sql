SELECT COUNT(*) from concept_view  
LEFT OUTER JOIN orders ON concept_view.concept_id = orders.concept_id AND orders.order_type_id = 3
	AND concept_view.concept_class_name = 'LabTest'
LEFT OUTER JOIN obs
ON orders.order_id = obs.order_id AND orders.concept_id = obs.concept_id
	AND obs.voided = 0
	AND DATE(obs.obs_datetime) BETWEEN '#startDate#' AND '#endDate#';
