select
pv_or_pf_concept.concept_full_name as died_by,
observed_age_group.name AS age_group,
SUM(IF(person.gender = 'F', 1, 0))       AS female,
SUM(IF(person.gender = 'M', 1, 0))       AS male,
SUM(IF(person.gender = 'O', 1, 0))       AS other
from obs as death_date_obs
	join person on person.person_id = death_date_obs.person_id

	join concept_view death_date_concept
		on death_date_concept.concept_id = death_date_obs.concept_id
		and death_date_concept.concept_full_name = 'Death Note, Pronounced Death Date and Time'
	and death_date_obs.value_datetime between cast('%s' AS DATE) AND cast('%s' AS DATE)

	left join obs brought_dead_obs
		on brought_dead_obs.obs_group_id = death_date_obs.obs_group_id
		and brought_dead_obs.voided = false
		join concept_view brought_dead_concept
			on brought_dead_concept.concept_id = brought_dead_obs.concept_id
			and brought_dead_concept.concept_full_name = 'Death Note, Brought dead'
		and brought_dead_obs.value_coded = (select concept_id from concept_view where concept_full_name = 'False')
		and brought_dead_obs.voided = false

	left join obs primary_cause_obs
		on primary_cause_obs.obs_group_id = death_date_obs.obs_group_id
		and primary_cause_obs.voided = false
		join concept_view primary_cause_concept
			on primary_cause_obs.concept_id = primary_cause_concept.concept_id
			and primary_cause_concept.concept_full_name = 'Death Note, Primary Cause of Death'
		join concept_view pv_or_pf_concept
			on pv_or_pf_concept.concept_id = primary_cause_obs.value_coded
		and pv_or_pf_concept.concept_full_name in ('Plasmodium Falciparum', 'Plasmodium Vivax')

	JOIN reporting_age_group as observed_age_group
		ON observed_age_group.report_group_name = 'Malaria'
		AND death_date_obs.obs_datetime BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
group by age_group, died_by;