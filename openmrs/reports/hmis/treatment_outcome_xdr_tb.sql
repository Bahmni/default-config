SELECT
  coalesce(outcome_concept.concept_short_name, outcome_concept.concept_full_name) AS Outcome,
  sum(if(p.person_id IS NOT NULL AND p.gender = 'M', 1, 0))            M,
  sum(if(p.person_id IS NOT NULL AND p.gender = 'F', 1, 0))            F
FROM
  concept_view cv
  JOIN concept_answer outcome_concept_answer ON outcome_concept_answer.concept_id = cv.concept_id AND cv.concept_full_name = 'DRTuberculosis, Treatment outcome'
  JOIN concept_view outcome_concept ON outcome_concept_answer.answer_concept = outcome_concept.concept_id
  LEFT JOIN
  (SELECT
     outcome_obs.person_id,
     outcome_obs.value_coded,
     outcome_obs.obs_datetime
   FROM obs AS outcome_obs
     JOIN obs AS xdr_tb_obs ON outcome_obs.person_id = xdr_tb_obs.person_id AND xdr_tb_obs.voided IS FALSE AND outcome_obs.voided IS FALSE
     JOIN concept_view AS diagnosis_concept ON diagnosis_concept.concept_id = xdr_tb_obs.concept_id AND diagnosis_concept.concept_full_name = 'Coded Diagnosis'
     JOIN concept_view AS xdr_tb_concept ON xdr_tb_concept.concept_id = xdr_tb_obs.value_coded AND xdr_tb_concept.concept_full_name = 'Extremely Drug Resistant Tuberculosis'
     JOIN obs AS certainty_obs ON certainty_obs.person_id = xdr_tb_obs.person_id AND certainty_obs.obs_group_id = xdr_tb_obs.obs_group_id AND certainty_obs.voided IS FALSE
     JOIN concept_name AS certainty_concept ON certainty_concept.concept_id = certainty_obs.value_coded AND certainty_concept.concept_name_type = 'FULLY_SPECIFIED' AND certainty_concept.name = 'Confirmed'
     JOIN concept_name revised_concept ON revised_concept.name = 'Bahmni Diagnosis Revised' AND revised_concept.concept_name_type = 'FULLY_SPECIFIED'
     LEFT JOIN obs as revised_obs on revised_concept.concept_id = revised_obs.concept_id and revised_obs.voided is false and xdr_tb_obs.obs_group_id = revised_obs.obs_group_id
     JOIN concept_name ruled_out_concept ON ruled_out_concept.name = 'Ruled Out Diagnosis' AND ruled_out_concept.concept_name_type = 'FULLY_SPECIFIED'
     LEFT JOIN obs ruled_out ON ruled_out.value_coded = ruled_out_concept.concept_id
                                AND ruled_out.obs_group_id = xdr_tb_obs.obs_group_id AND ruled_out.voided IS FALSE
   WHERE ruled_out.value_coded IS NULL and revised_obs.value_coded = (select property_value from global_property where property = 'concept.false')
  ) AS outcome
    ON outcome_concept_answer.answer_concept = outcome.value_coded AND DATE(outcome.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
  LEFT JOIN person p ON outcome.person_id = p.person_id AND p.voided IS FALSE
GROUP BY Outcome;
