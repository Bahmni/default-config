SELECT t2.Name AS 'Obstetric Complications', t7.code AS 'ICD Code', COUNT(*) AS  'Number' FROM obs t1
  INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
                                AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
  INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
  INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
  INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
                                AND t5.concept_name_type = 'FULLY_SPECIFIED'
  INNER JOIN concept_reference_map t6 ON t1.value_coded = t6.concept_id
  INNER JOIN concept_reference_term t7 ON t6.concept_reference_term_id = t7.concept_reference_term_id
  INNER JOIN concept_reference_source t8 ON t7.concept_source_id = t8.concept_source_id AND t8.name = 'ICD-10-WHO'
WHERE t5.name IN ('ANC-Obstetric Complication')
      AND t1.voided = 0  AND t2.name NOT LIKE '%Not present%' AND
      (t1.obs_datetime >='#startDate#' AND t1.obs_datetime <= '#endDate#')
GROUP BY t2.name, t7.code;