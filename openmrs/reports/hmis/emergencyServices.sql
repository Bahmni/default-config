select
rag.name as ageGroup,
SUM(IF(person_details.gender = 'F', 1, 0))       AS Female,
SUM(IF(person_details.gender = 'M', 1, 0))       AS Male,
SUM(IF(person_details.gender = 'O', 1, 0))       AS Other
from reporting_age_group rag
left join
( select birthdate, gender, date_started from person as p
 join visit on p.person_id = visit.patient_id and cast(visit.date_started as date) between '#startDate#' and '#endDate#'
 join visit_type vt on visit.visit_type_id = vt.visit_type_id and vt.name = 'Emergency') as person_details
 on cast(date_started as date) BETWEEN (DATE_ADD(
           DATE_ADD(person_details.birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days
           DAY))
       AND (DATE_ADD(DATE_ADD(person_details.birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
where rag.report_group_name = 'Emergency Service Reports'
group by ageGroup;