select concept_name from concept_view
where
concept_class_name = 'Diagnosis' and concept_id not in
(select answer_concept_id from coded_obs_view where concept_name = 'Coded Diagnosis')
order by concept_name;
