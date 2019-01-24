SELECT
  'Maternal Death'                                                                   AS 'Header',
  COALESCE(SUM(IF(answer.name LIKE '%AntePartum%', 1, 0)), 0)                        AS 'Ante-partum',
  COALESCE(SUM(IF(answer.name LIKE '%IntraPartum%', 1, 0)), 0)                       AS 'Intra-partum',
  COALESCE(SUM(IF(answer.name LIKE '%PostPartum%', 1, 0)), 0)                        AS 'Post-partum',
   COALESCE(SUM(CASE
				WHEN obs.question_full_name = 'Death Note, Primary Cause of Death'
				AND TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) < 28
				THEN 1
				END),
				0) AS 'Number of Neo-Natal Deaths'

FROM nonVoidedQuestionObs obs
  LEFT JOIN nonVoidedConceptFullName answer ON obs.value_coded = answer.concept_id
      INNER JOIN encounter e ON obs.encounter_id = e.encounter_id
   INNER JOIN person p1 ON obs.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
WHERE question_full_name IN ('Death Note, Maternal Death','Death Note, Primary Cause of Death')
      AND (DATE(obs_datetime) BETWEEN '#startDate#' AND '#endDate#');
	    