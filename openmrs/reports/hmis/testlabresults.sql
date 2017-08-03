select  
  cv.concept_full_name as Test_Name,
  count(*)
from obs o
  inner join concept_view cv on cv.concept_id = o.concept_id and cv.concept_class_name='LabTest'
                                and o.voided =0 and cast(o.obs_datetime as DATE) between '2016-04-04' and '2016-04-04'
                                and concat(coalesce(o.value_text,''),coalesce(o.value_numeric,''),coalesce(o.value_coded,'')) != ''
  inner join person p on p.person_id = o.person_id
  inner join person_name pn on pn.person_id = o.person_id
  inner join patient_identifier pi on pi.patient_id = o.person_id
  left join concept_view cv2 on cv2.concept_id = o.value_coded
group by Test_Name
order by Test_Name;
