SELECT
  'Patients medically eligible for ART but have not started' AS 'Anteretroviral Treatment : Status of HIV Care',
  'End'                                                      AS 'of this Month',
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'Sex Worker', 1, 0)), 0)                    AS FSW,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'People Who Inject Drugs', 1, 0)), 0)       AS IDU,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'MSM and Transgenders', 1, 0)), 0)          AS MSM,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name = 'Migrant', 1, 0)), 0)                       AS Migrant,
  ifnull(SUM(IF(risk_group_value_concept.concept_full_name NOT IN
                ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs'), 1, 0)), 0) AS Others
FROM

  obs eligible_obs
  JOIN person p ON eligible_obs.person_id = p.person_id
  JOIN concept_view eligible_concept
    ON eligible_concept.concept_id = eligible_obs.concept_id
       AND eligible_concept.concept_full_name = 'HIVTC, ART eligible date'
       AND eligible_obs.voided = 0
       AND DATE(eligible_obs.value_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
       AND eligible_obs.person_id NOT IN
           (SELECT person_id
            FROM obs start_date_obs
              JOIN concept_view start_date_concept
                ON start_date_concept.concept_id = start_date_obs.concept_id
                   AND start_date_concept.concept_full_name = 'HIVTC, ART start date'
                   AND start_date_obs.voided = 0
                   AND start_date_obs.value_datetime IS NOT NULL
                   AND DATE(obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
           )
    JOIN obs risk_group_obs
      ON eligible_obs.person_id = risk_group_obs.person_id
         AND risk_group_obs.voided = 0
         AND DATE(risk_group_obs.obs_datetime) < CAST('#endDate#' AS DATE)
    JOIN concept_view risk_group_concept
      ON risk_group_concept.concept_id = risk_group_obs.concept_id AND
         risk_group_concept.concept_full_name = 'HIVTC, Risk Group'
    JOIN concept_view risk_group_value_concept ON risk_group_value_concept.concept_id = risk_group_obs.value_coded;