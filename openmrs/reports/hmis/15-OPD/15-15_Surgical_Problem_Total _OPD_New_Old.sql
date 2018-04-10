SELECT 
       IF(client_visits.patient_id IS NULL, 0, SUM(IF(DATE(client_visits.first_visit_date) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE),IF(client_visits.patient_gender = 'F', 1, 0),0))) AS 'Total New OPD Visits Female',
       IF(client_visits.patient_id IS NULL, 0, SUM(IF(DATE(client_visits.first_visit_date) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE),IF(client_visits.patient_gender = 'M', 1, 0),0))) AS 'Total New OPD Visits Male',
       IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.patient_gender = 'F', 1, 0))) - IF(client_visits.patient_id IS NULL, 0, SUM(IF(DATE(client_visits.first_visit_date) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE),IF(client_visits.patient_gender = 'F', 1, 0),0))) as 'Total Old OPD Visits Female' ,
       IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.patient_gender = 'M', 1, 0))) - IF(client_visits.patient_id IS NULL, 0, SUM(IF(DATE(client_visits.first_visit_date) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE),IF(client_visits.patient_gender = 'M', 1, 0),0))) AS 'Total Old OPD Visits Male'

FROM
  (SELECT DISTINCT patient.patient_id AS patient_id,
                   patient.date_created AS first_visit_date,
                   person.gender AS patient_gender
   FROM visit
     INNER JOIN patient ON visit.patient_id = patient.patient_id AND DATE(visit.date_stopped) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) AND patient.voided = 0 AND visit.voided = 0
     INNER JOIN person ON person.person_id = patient.patient_id AND person.voided = 0
     INNER JOIN visit_attribute va on visit.visit_id = va.visit_id and va.value_reference = 'OPD'
     INNER JOIN visit_attribute_type vat on vat.visit_attribute_type_id = va.attribute_type_id AND vat.name = 'Visit Status'
     RIGHT OUTER JOIN reporting_age_group AS observed_age_group ON
                                                                  DATE(visit.date_stopped) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
                                                                  AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
   WHERE observed_age_group.report_group_name = 'Client Service Reports') AS client_visits
