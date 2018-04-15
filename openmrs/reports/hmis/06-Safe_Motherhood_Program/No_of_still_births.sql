SELECT final.StillBirthType AS 'Still birth type',
  sum(final.count) AS 'No of still births'
FROM
(SELECT
 answer_full_name AS StillBirthType,
 COUNT(*)         AS count
FROM nonVoidedQuestionAnswerObs
WHERE question_full_name = 'Delivery Note, StillBirth Type'
     AND (DATE(obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
GROUP BY answer_full_name
UNION ALL SELECT 'Fresh stillbirth',0
UNION ALL SELECT 'Macerated',0
) final
GROUP BY final.StillBirthType
ORDER BY final.StillBirthType;