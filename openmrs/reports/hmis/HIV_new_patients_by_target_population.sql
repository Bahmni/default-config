SELECT
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'Sex Worker', 1, 0)), 0)                    AS FSW,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'People Who Inject Drugs', 1, 0)), 0)       AS IDU,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'MSM and Transgenders', 1, 0)), 0)          AS MSM,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'Migrant', 1, 0)), 0)                       AS Migrant,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name NOT IN
                ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs'), 1, 0)), 0) AS Others
FROM obs risk_group_obs
  JOIN concept_view risk_group_concept
    ON risk_group_concept.concept_id = risk_group_obs.concept_id AND
       risk_group_concept.concept_full_name = 'HIVTC, Risk Group'
       AND risk_group_obs.voided = 0 AND
       DATE(risk_group_obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
  LEFT JOIN concept_view risk_group_value_concept ON risk_group_value_concept.concept_id = risk_group_obs.value_coded;
