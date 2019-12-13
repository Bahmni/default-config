SELECT ' ' AS 'Testing point',
	   patient_visits.age_group AS 'Age Group',
       IF(patient_visits.patient_id IS NULL, 0, SUM(IF(DATE(patient_visits.visit_date) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-11-01' AS DATE) AND DATE(patient_visits.first_visit_date) = DATE(patient_visits.visit_date),IF(patient_visits.patient_gender = 'M', 1, 0),0))) AS 'Sex',
       IF(patient_visits.patient_id IS NULL, 0, SUM(IF(DATE(patient_visits.visit_date) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-11-01' AS DATE) AND DATE(patient_visits.first_visit_date) = DATE(patient_visits.visit_date),IF(patient_visits.patient_gender = 'M', 1, 0),0))) AS 'Total Tested',
       IF(patient_visits.patient_id IS NULL, 0, SUM(IF(DATE(patient_visits.visit_date) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-11-01' AS DATE) AND DATE(patient_visits.first_visit_date) < DATE(patient_visits.visit_date),IF(patient_visits.patient_gender = 'M', 1, 0),0))) AS 'Tested positive',
       IF(patient_visits.patient_id IS NULL, 0, SUM(IF(DATE(patient_visits.visit_date) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-11-01' AS DATE) AND DATE(patient_visits.first_visit_date) < DATE(patient_visits.visit_date),IF(patient_visits.patient_gender = 'M', 1, 0),0))) AS 'Started ART in the HF',
       IF(patient_visits.patient_id IS NULL, 0, SUM(IF(DATE(patient_visits.visit_date) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-11-01' AS DATE) AND DATE(patient_visits.first_visit_date) < DATE(patient_visits.visit_date),IF(patient_visits.patient_gender = 'M', 1, 0),0))) AS 'Referred to other site for ART',
       IF(patient_visits.patient_id IS NULL, 0, SUM(IF(DATE(patient_visits.visit_date) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-11-01' AS DATE) AND DATE(patient_visits.first_visit_date) < DATE(patient_visits.visit_date),IF(patient_visits.patient_gender = 'M', 1, 0),0))) AS 'Died',
       IF(patient_visits.patient_id IS NULL, 0, SUM(IF(DATE(patient_visits.visit_date) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-11-01' AS DATE),IF(patient_visits.patient_gender = 'M', 1, 1),0))) AS 'Total Clients'

FROM
  (SELECT DISTINCT patient.patient_id AS patient_id,
                   observed_age_group.name AS age_group,
                   observed_age_group.id as age_group_id,
                   patient.date_created AS first_visit_date,
                   e.date_created AS visit_date,
                   person.gender AS patient_gender,
                   observed_age_group.id as observed_age_group_id,
                   observed_age_group.sort_order AS sort_order
   FROM encounter e
     INNER JOIN patient ON e.patient_id = patient.patient_id  AND patient.voided = 0 AND e.voided = 0
     INNER JOIN person ON person.person_id = patient.patient_id AND person.voided = 0
     LEFT JOIN encounter vals ON e.patient_id = patient.patient_id
     RIGHT OUTER JOIN reporting_age_group AS observed_age_group ON
                                                                  DATE(e.date_created) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
                                                                  AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
   WHERE observed_age_group.id > 1 ) AS patient_visits
GROUP BY patient_visits.age_group
;
