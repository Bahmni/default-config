SELECT client_visits.age_group AS Age_Group,
	IF(client_visits.patient_id IS NULL, 0, SUM(IF(DATE(client_visits.first_visit_date) BETWEEN #startDate# AND #endDate#,IF(client_visits.patient_gender = 'F', 1, 0),0))) AS New_Clients_Female,
	IF(client_visits.patient_id IS NULL, 0, SUM(IF(DATE(client_visits.first_visit_date) BETWEEN #startDate# AND #endDate#,IF(client_visits.patient_gender = 'M', 1, 0),0))) AS New_Clients_Male,
	IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.patient_gender = 'F', 1, 0))) as Total_Clients_Female,
    IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.patient_gender = 'M', 1, 0))) as Total_Clients_Male
FROM    
(SELECT DISTINCT patient.patient_id AS patient_id,
		observed_age_group.name AS age_group,
		observed_age_group.id as age_group_id,
		patient.date_created AS first_visit_date,
        person.gender AS patient_gender,
        observed_age_group.sort_order AS sort_order        
FROM visit
INNER JOIN patient ON visit.patient_id = patient.patient_id AND DATE(visit.date_started) BETWEEN #startDate# AND #endDate#
INNER JOIN person ON person.person_id = patient.patient_id 
RIGHT OUTER JOIN reporting_age_group AS observed_age_group ON
DATE(visit.date_started) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
WHERE observed_age_group.report_group_name = 'Client Service Reports') AS client_visits
GROUP BY client_visits.age_group
ORDER BY client_visits.sort_order;	