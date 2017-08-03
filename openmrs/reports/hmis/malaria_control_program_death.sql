SELECT
  disease_name.name as disease,
  rag.name as age_category,
  SUM(IF(disease_name.name = answer.name AND person.person_id IS NOT NULL, 1, 0)) AS count
FROM
  (SELECT 'Plasmodium Vivax' name UNION SELECT 'Plasmodium Falciparum' name) AS disease_name
  JOIN reporting_age_group rag ON rag.report_group_name = 'Malaria'
  JOIN concept_view question ON question.concept_full_name in
                                              ('Death Note, PRIMARY Cause of Death', 'Death Note, Secondary Cause of Death', 'Death Note, Tertiary Cause of Death')
  JOIN concept_name answer on answer.name = disease_name.name AND answer.concept_name_type = 'FULLY_SPECIFIED'
  LEFT JOIN obs obs ON obs.concept_id = question.concept_id
       AND obs.value_coded = answer.concept_id
       AND date(obs.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
       AND obs.voided=0
  LEFT JOIN person person ON person.person_id = obs.person_id
       AND CAST(obs.obs_datetime AS DATE) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days DAY))
       AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
GROUP BY disease_name.name, rag.name;

