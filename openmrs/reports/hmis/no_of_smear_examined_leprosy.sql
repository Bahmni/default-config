SELECT
  SUM(IF(p.gender = 'F' && leprosy_type_answer.concept_full_name='Multi Bacillary',  1, 0)) AS 'Total Multi Bacillary Female',
  SUM(IF(p.gender = 'M' && leprosy_type_answer.concept_full_name='Multi Bacillary',  1, 0)) AS 'Total Multi Bacillary Male',
  SUM(IF(p.gender = 'F' && leprosy_type_answer.concept_full_name='Pauci Bacillary',  1, 0)) AS 'Total Pauci Bacillary Female',
  SUM(IF(p.gender = 'M' && leprosy_type_answer.concept_full_name='Pauci Bacillary',  1, 0)) AS 'Total Pauci Bacillary Male'
FROM visit v
  INNER JOIN encounter e ON v.visit_id = e.visit_id AND v.visit_id
                            AND DATE(v.date_stopped) BETWEEN '#startDate#' AND '#endDate#' AND e.voided = 0
  INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0
  INNER JOIN concept_view leprosy_case_type_concept
    ON leprosy_case_type_concept.concept_id = o.concept_id AND
       leprosy_case_type_concept.concept_full_name = 'Leprosy, Case Type'
  INNER JOIN concept_view leprosy_case_type_answer ON o.value_coded = leprosy_case_type_answer.concept_id AND
                                                      leprosy_case_type_answer.concept_full_name = 'New Patients'
  INNER JOIN obs leprosy_type_obs ON leprosy_type_obs.obs_group_id = o.obs_group_id AND leprosy_type_obs.voided = 0
  INNER JOIN concept_view leprosy_type_concept ON leprosy_type_obs.concept_id = leprosy_type_concept.concept_id AND
                                                  leprosy_type_concept.concept_full_name = 'Leprosy, Leprosy Type'
  INNER JOIN concept_view leprosy_type_answer ON leprosy_type_obs.value_coded = leprosy_type_answer.concept_id
  INNER JOIN concept_view leprae_concept ON leprae_concept.concept_full_name = 'M. Leprae (Slit Skin)'
  LEFT JOIN obs leprae_obs
    ON o.obs_group_id = leprae_obs.obs_group_id AND leprae_obs.concept_id = leprae_concept.concept_id AND leprae_obs.voided = 0
  JOIN person p ON p.person_id = e.patient_id;