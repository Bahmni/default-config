select  pi.identifier as Patient_id,
        pn.given_name, pn.family_name Patient_name,
        cv.concept_full_name as Test_Name,
        o.obs_datetime as Test_Date,
        concat(coalesce(o.value_text,''),coalesce(o.value_numeric,''),coalesce(cv2.concept_full_name,'')) as Test_Result
from obs o
        inner join concept_view cv on cv.concept_id = o.concept_id and cv.concept_class_name='LabTest'
          and o.voided =0 and cast(o.obs_datetime as DATE) between '#startDate#' and '#endDate#'
          and concat(coalesce(o.value_text,''),coalesce(o.value_numeric,''),coalesce(o.value_coded,'')) != ''
inner join person p on p.person_id = o.person_id
        inner join person_name pn on pn.person_id = o.person_id
        inner join patient_identifier pi on pi.patient_id = o.person_id and pi.preferred = 1
        left join concept_view cv2 on cv2.concept_id = o.value_coded
group by Patient_Id,Test_Name,Test_Result
order by Test_Date;
