SELECT
  final.deliveryOutCome AS 'Delivery OutCome',
  sum(final.singleCount) AS 'Single',
  sum(final.multipleTwinCount) AS 'Multiple Twin',
  sum(final.multipleTripletCount) AS 'Multiple >= Triplet'
FROM
-- ----------------------------------------------
(SELECT 'No of Mother (Live + Still)' AS deliveryOutCome,
Sum(IF(MotherDetails.Answer LIKE '%single%', MotherDetails.Count, 0)) AS singleCount,
Sum(IF(MotherDetails.Answer LIKE '%twins%', MotherDetails.Count, 0)) AS multipleTwinCount,
Sum(IF(MotherDetails.Answer LIKE '%multiple%', MotherDetails.Count, 0)) AS multipleTripletCount
FROM
(SELECT t2.name AS Answer, COUNT(DISTINCT(person_id)) AS 'Count' FROM obs t1
INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
AND t5.concept_name_type = 'FULLY_SPECIFIED'
WHERE t5.name IN ('Delivery Note, Outcome of Delivery')
AND t1.voided = 0 AND
(DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
GROUP BY t2.Name) AS MotherDetails
UNION ALL
(
SELECT IF(Gender LIKE '%Female%', 'No of LiveBirths.Female','No of LiveBirths.Male') AS deliveryOutCome,
Sum(IF(InfantDetails.DeliveryOutcome LIKE '%single%live%', InfantDetails.Count, 0)) AS singleCount,
Sum(IF(InfantDetails.DeliveryOutcome LIKE '%twins%live%', InfantDetails.Count, 0)) AS multipleTwinCount,
Sum(IF(InfantDetails.DeliveryOutcome LIKE '%multiple%live%', InfantDetails.Count, 0)) AS multipleTripletCount
FROM
(SELECT T1.Answer AS Gender,
T2.Answer AS DeliveryOutcome,
COUNT(*) AS  'Count'
FROM
(SELECT t5.name AS Question, t2.name AS Answer,
t1.encounter_id, t4.date_started,
t4.date_stopped, t1.obs_datetime FROM obs t1
INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
AND t5.concept_name_type = 'FULLY_SPECIFIED'
WHERE t5.name IN ('Delivery Note, Liveborn gender')
AND t1.voided = 0) T1 LEFT OUTER JOIN
(SELECT t5.name AS Question, t2.name AS Answer,
t1.encounter_id, t4.date_started, t4.date_stopped, t1.obs_datetime FROM obs t1
INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
AND t5.concept_name_type = 'FULLY_SPECIFIED'
WHERE t5.name IN ('NBA-Child born')
AND t1.voided = 0
) T2 ON T1.encounter_id = T2.encounter_id
WHERE
(DATE(T1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
GROUP BY T1.Answer, T2.Answer
ORDER BY T1.Answer, T2.Answer) AS InfantDetails
GROUP BY Gender
)
-- ----------------------------------------------
UNION ALL SELECT 'No of Mother (Live + Still)',0,0,0
UNION ALL SELECT 'No of LiveBirths.Female',0,0,0
UNION ALL SELECT 'No of LiveBirths.Male',0,0,0
)final
GROUP BY final.deliveryOutCome
ORDER BY CASE final.deliveryOutCome
         WHEN 'No of Mother (Live + Still)' THEN 1
         WHEN 'No of LiveBirths.Female' THEN 2
         ELSE 3 END;
