SELECT
  header.concept_full_name as 'Age Group for Early Infant Diagnosis (EID)',
  IF(infant_diagnosis.positive IS NULL , 0, infant_diagnosis.positive) as positive,
  IF(infant_diagnosis.negative IS NULL , 0, infant_diagnosis.negative) as negative
FROM
  (SELECT
     concept_id,
     concept_full_name
   FROM concept_view
   WHERE concept_full_name IN ('Within 2 months', '2 to 9 months', '9 to 18 months', 'Antibody > 18 months')
  ) AS header
  LEFT JOIN
  (SELECT
     early_infant_obs.value_coded                                        AS concept_id,
     SUM(IF(pcr_test_result_value.concept_full_name = 'Positive', 1, 0)) AS positive,
     SUM(IF(pcr_test_result_value.concept_full_name = 'Negative', 1, 0)) AS negative
   FROM obs hiv_exposed_obs
     JOIN concept_view hiv_exposed_concept
       ON hiv_exposed_concept.concept_id = hiv_exposed_obs.concept_id
          AND hiv_exposed_concept.concept_full_name = 'ART, HIV Exposed Baby'

     LEFT JOIN obs test_date_obs
       ON test_date_obs.obs_group_id = hiv_exposed_obs.obs_id
     JOIN concept_view test_date_concept
       ON test_date_concept.concept_id = test_date_obs.concept_id
          AND test_date_concept.concept_full_name = 'ART, Test Date'
          AND cast(test_date_obs.value_datetime as date) BETWEEN '#startDate#' AND '#endDate#'

     LEFT JOIN obs early_infant_obs
       ON hiv_exposed_obs.obs_id = early_infant_obs.obs_group_id
     JOIN concept_view early_infant_concept
       ON early_infant_obs.concept_id = early_infant_concept.concept_id
          AND early_infant_concept.concept_full_name = 'ART, Early Infant Diagnosis'

     LEFT JOIN obs pcr_test_result_obs
       ON pcr_test_result_obs.obs_group_id = hiv_exposed_obs.obs_id
     JOIN concept_view pcr_test_result_concept
       ON pcr_test_result_concept.concept_id = pcr_test_result_obs.concept_id
          AND pcr_test_result_concept.concept_full_name = 'ART, Test Result'
     JOIN concept_view pcr_test_result_value
       ON pcr_test_result_value.concept_id = pcr_test_result_obs.value_coded
   GROUP BY early_infant_obs.value_coded
  ) AS infant_diagnosis
    ON infant_diagnosis.concept_id = header.concept_id;