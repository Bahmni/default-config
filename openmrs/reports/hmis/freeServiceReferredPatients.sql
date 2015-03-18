select cv2.concept_full_name as 'Free Service type',
sum(if(filtered_obs.person_id is null, 0, 1)) as 'Referred In Patients'
from  
concept_view as free_view 							  
join concept_answer as answer on free_view.concept_id = answer.concept_id 
   and free_view.concept_full_name in ('ER General Notes, Free Health Service Code', 'Out Patient Details, Free Health Service Code')
join concept_view as cv2 on cv2.concept_id = answer.answer_concept and cv2.concept_full_name not in ( 'Not Applicable')
left join ( select free_obs.concept_id, free_obs.person_id, free_obs.value_coded from obs as free_obs  
			join obs as ref_obs on ref_obs.person_id = free_obs.person_id
			and cast(free_obs.obs_datetime as date) between '#startDate#' and '#endDate#'
			 join concept_view as cv on ref_obs.concept_id = cv.concept_id and cv.concept_full_name = 'Hospitals, Referred by') as filtered_obs
on free_view.concept_id = filtered_obs.concept_id and filtered_obs.value_coded = answer.answer_concept 
group by cv2.concept_full_name
order by  cv2.concept_full_name;