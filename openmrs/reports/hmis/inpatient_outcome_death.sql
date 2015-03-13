select
	age_group.name as "Age Group",
	SUM(if(person.death_date <  DATE_ADD(last_admission.admission_datetime, INTERVAL 48 HOUR) and person.gender = 'F', 1, 0)) as "Death < 48 Hours: Female",
	SUM(if(person.death_date <  DATE_ADD(last_admission.admission_datetime, INTERVAL 48 HOUR) and person.gender = 'M', 1, 0)) as "Death < 48 Hours: Male",
	SUM(if(person.death_date >= DATE_ADD(last_admission.admission_datetime, INTERVAL 48 HOUR) and person.gender = 'F', 1, 0)) as "Death >= 48 Hours: Female",
	SUM(if(person.death_date >= DATE_ADD(last_admission.admission_datetime, INTERVAL 48 HOUR) and person.gender = 'M', 1, 0)) as "Death >= 48 Hours: Male"
from
	reporting_age_group age_group
LEFT OUTER JOIN person on (person.death_date BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL age_group.min_years YEAR), INTERVAL age_group.min_days DAY)) AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL age_group.max_years YEAR), INTERVAL age_group.max_days DAY))) and person.death_date is not null
LEFT OUTER JOIN (select max(encounter_datetime) as admission_datetime, patient_id from encounter_view where encounter_type_name='ADMISSION' group by patient_id) last_admission on person.person_id = last_admission.patient_id and last_admission.admission_datetime BETWEEN '#startDate#' and '#endDate#'
where
	age_group.report_group_name = 'Inpatient Discharge Reports'
group by age_group.name
order by age_group.sort_order;