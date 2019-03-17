SELECT
  rag.name                                   AS ageGroup,
  SUM(IF(person_details.gender = 'F', 1, 0)) AS Female,
  SUM(IF(person_details.gender = 'M', 1, 0)) AS Male,
  SUM(IF(person_details.gender = 'O', 1, 0)) AS Other
FROM reporting_age_group rag
  LEFT JOIN
  (SELECT
     birthdate,
     gender,
     date_stopped
   FROM person AS p
     JOIN visit
       ON p.person_id = visit.patient_id AND cast(visit.date_stopped AS DATE) BETWEEN '#startDate#' AND '#endDate#'
     JOIN visit_type vt ON visit.visit_type_id = vt.visit_type_id AND vt.name = 'Emergency') AS person_details
    ON cast(date_stopped AS DATE) BETWEEN (DATE_ADD(
      DATE_ADD(person_details.birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days
      DAY))
  AND (DATE_ADD(DATE_ADD(person_details.birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
WHERE rag.report_group_name = 'Emergency Service Reports'
GROUP BY ageGroup;