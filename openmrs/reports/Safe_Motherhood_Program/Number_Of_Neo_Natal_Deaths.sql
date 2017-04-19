SELECT COUNT(*) AS 'Number of Neo-Natal Deaths' FROM obs t1
  INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
  INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
  INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
                                AND t5.concept_name_type = 'FULLY_SPECIFIED'
WHERE t5.name LIKE 'PNC, Date of Neonatal Death%'
      AND t1.voided = 0 AND t1.value_datetime IS NOT NULL AND
      (t1.obs_datetime >='#startDate#' AND t1.obs_datetime <= '#endDate#')
GROUP BY t5.name
ORDER BY t5.name;