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
SELECT IF(Gender='F', 'No of LiveBirths.Female','No of LiveBirths.Male') AS deliveryOutCome,
Sum(IF(InfantDetails.DeliveryOutcome='Single', InfantDetails.Count, 0)) AS singleCount,
Sum(IF(InfantDetails.DeliveryOutcome='Twin', InfantDetails.Count, 0)) AS multipleTwinCount,
Sum(IF(InfantDetails.DeliveryOutcome='Multiple', InfantDetails.Count, 0)) AS multipleTripletCount
FROM
(
SELECT 
   first_answers.answer_name AS DeliveryOutcome,
   first_concept.gender AS Gender,
    COUNT(DISTINCT (first_concept.person_id)) AS 'Count'
FROM
    (SELECT 
        ca.answer_concept AS answer,
            IFNULL(answer_concept_short_name.name, answer_concept_fully_specified_name.name) AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    INNER JOIN concept_answer ca ON c.concept_id = ca.concept_id
    INNER JOIN concept_name answer_concept_fully_specified_name ON ca.answer_concept = answer_concept_fully_specified_name.concept_id
        AND answer_concept_fully_specified_name.concept_name_type = 'FULLY_SPECIFIED'
        AND answer_concept_fully_specified_name.voided
        IS FALSE
    LEFT JOIN concept_name answer_concept_short_name ON ca.answer_concept = answer_concept_short_name.concept_id
        AND answer_concept_short_name.concept_name_type = 'SHORT'
        AND answer_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('NBA-Child born')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
        LEFT OUTER JOIN
    (SELECT DISTINCT
        o1.person_id,
        p1.gender AS gender,
            cn2.concept_id AS answer,
            cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('NBA-Child born')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN '#startDate#' AND '#endDate#'
            AND o1.value_coded IS NOT NULL) first_concept ON first_concept.answer = first_answers.answer
GROUP BY first_answers.answer_name,first_concept.gender
) AS InfantDetails
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
