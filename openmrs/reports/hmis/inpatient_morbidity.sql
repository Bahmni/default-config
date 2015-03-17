select cv.concept_full_name as Disease,
dcv.icd10_code as 'ICD Code',
SUM(IF(p.gender = 'F' and va.value_reference is not null, 1, 0))       AS Female,
SUM(IF(p.gender = 'M' and va.value_reference is not null, 1, 0))       AS Male,
SUM(IF(p.gender = 'O' and va.value_reference is not null, 1, 0))       AS Other
 from concept_view question
join concept_answer answer on question.concept_id = answer.concept_id and question.concept_full_name = 'Death Note, Cause, Answers'
join concept_view as cv on cv.concept_id = answer.answer_concept
join diagnosis_concept_view as dcv on dcv.concept_id = answer.answer_concept
left join concept_view as death_view on death_view.concept_full_name = 'Death Note, Primary Cause of Death'
left join obs on obs.value_coded = answer.answer_concept and death_view.concept_id = obs.concept_id 
and cast(obs.obs_datetime as date) between '#startDate#' and '#endDate#'
left join person p on p.person_id = obs.person_id
left JOIN encounter e
ON e.encounter_id = obs.encounter_id
left JOIN visit_attribute va on va.visit_id = e.visit_id and va.value_reference in ('Admitted', 'Discharged')
group by cv.concept_full_name;