SELECT final.TypeofDelivery AS 'Type of Delivery',
  sum(final.Cephalic) AS 'Cephalic Presentation',
  sum(final.Shoulder) AS 'Shoulder Presentation',
  sum(final.Breech) AS 'Breech Presentation'
FROM
-- ----------------------------------------------
(SELECT DeliveryDetails.TypeofDelivery AS TypeofDelivery,
SUM(IF(DeliveryDetails.Presentation LIKE '%Cephalic%', 1, 0)) AS Cephalic,
SUM(IF(DeliveryDetails.Presentation LIKE '%Shoulder%', 1, 0)) AS Shoulder,
SUM(IF(DeliveryDetails.Presentation LIKE '%Breech%', 1, 0)) AS Breech
FROM
(SELECT DISTINCT T1.person_id, T1.Answer AS 'Presentation', T2.Answer AS 'TypeofDelivery' FROM
(SELECT DISTINCT t1.person_id, t5.name AS Question, t2.name AS Answer FROM obs t1
INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
AND t5.concept_name_type = 'FULLY_SPECIFIED'
WHERE t5.name IN ('Delivery Note, Fetal Presentation')
AND t1.voided = 0 AND
(DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
GROUP BY t1.person_id, t5.name, t2.Name) T1
INNER JOIN
(SELECT DISTINCT t1.person_id, t5.name AS Question, t2.name AS Answer FROM obs t1
INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
AND t5.concept_name_type = 'FULLY_SPECIFIED'
WHERE t5.name IN ('Delivery Note, Method of Delivery')
AND t1.voided = 0 AND
(DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
GROUP BY t1.person_id, t5.name, t2.Name) T2 ON
T1.person_id = T2.person_id) DeliveryDetails
GROUP BY DeliveryDetails.TypeofDelivery
-- ----------------------------------------------
UNION ALL SELECT 'Caesarean Section',0,0,0
UNION ALL SELECT 'Forceps or Vaccum Extracted Delivery',0,0,0
UNION ALL SELECT 'Spontaneous Vaginal Delivery',0,0,0) final
GROUP BY final.TypeofDelivery
ORDER BY final.TypeofDelivery;

