SELECT
  abortion_data.name 'Age Group',
  abortion_data.trimester 'Trimester',
  abortion_data.type 'Abortion Type',
  SUM(if(abortion_data.type = abortion_data.abortion_constant_data AND
         abortion_data.person_id IS NOT NULL AND
         ((abortion_data.value_numeric <= 12 AND abortion_data.trimester = '1st Trimester') OR
          (abortion_data.value_numeric > 12 and abortion_data.value_numeric <= 27 AND abortion_data.trimester = '2nd Trimester')), 1, 0)) 'Count'
FROM
  (SELECT
     reporting_age.name,
     abortion_type.type,
     obs2.value_numeric,
     person.person_id,
     CASE
     WHEN concept_name.name = 'Medical Induction' OR
          concept_name.name = 'Safe Abortion, Medical Abortion' THEN 'Medical'
     WHEN concept_name.name = 'Other abortion procedures' THEN 'Other'
     ELSE 'Surgical'
     END 'abortion_constant_data',
     trimester_data.trimester,
     reporting_age.sort_order
   FROM
     (SELECT 'Surgical' AS 'type'
      UNION SELECT 'Medical' AS 'type'
      UNION SELECT 'Other' AS 'type') AS abortion_type
     INNER JOIN (SELECT '1st Trimester' AS trimester
                 UNION SELECT '2nd Trimester' AS trimester) AS trimester_data
     LEFT JOIN (SELECT
                  encounter_id,
                  obs_group_id,
                  value_coded,
                  person_id,
                  obs_datetime
                FROM obs
                WHERE concept_id = (SELECT concept_id
                                    FROM concept_name
                                    WHERE
                                      name = 'Abortion Procedure' AND concept_name_type = 'FULLY_SPECIFIED')) AS obs1
       ON obs1.obs_datetime BETWEEN cast('#startDate#' AS DATE) AND cast('#endDate#' AS DATE)
     LEFT JOIN (SELECT
                  encounter_id,
                  obs_group_id,
                  value_numeric
                FROM obs
                WHERE concept_id = (SELECT concept_id
                                    FROM concept_name
                                    WHERE
                                      name = 'Weeks of current gestation by LMP method' AND
                                      concept_name_type = 'FULLY_SPECIFIED')) AS obs2
       ON obs1.encounter_id = obs2.encounter_id AND obs1.obs_group_id = obs2.obs_group_id
     LEFT JOIN concept_name
       ON concept_name.concept_id = obs1.value_coded AND concept_name.concept_name_type = 'FULLY_SPECIFIED'
     LEFT JOIN reporting_age_group reporting_age ON reporting_age.report_group_name = 'Abortion Services Report'
     LEFT JOIN person ON obs1.person_id = person.person_id
                         AND cast(obs1.obs_datetime AS DATE) BETWEEN (DATE_ADD(
       DATE_ADD(person.birthdate, INTERVAL reporting_age.min_years YEAR), INTERVAL reporting_age.min_days DAY))
   AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age.max_years YEAR), INTERVAL reporting_age.max_days
                 DAY))) abortion_data
GROUP BY abortion_data.name, abortion_data.trimester, abortion_data.type
order by abortion_data.sort_order