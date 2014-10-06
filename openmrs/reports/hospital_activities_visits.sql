-- Parameters
SET @start_date = '2014-09-01';
SET @end_date = '2014-10-01';

-- Constants
SET @admission_encounter_type = 'ADMISSION';
SET @general_visit_type = 'General';
SET @emergency_visit_type = 'Emergency';
SET @dental_location_name = 'Dental';
SET @anc_location_name = 'ANC';

-- Query
SELECT 
person_gender.gender, 
IFNULL(outpatient_visit.count,0) as outpatient,
IFNULL(emergency_visit.count,0) as emergency,
IFNULL(other_visit.count,0) as others
FROM (SELECT DISTINCT gender FROM person WHERE gender != '') as person_gender
LEFT JOIN (SELECT gender, count(visit_view.visit_id) as count
			FROM visit_view 
			INNER JOIN person
			ON visit_view.patient_id = person.person_id
			WHERE visit_view.visit_type_name = @general_visit_type
			AND visit_view.visit_id NOT IN (SELECT visit_id FROM encounter_view WHERE encounter_type_name = @admission_encounter_type)
			AND visit_view.date_started BETWEEN @start_date AND @end_date
			GROUP BY gender) as outpatient_visit ON outpatient_visit.gender = person_gender.gender
LEFT JOIN (SELECT gender, count(visit_view.visit_id) as count
			FROM visit_view 
			INNER JOIN person
			ON visit_view.patient_id = person.person_id
			WHERE visit_view.visit_type_name = @emergency_visit_type
			AND visit_view.date_started BETWEEN @start_date AND @end_date
			GROUP BY gender
			) as emergency_visit ON emergency_visit.gender = person_gender.gender
LEFT JOIN (SELECT gender, count(distinct encounter_view.visit_id) as count
			FROM encounter_view 
			INNER JOIN person
			ON encounter_view.patient_id = person.person_id
			WHERE encounter_view.visit_type_name = @general_visit_type
			AND encounter_view.location_name IN (@dental_location_name, @anc_location_name)
			AND encounter_view.visit_date_started BETWEEN @start_date AND @end_date
			GROUP BY gender
            ) AS other_visit ON other_visit.gender = person_gender.gender;
