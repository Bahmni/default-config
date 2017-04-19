SELECT
  final.Blood AS Blood,
  sum(final.BloodTransfusion) AS 'Blood Transfusion'
FROM
#################################################################
(SELECT
   'No'     AS Blood,
   COUNT(*) AS BloodTransfusion
 FROM obs t1
   INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
                                 AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED' AND t2.Name <> 'Stillbirth'
   INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
   INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
   INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
                                 AND t5.concept_name_type = 'FULLY_SPECIFIED'
 WHERE t5.name = 'Delivery Note, Blood transfusion provided'
       AND t1.voided = 0 AND t1.value_coded = 1 AND
       (t1.obs_datetime >= '#startDate#' AND t1.obs_datetime <= '#endDate#')
 GROUP BY t2.name
UNION ALL
SELECT
   'Unit'                AS Blood,
   SUM(t1.value_numeric) AS BloodTransfusion
 FROM obs t1
   INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
   INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
   INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
                                 AND t5.concept_name_type = 'FULLY_SPECIFIED'
 WHERE t5.name LIKE 'Delivery Note, Blood transfusion quantity%'
       AND t1.voided = 0 AND
       (t1.obs_datetime >= '#startDate#' AND t1.obs_datetime <= '#endDate#')
 GROUP BY t5.name
#################################################################
UNION ALL SELECT 'No',0
UNION ALL SELECT 'Unit',0) final
GROUP BY final.Blood
ORDER BY final.Blood;