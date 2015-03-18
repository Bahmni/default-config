select count(*) as 'Total Patients Admitted'
from person
join visit on visit.patient_id = person.person_id
and cast(visit.date_started as date) between '#startDate#' and '#endDate#'
join visit_attribute as va on va.visit_id = visit.visit_id and va.value_reference = 'Admitted';
