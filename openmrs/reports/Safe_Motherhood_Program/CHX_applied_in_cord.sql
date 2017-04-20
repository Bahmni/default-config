#No need to union with default values as the query itself returns 0
####################################################################
SELECT COUNT(*) AS 'CHX applied in cord'
FROM nonVoidedQuestionAnswerObs
WHERE question_full_name = 'Delivery Note, Chlorhexidine applied on cord'
      AND answer_full_name = 'True'
      AND obs_datetime >= '#startDate#' AND obs_datetime <= '#endDate#';