SELECT
  SUM(IF(disease.concept_full_name = 'Lower Respiratory Tract Infection', 1, 0))  AS ARI,
  SUM(IF(disease.concept_full_name = 'Presumed Non‐Infectious Diarrhoea', 1, 0))  AS Diarrhoea,
  SUM(IF(disease.concept_full_name <> 'Lower Respiratory Tract Infection' AND
         disease.concept_full_name <> 'Presumed Non‐Infectious Diarrhoea', 1, 0)) AS Others
FROM obs death_note_obs
  JOIN concept_view death_note_concept
    ON death_note_concept.concept_id = death_note_obs.concept_id
       AND death_note_concept.concept_full_name = 'Death Note'
       AND death_note_obs.obs_datetime BETWEEN '#startDate#' AND '#endDate#'

  LEFT JOIN person
    ON person.person_id = death_note_obs.person_id

  JOIN obs death_date_obs
    ON death_date_obs.obs_group_id = death_note_obs.obs_id
    AND death_date_obs.value_datetime BETWEEN DATE_ADD(person.birthdate, INTERVAL 2 MONTH) AND DATE_ADD(person.birthdate, INTERVAL 59 MONTH )

  LEFT JOIN obs primary_cause_obs
    ON death_note_obs.obs_id = primary_cause_obs.obs_group_id
  JOIN concept_view primary_cause_concept
    ON primary_cause_concept.concept_id = primary_cause_obs.concept_id
       AND primary_cause_concept.concept_full_name IN
           ('Death Note, Primary Cause of Death', 'Death Note, Secondary Cause of Death', 'Death Note, Tertiary Cause of Death')
  JOIN concept_view disease
    ON disease.concept_id = primary_cause_obs.value_coded;
