SELECT
  base.result,
  SUM(IF(gender = 'F', 1, 0)) AS 'Female - No. of deaths',
  SUM(IF(gender = 'M', 1, 0)) AS 'Male - No. of deaths'
FROM
  (SELECT
     'Within' AS RESULT
   UNION SELECT
           'Outside' AS RESULT
   UNION SELECT
           'Foreigner' AS RESULT) base
  LEFT OUTER JOIN
  (SELECT
     IF(pa.country = 'Nepal', IF(pa.county_district = 'Achham', 'Within', 'Outside'), 'Foreigner') RESULT,
     person.gender
   FROM visit
     INNER JOIN person ON visit.patient_id = person.person_id
                          AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
     INNER JOIN person_address pa ON pa.person_id = person.person_id
     INNER JOIN encounter ON visit.visit_id = encounter.visit_id
     INNER JOIN coded_obs_view ON encounter.encounter_id = coded_obs_view.encounter_id
                                  AND coded_obs_view.concept_full_name IN ('Death Note, Primary Cause of Death')
                                  AND DATE(coded_obs_view.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
                                  AND coded_obs_view.value_concept_full_name = 'Kalaazar'
                                  AND coded_obs_view.voided IS FALSE
  ) actual ON base.RESULT = actual.RESULT
GROUP BY RESULT
