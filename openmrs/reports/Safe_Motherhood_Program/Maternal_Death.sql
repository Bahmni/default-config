SELECT
  'Maternal Death'                                                                   AS 'Header',
  COALESCE(SUM(IF(answer.name LIKE '%AntePartum%', 1, 0)), 0)                        AS 'Ante-partum',
  COALESCE(SUM(IF(answer.name LIKE '%IntraPartum%', 1, 0)), 0)                       AS 'Intra-partum',
  COALESCE(SUM(IF(answer.name LIKE '%PostPartum%', 1, 0)), 0)                        AS 'Post-partum',
  COALESCE(SUM(IF(obs.question_full_name = 'PNC, Date of Neonatal Death', 1, 0)), 0) AS 'Number of Neo-Natal Deaths'
FROM nonVoidedQuestionObs obs
  LEFT JOIN nonVoidedConceptFullName answer ON obs.value_coded = answer.concept_id
WHERE question_full_name IN ('Death Note, Maternal Death','PNC, Date of Neonatal Death')
      AND (DATE(obs_datetime) BETWEEN '#startDate#' AND '#endDate#');