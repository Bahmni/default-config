SELECT
  'Maternal Death'                                                  AS 'Header',
  COALESCE(SUM(IF(answer_full_name LIKE '%AntePartum%', 1, 0)), 0)  AS 'Ante-partum',
  COALESCE(SUM(IF(answer_full_name LIKE '%IntraPartum%', 1, 0)), 0) AS 'Intra-partum',
  COALESCE(SUM(IF(answer_full_name LIKE '%PostPartum%', 1, 0)), 0)  AS 'Post-partum'
FROM nonVoidedQuestionAnswerObs
WHERE question_full_name = 'Death Note, Maternal Death'
      AND obs_datetime >= '#startDate#' AND obs_datetime <= '#endDate#';