select cv2.concept_full_name as 'Temporary FP Method',
if(sum(unit_obs.value_numeric) is null, 0 ,  sum(unit_obs.value_numeric)) as 'Qty (Piece/Cycle/Dose/Set)'
from concept_view as cv
join concept_answer as ca on ca.concept_id = cv.concept_id and concept_full_name = 'FP, Family Planning Method'
join concept_view  cv2 on ca.answer_concept = cv2.concept_id
left join obs as method_obs on method_obs.value_coded = cv2.concept_id and method_obs.concept_id = cv.concept_id
	and date(cast(method_obs.obs_datetime as date)) between '#startDate#' and '#endDate#'
	and method_obs.voided = 0
left join obs as unit_obs on unit_obs.obs_group_id = method_obs.obs_group_id and unit_obs.voided = 0
left join concept_view as unit_view on unit_obs.concept_id = unit_view.concept_id and unit_view.concept_full_name = 'FP, Units provided'
group by cv2.concept_full_name
order by cv2.concept_full_name;