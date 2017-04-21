SELECT COUNT(*) AS 'Number of Neo-Natal Deaths'
FROM nonVoidedQuestionObs
WHERE question_full_name LIKE 'PNC, Date of Neonatal Death%'
      AND value_datetime IS NOT NULL
      AND obs_datetime >= '#startDate#' AND obs_datetime <= '#endDate#';