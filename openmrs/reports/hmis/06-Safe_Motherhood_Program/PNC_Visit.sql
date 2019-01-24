SELECT
  final.pncVisit   AS 'PNC Visit',
  sum(final.count) AS 'Number'
FROM
  (SELECT
     IF(answer_full_name = 'PNC, First Visit', 'Within 24 hour', '3 PNC visit as per protocol') AS pncVisit,
     COUNT(*)                                                                                   AS count
   FROM nonVoidedQuestionAnswerObs
   WHERE question_full_name = 'PNC, Visit Number'
         AND answer_full_name IN ('PNC, First Visit', 'PNC, Third Visit')
         AND (DATE(obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
   GROUP BY answer_full_name
   UNION ALL SELECT 'Within 24 hour', 0
   UNION ALL SELECT '3 PNC visit as per protocol', 0
  ) final
GROUP BY final.pncVisit
ORDER BY final.pncVisit DESC;
