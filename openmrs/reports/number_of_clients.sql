-- Parameters
SET @start_date = '2014-10-05';
SET @end_date = '2014-11-01';

-- Constants
SET @report_group_name = 'Client Service Reports';

-- Query
Explain
SELECT client_visits.age_group AS Age_Group,
	IF(client_visits.age_group_id IS NULL, 0, SUM(IF(client_visits.first_visit_date BETWEEN @start_date AND @end_date,IF(client_visits.patient_gender = 'F', 1, 0),0))) AS New_Clients_Female,
	IF(client_visits.age_group_id IS NULL, 0, SUM(IF(client_visits.first_visit_date BETWEEN @start_date AND @end_date,IF(client_visits.patient_gender = 'M', 1, 0),0))) AS New_Clients_Male,
	IF(client_visits.age_group_id IS NULL, 0, SUM(IF(client_visits.patient_gender = 'F', 1, 0))) as Total_Clients_Female,
    IF(client_visits.age_group_id IS NULL, 0, SUM(IF(client_visits.patient_gender = 'M', 1, 0))) as Total_Clients_Male
FROM    
(SELECT DISTINCT patient.patient_id,
		observed_age_group.name AS age_group,
		observed_age_group.id as age_group_id,
		patient.date_created AS first_visit_date,
        person.gender AS patient_gender,
        observed_age_group.sort_order AS sort_order        
FROM person
INNER JOIN patient ON person.person_id = patient.patient_id
LEFT OUTER JOIN visit_view AS visits ON patient.patient_id = visits.patient_id
INNER JOIN possible_age_group AS observed_age_group ON observed_age_group.report_group_name = @report_group_name
WHERE visits.date_started BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY)) 
AND visits.date_started BETWEEN @start_date AND @end_date )
AS client_visits
GROUP BY client_visits.age_group
ORDER BY client_visits.sort_order;
