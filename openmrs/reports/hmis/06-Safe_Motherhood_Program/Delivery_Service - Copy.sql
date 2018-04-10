SELECT
  final.deliveryService AS 'Delivery Service',
  sum(final.facility) AS Facility
FROM
-- ----------------------------------------------
(SELECT
 t2.name  deliveryService,
 COUNT(*) facility
FROM obs t1
 INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id AND
                               t2.concept_name_type LIKE 'SHORT%' AND t2.voided = 0
 INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
 INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
WHERE t1.concept_id IN (SELECT concept_id
                       FROM
                         concept_name
                       WHERE
                         NAME IN ('Delivery Note, Delivery service done by')
                         AND voided = 0) AND t1.value_coded IN
                                             (SELECT concept_id
                                              FROM concept_name
                                              WHERE NAME IN ('Non SBA Health worker', 'Skilled Birth Attendant') AND
                                                    voided = 0)
     AND t1.voided = 0 AND
    (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
GROUP BY t2.name
-- ----------------------------------------------
UNION ALL SELECT 'SBA',0
UNION ALL SELECT 'Non SBA',0) final
GROUP BY final.deliveryService
ORDER BY final.deliveryService DESC;