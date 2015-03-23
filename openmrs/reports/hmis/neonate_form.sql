SELECT
  delivery_outcome AS 'Count of Delivery Outcome / Gestation Period',
  SUM(22_27)       AS '22 - 27',
  SUM(28_36)       AS '28 - 36',
  SUM(37_41)       AS '37 - 41',
  SUM(above41)     AS '>= 42'
FROM
  (SELECT
     IF(outcome_value.concept_full_name LIKE 'Single%', 'Primi', 
     IF(outcome_value.concept_full_name LIKE 'Twins%', 'Multi', 'Grand Multi'))                     AS delivery_outcome,
     IF(outcome_value.concept_full_name LIKE 'Single%', 1, IF(outcome_value.concept_full_name LIKE 'Twins%', 2, 3)) AS sort_order,
     SUM(if(gestation_period_obs.value_numeric BETWEEN 22 AND 27, 1, 0))                  AS 22_27,
     SUM(if(gestation_period_obs.value_numeric BETWEEN 28 AND 36, 1, 0))                  AS 28_36,
     SUM(if(gestation_period_obs.value_numeric BETWEEN 37 AND 41, 1, 0))                  AS 37_41,
     SUM(if(gestation_period_obs.value_numeric >= 42, 1, 0))                              AS above41
   FROM obs outcome_of_delivery_obs
     LEFT OUTER JOIN obs gestation_period_obs
       ON outcome_of_delivery_obs.person_id = gestation_period_obs.person_id
          AND gestation_period_obs.concept_id = (SELECT concept_id
                                                 FROM concept_view
                                                 WHERE concept_full_name = 'Delivery Note, Gestation period')
          AND gestation_period_obs.voided = FALSE
     INNER JOIN concept_view outcome_value
       ON outcome_value.concept_id = outcome_of_delivery_obs.value_coded
   WHERE
     outcome_of_delivery_obs.concept_id = (SELECT concept_id
                                           FROM concept_view
                                           WHERE concept_full_name = 'Delivery Note, Outcome of Delivery')
     AND DATE(outcome_of_delivery_obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
     AND outcome_of_delivery_obs.voided = FALSE
   GROUP BY outcome_value.concept_full_name) simpler_form
GROUP BY delivery_outcome
ORDER BY sort_order;