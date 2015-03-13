select
    delivery_outcome as "Count of Delivery Outcome / Gestation Period",
    SUM(22_27) as "22 - 27",
    SUM(28_36) as "28 - 36",
    SUM(37_41) as "37 - 41",
    SUM(above41) as ">= 42"
from
    (select
        IF(value_concept_full_name like 'Single%%', "Primi", IF(value_concept_full_name like 'Twins%%', "Multi", "Grand Multi")) as delivery_outcome,
        IF(value_concept_full_name like 'Single%%', 1, IF(value_concept_full_name like 'Twins%%', 2, 3)) as sort_order,
        SUM(if(obs_view.value_numeric between 22 and 27, 1, 0)) as 22_27,
        SUM(if(obs_view.value_numeric between 28 and 36, 1, 0)) as 28_36,
        SUM(if(obs_view.value_numeric between 37 and 41, 1, 0)) as 37_41,
        SUM(if(obs_view.value_numeric >= 42, 1, 0)) as above41
    from coded_obs_view
        left outer join obs_view on obs_view.concept_full_name = "Delivery Note, Gestation period" and obs_view.person_id = coded_obs_view.person_id
    where
        coded_obs_view.concept_full_name = "Delivery Note, Outcome of Delivery"
        and coded_obs_view.obs_datetime between "%s" and "%s"
    group by coded_obs_view.value_concept_full_name) simpler_form
group by delivery_outcome
order by sort_order;