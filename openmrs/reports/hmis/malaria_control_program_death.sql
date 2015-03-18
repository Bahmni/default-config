SELECT
  disease_name.name,
  SUM(IF(disease_name.name = disease.concept_full_name AND rag.name = '< 5 Years' AND person.person_id IS NOT NULL, 1, 0)) AS '< 5 Years',
  SUM(IF(disease_name.name = disease.concept_full_name AND rag.name = '≥ 5 Years' and person.person_id IS NOT NULL, 1, 0)) AS '≥ 5 Years'
FROM
  (SELECT 'Plasmodium Vivax' name UNION SELECT 'Plasmodium Falciparum' name) AS disease_name
  JOIN reporting_age_group rag
    ON rag.report_group_name = 'Malaria'
  JOIN concept_view death_note_concept
    ON death_note_concept.concept_full_name = 'Death Note'
  LEFT JOIN obs death_note_obs
    ON death_note_concept.concept_id = death_note_obs.concept_id
    AND death_note_obs.obs_datetime BETWEEN '#startDate#' AND '#endDate#'

  LEFT JOIN obs death_date_obs
    ON death_date_obs.obs_group_id = death_note_obs.obs_id

  LEFT JOIN person person
    ON person.person_id = death_note_obs.person_id
    AND CAST(death_date_obs.value_datetime AS DATE) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days DAY))
    AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))

  LEFT JOIN obs primary_cause_obs
    ON death_note_obs.obs_id = primary_cause_obs.obs_group_id
  LEFT JOIN concept_view primary_cause_concept
    ON primary_cause_concept.concept_id = primary_cause_obs.concept_id
    AND primary_cause_concept.concept_full_name IN
           ('Death Note, Primary Cause of Death', 'Death Note, Secondary Cause of Death', 'Death Note, Tertiary Cause of Death')
  LEFT JOIN concept_view disease
    ON disease.concept_id = primary_cause_obs.value_coded
    AND disease.concept_full_name = disease_name.name
GROUP BY disease_name.name;