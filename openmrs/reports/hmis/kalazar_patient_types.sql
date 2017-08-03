SELECT base.result,
	SUM(IF(Age < 5 && gender = 'F',1,0)) AS 'Female, < 5 Years',
	SUM(IF(Age < 5 && gender = 'M',1,0)) AS 'Male, < 5 Years',
	SUM(IF(Age >= 5 && gender = 'F',1,0)) AS 'Female, >= 5 Years',
	SUM(IF(Age >= 5 && gender = 'M',1,0)) AS 'Male, >= 5 Years'
      FROM
  (SELECT 'Within' AS RESULT
   UNION SELECT 'Outside' AS RESULT
   UNION SELECT 'Foreigner' AS RESULT) base
LEFT OUTER JOIN
  (SELECT IF(pa.country = 'Nepal', IF(pa.county_district = 'Achham', 'Within', 'Outside'), 'Foreigner') RESULT,
   person.gender,
   TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_stopped) AS Age
   FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
  AND person.voided IS FALSE
INNER JOIN person_address pa ON pa.person_id = person.person_id
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON obs_view.encounter_id = encounter.encounter_id
  AND obs_view.voided IS FALSE
	AND obs_view.concept_full_name = 'Kalaazar, Template'
  WHERE DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
  ) actual ON base.RESULT = actual.RESULT
	GROUP BY RESULT;