SELECT 'Number of live births' AS name,
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Single - livebirth',1,0)) AS 'Single',
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Twins - both liveborn' || delivery_outcome_liveborn.delivery_outcome_type ='Twins - one liveborn and one stillborn',1,0)) AS 'Twin',
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Other multiple births - all liveborn' || delivery_outcome_liveborn.delivery_outcome_type ='Other multiple births - some liveborn',1,0)) AS '>/Triplet'
FROM
(SELECT obs_delivery_outcome.value_concept_full_name AS delivery_outcome_type
FROM coded_obs_view as obs_delivery_outcome
INNER JOIN obs_view ON obs_delivery_outcome.obs_group_id = obs_view.obs_group_id
	AND obs_delivery_outcome.concept_full_name = 'Delivery Note, Outcome of Delivery'
    AND obs_view.concept_full_name = 'Delivery Note, Delivery date and time'
 	 AND DATE(obs_view.value_datetime) BETWEEN @start_date AND @end_date
    AND obs_delivery_outcome.value_concept_full_name IN ('Single - livebirth','Twins - both liveborn','Twins - one liveborn and one stillborn', 'Other multiple births - all liveborn','Other multiple births - some liveborn'))
AS delivery_outcome_liveborn