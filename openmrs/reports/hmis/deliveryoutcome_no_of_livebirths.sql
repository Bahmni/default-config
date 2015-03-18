SELECT 'Number of live births' AS name,
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Single - livebirth' && delivery_outcome_liveborn.gender = 'Male',1,0)) AS 'Single - Male',
 SUM(IF(delivery_outcome_liveborn.delivery_outcome_type = 'Single - livebirth' && delivery_outcome_liveborn.gender = 'Female',1,0)) AS 'Single - Female',
 SUM(IF((delivery_outcome_liveborn.delivery_outcome_type = 'Twins - both liveborn' || delivery_outcome_liveborn.delivery_outcome_type ='Twins - one liveborn and one stillborn')&& delivery_outcome_liveborn.gender = 'Male',1,0)) AS 'Twin-Male',
 SUM(IF((delivery_outcome_liveborn.delivery_outcome_type = 'Twins - both liveborn' || delivery_outcome_liveborn.delivery_outcome_type ='Twins - one liveborn and one stillborn')&& delivery_outcome_liveborn.gender = 'Female',1,0)) AS 'Twin-Female',
 SUM(IF((delivery_outcome_liveborn.delivery_outcome_type = 'Other multiple births - all liveborn' || delivery_outcome_liveborn.delivery_outcome_type ='Other multiple births - some liveborn')&& delivery_outcome_liveborn.gender = 'Male',1,0)) AS '>/Triplet-Male',
SUM(IF((delivery_outcome_liveborn.delivery_outcome_type = 'Other multiple births - all liveborn' || delivery_outcome_liveborn.delivery_outcome_type ='Other multiple births - some liveborn')&& delivery_outcome_liveborn.gender = 'Female',1,0)) AS '>/Triplet-Female'
FROM
(SELECT obs_delivery_outcome.value_concept_full_name AS delivery_outcome_type,
    infant_gender.value_concept_full_name AS gender
FROM coded_obs_view as obs_delivery_outcome
INNER JOIN obs_view ON obs_delivery_outcome.obs_group_id = obs_view.obs_group_id
	AND obs_delivery_outcome.concept_full_name = 'Delivery Note, Outcome of Delivery'
    AND obs_view.concept_full_name = 'Delivery Note, Delivery date and time'
 	 AND DATE(obs_view.value_datetime) BETWEEN #startDate# AND #endDate#
    AND obs_delivery_outcome.value_concept_full_name IN 
    ('Single - livebirth','Twins - both liveborn','Twins - one liveborn and one stillborn', 'Other multiple births - all liveborn','Other multiple births - some liveborn')
LEFT OUTER JOIN coded_obs_view AS infant_gender ON obs_delivery_outcome.person_id = infant_gender.person_id  
	AND infant_gender.concept_full_name = 'Delivery Note, Liveborn gender'
    )
AS delivery_outcome_liveborn