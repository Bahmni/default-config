SELECT COUNT(*) AS 'CHX applied in cord'
FROM nonVoidedQuestionAnswerObs
WHERE question_full_name = 'Delivery Note, Chlorhexidine applied on cord'
      AND answer_full_name = 'True'
      AND (DATE(obs_datetime) BETWEEN '#startDate#' AND '#endDate#');