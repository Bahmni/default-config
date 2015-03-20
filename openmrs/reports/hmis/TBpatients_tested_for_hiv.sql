SELECT
  patients_tested.gender         AS "Gender",
  patients_tested.patients_count AS "TB Patients Tested for HIV"
FROM
  (SELECT
     person.gender,
     COUNT(DISTINCT person.person_id) AS patients_count
   FROM visit
     left JOIN person ON visit.patient_id = person.person_id
                          AND DATE(visit.date_stopped) BETWEEN CAST('2015-03-19' AS DATE) AND CAST('2015-03-19' AS DATE)
                          AND visit.voided IS FALSE AND person.voided IS FALSE
     left JOIN encounter ON visit.visit_id = encounter.visit_id AND encounter.voided IS FALSE
     left JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
                                  AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
                                  AND coded_obs_view.value_concept_full_name IN
                                      ('Tuberculosis', 'Multi Drug Resistant Tuberculosis', 'Extremely Drug Resistant Tuberculosis')
                                  AND DATE(coded_obs_view.obs_datetime) BETWEEN CAST('2015-03-19' AS DATE) AND CAST('2015-03-19' AS DATE)
                                  AND coded_obs_view.voided IS FALSE
     left JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
                                                   AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
                                                   AND certainty_obs.value_concept_full_name = 'Confirmed'
                                                   AND certainty_obs.voided IS FALSE
     left JOIN orders ON orders.patient_id = person.person_id
                          AND orders.order_type_id = 3 AND orders.voided = 0
                          AND orders.order_action IN ('NEW', 'REVISED')
                          AND DATE(orders.date_created) BETWEEN CAST('2015-03-19' AS DATE) AND CAST('2015-03-19' AS DATE)
     JOIN concept_view ON orders.concept_id = concept_view.concept_id
                                AND concept_view.concept_full_name IN ('HIV (Blood)', 'HIV (Serum)')
   GROUP BY person.gender) AS patients_tested;