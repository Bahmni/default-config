-- Parameters
SET @start_date = '2014-09-01';
SET @end_date = '2014-10-01';

-- Constants
SET @report_group_name = 'Inpatient Discharge Reports';
SET @inpatient_outcome_concept_name = 'Inpatient Outcome';

-- Query
SELECT 	distinct answer.concept_full_name,
		possible_age_group.name AS age_group,
		IF(inpatient_outcome_obs.age_group_id IS NULL, 0, SUM(IF(inpatient_outcome_obs.gender = 'F', 1, 0))) AS female,
		IF(inpatient_outcome_obs.age_group_id IS NULL, 0, SUM(IF(inpatient_outcome_obs.gender = 'M', 1, 0))) AS male,
		IF(inpatient_outcome_obs.age_group_id IS NULL, 0, COUNT(person_id)) as total
FROM concept_view as question
JOIN concept_answer ON question.concept_id = concept_answer.concept_id
JOIN concept_view as answer ON answer.concept_id = concept_answer.answer_concept
LEFT OUTER JOIN possible_age_group ON possible_age_group.report_group_name = @report_group_name
LEFT OUTER JOIN (
	SELECT distinct valid_coded_obs_view.concept_id, valid_coded_obs_view.value_coded, observed_age_group.id as age_group_id, person.person_id, person.gender
	FROM valid_coded_obs_view 
	LEFT OUTER JOIN person ON valid_coded_obs_view.person_id = person.person_id
	LEFT OUTER JOIN possible_age_group as observed_age_group ON observed_age_group.report_group_name = @report_group_name AND
					valid_coded_obs_view.obs_datetime BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY)) 
											AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY)) 
	WHERE valid_coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date AND valid_coded_obs_view.concept_full_name = @inpatient_outcome_concept_name
) AS inpatient_outcome_obs ON inpatient_outcome_obs.concept_id = question.concept_id AND inpatient_outcome_obs.value_coded = answer.concept_id 
	 AND possible_age_group.id = inpatient_outcome_obs.age_group_id
WHERE question.concept_full_name = @inpatient_outcome_concept_name
GROUP BY answer.concept_id, age_group
ORDER BY answer.concept_id, possible_age_group.sort_order;