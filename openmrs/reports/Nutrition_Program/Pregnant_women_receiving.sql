
SELECT sum(final.receivingFirstTime)                            as 'Patients Receiving Iron Tablets - First Time',
  sum(final.receivingMoreThan180)                               as 'Patients Receiving >= 180 Iron Tablets',
  sum(final.receivingDeworming)                                 as 'Patients Receiving Deworming Tablets',
  sum(final.receivingMoreThan45) as 'Postpartum Patients Receiving >= 45 Iron Tablets',
  sum(final.receivingVitaminA) as 'Postpartum Patients Receiving Vitamin A Capsules'
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
   WHERE ov.question_full_name = 'ANC, Number of IFA Tablets given'
         AND date(ov.obs_datetime) BETWEEN '#startDate#' AND '#endDate#' AND ov.value_numeric > 0) AS this_month
  LEFT JOIN
  (SELECT ov1.person_id AS patient
   FROM nonVoidedQuestionObs ov1
   WHERE ov1.question_full_name = 'ANC, Number of IFA Tablets given'
         AND (DATEDIFF('#startDate#', date(ov1.obs_datetime)) / 30 BETWEEN 0 AND 9)
         AND date(ov1.obs_datetime) NOT BETWEEN '#startDate#' AND '#endDate#'
         AND ov1.value_numeric > 0) AS last_9_months
    ON this_month.patient = last_9_months.patient
WHERE last_9_months.patient IS NULL

UNION ALL

-- Pregnant women receiving - 180 iron tablets
SELECT
  0,COUNT(DISTINCT result.patient),0,0,0
FROM
  (SELECT
     ov.person_id          AS patient,
     SUM(ov.value_numeric) AS TABLET_COUNT
   FROM nonVoidedQuestionObs ov
   WHERE ov.question_full_name = 'ANC, Number of IFA Tablets given'
         AND date(ov.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
   GROUP BY ov.person_id) AS result
WHERE result.TABLET_COUNT >= 180

UNION ALL

-- Pregnant women receiving - Deworming tablets
SELECT
  0,0,COUNT(DISTINCT (ov.person_id)),0,0
FROM nonVoidedQuestionObs ov
WHERE ov.question_full_name = 'ANC, Albendazole given'
      AND (date(ov.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
      AND ov.value_coded = 1

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
