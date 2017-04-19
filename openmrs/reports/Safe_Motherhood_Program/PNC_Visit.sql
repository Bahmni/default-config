SELECT IF(t2.Name = 'PNC, First Visit','Within 24 hour','3 PNC visit as per protocol') AS 'PNC Visit', COUNT(*) AS 'Number' FROM obs t1
  INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
                                AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
  INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
  INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
  INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
                                AND t5.concept_name_type = 'FULLY_SPECIFIED'
WHERE t5.name = 'PNC, Visit Number'
      AND t1.voided = 0 AND t2.Name IN ('PNC, First Visit', 'PNC, Third Visit' ) AND
      (t1.obs_datetime >='#startDate#' AND t1.obs_datetime <= '#endDate#')
GROUP BY t2.name;