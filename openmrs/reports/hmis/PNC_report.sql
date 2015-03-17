select * from
(select
'PNC Visit - Within 24 hour' as report,
count(person.person_id) as no_of_patient
	from person
	join obs first_visit_obs
		on first_visit_obs.person_id=person.person_id
		and first_visit_obs.obs_datetime between cast('#startDate#' AS DATE) AND cast('#endDate#' AS DATE)
		and first_visit_obs.value_coded = (select concept_id from concept_name where name = 'PNC, First Visit' and concept_name_type='FULLY_SPECIFIED')
	join obs delivery_date_obs
		on delivery_date_obs.person_id = person.person_id
		join concept_name delivery_date_concept
			on delivery_date_concept.concept_id = delivery_date_obs.concept_id
			and delivery_date_concept.name = 'Delivery Note, Delivery date and time'
			and delivery_date_concept.concept_name_type='FULLY_SPECIFIED'
		and first_visit_obs.obs_datetime between delivery_date_obs.value_datetime
			AND DATE_ADD(delivery_date_obs.value_datetime, INTERVAL 24 HOUR)
	) as within_24hour
union
(select
'3 PNC Visit as per protocol' as report,
count(person.person_id) as no_of_patient
	from person
	left join obs third_visit_obs
		on third_visit_obs.person_id=person.person_id
		and third_visit_obs.obs_datetime between cast('#startDate#' AS DATE) AND cast('#endDate#' AS DATE)
		and third_visit_obs.value_coded = (select concept_id from concept_name where name = 'PNC, Third Visit' and concept_name_type='FULLY_SPECIFIED')

	left join obs second_visit_obs
		on third_visit_obs.person_id = second_visit_obs.person_id
			and second_visit_obs.value_coded = (select concept_id from concept_name where name = 'PNC, Second Visit' and concept_name_type='FULLY_SPECIFIED')

	left join obs first_visit_obs
		on third_visit_obs.person_id = first_visit_obs.person_id
			and first_visit_obs.value_coded = (select concept_id from concept_name where name = 'PNC, First Visit' and concept_name_type='FULLY_SPECIFIED')

	left join obs delivery_date_obs
		on delivery_date_obs.person_id = third_visit_obs.person_id
		join concept_name delivery_date_concept
			on delivery_date_concept.concept_id = delivery_date_obs.concept_id
			and delivery_date_concept.name = 'Delivery Note, Delivery date and time'
			and delivery_date_concept.concept_name_type='FULLY_SPECIFIED'

	and first_visit_obs.obs_datetime between delivery_date_obs.value_datetime AND DATE_ADD(delivery_date_obs.value_datetime, INTERVAL 24 HOUR) 
	and second_visit_obs.obs_datetime between DATE_ADD(delivery_date_obs.value_datetime, INTERVAL 24 HOUR) AND DATE_ADD(delivery_date_obs.value_datetime, INTERVAL 3 DAY)	
	and third_visit_obs.obs_datetime between DATE_ADD(delivery_date_obs.value_datetime, INTERVAL 3 DAY) AND DATE_ADD(delivery_date_obs.value_datetime, INTERVAL 7 DAY));