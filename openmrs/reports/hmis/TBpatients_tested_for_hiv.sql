SELECT patients_tested.gender AS "Gender", patients_tested.patients_count AS "TB Patients Tested for HIV"
FROM
(SELECT person_gender.gender, COUNT(DISTINCT person.person_id) AS patients_count
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Tuberculosis','Multi Drug Resistant Tuberculosis', 'Extremely Drug Resistant Tuberculosis')
    AND coded_obs_view.obs_datetime BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
INNER JOIN orders ON orders.patient_id = person.person_id
    AND orders.order_type_id = 3 
	AND orders.order_action IN ('NEW', 'REVISED')
    AND orders.date_created BETWEEN '#startDate#' AND '#endDate#'
INNER JOIN concept_view ON orders.concept_id = concept_view.concept_id
	AND concept_view.concept_full_name IN ('HIV (Blood)', 'HIV (Serum)')
RIGHT OUTER JOIN (SELECT DISTINCT gender FROM person WHERE gender != '' ) AS person_gender ON person_gender.gender = person.gender  
GROUP BY person_gender.gender) AS patients_tested;
