
SELECT sum(final.receivingFirstTime)                            as 'Iron Tablets at First Time',
  sum(final.receivingMoreThan180)                               as '180 Iron Tablets',
  sum(final.receivingDeworming)                                 as 'Deworming Tablets',
  sum(final.receivingMoreThan45) as 'PP mother Receiving >= 45 Iron Tablets',
  sum(final.receivingVitaminA) as 'PP mother Receiving Vitamin A Capsules'
FROM

(-- Pregnant women receiving - Iron tablets first time
SELECT
  COUNT(DISTINCT (this_month.patient)) AS receivingFirstTime,
  0 AS receivingMoreThan180,
  0 AS receivingDeworming,
  0 AS receivingMoreThan45,
  0 AS receivingVitaminA
FROM
  (SELECT ov.person_id AS patient
   FROM nonVoidedQuestionObs ov
   WHERE ov.question_full_name = 'ANC-Number of Iron Tablets given'
         AND date(ov.obs_datetime) BETWEEN '#startDate#' AND '#endDate#' AND ov.value_numeric > 0) AS this_month
  LEFT JOIN
  (SELECT ov1.person_id AS patient
   FROM nonVoidedQuestionObs ov1
   WHERE ov1.question_full_name = 'ANC-Number of Iron Tablets given'
         AND (DATEDIFF('#startDate#', date(ov1.obs_datetime)) / 30 BETWEEN 0 AND 9)
         AND date(ov1.obs_datetime) NOT BETWEEN '#startDate#' AND '#endDate#'
         AND ov1.value_numeric > 0) AS last_9_months
    ON this_month.patient = last_9_months.patient
   INNER JOIN nonVoidedQuestionAnswerObs ancVisit ON ancVisit.person_id = this_month.patient
WHERE last_9_months.patient IS NULL
      AND ancVisit.question_full_name = 'ANC, ANC Visit'
      AND ancVisit.answer_full_name = 'ANC, 1st (any time)'
      AND date(ancVisit.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
UNION ALL

-- Pregnant women receiving - 180 iron tablets
SELECT
  0,COUNT(DISTINCT result.patient),0,0,0
FROM
  (SELECT
    ancVisit.person_id as patient
   FROM   nonVoidedQuestionAnswerObs ancVisit
   WHERE
          ancVisit.question_full_name = 'ANC, Completed 4 ANC visits'
         AND ancVisit.answer_full_name = 'TRUE'
         AND date(ancVisit.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
  ) AS result
UNION ALL

-- Pregnant women receiving - Deworming tablets
SELECT
  0,0,COUNT(DISTINCT (dewormTablet.person_id)),0,0
FROM
  nonVoidedQuestionObs dewormTablet
  INNER JOIN nonVoidedQuestionAnswerObs ancVisit
    ON ancVisit.person_id = dewormTablet.person_id AND ancVisit.obs_id <> dewormTablet.obs_id
WHERE dewormTablet.question_full_name = 'ANC, Albendazole given'
      AND (date(dewormTablet.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
      AND dewormTablet.value_coded = 1
UNION ALL

-- PP women receiving - 45 iron tablets + Vit A
SELECT
  0,0,0,COUNT(DISTINCT (IFA.patient)),0
FROM
  (SELECT
     ov.person_id          AS patient,
     SUM(ov.value_numeric) AS IFA_TABLETS
   FROM nonVoidedQuestionObs ov
   WHERE ov.question_full_name = 'PNC, IFA Tablets Provided'
         AND date(ov.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
   GROUP BY ov.person_id) AS IFA
WHERE IFA.IFA_TABLETS >= 45

UNION ALL

SELECT
  0,0,0,0,COUNT(DISTINCT (ov.person_id))
FROM nonVoidedQuestionObs ov
WHERE ov.question_full_name = 'PNC, Vitamin A Capsules Provided'
      AND ov.value_numeric > 0
      AND (date(ov.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
) final;
