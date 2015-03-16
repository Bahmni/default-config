select
    delivery_outcome as "Count of Delivery Outcome / Gestation Period",
    SUM(22_27) as "22 - 27",
    SUM(28_36) as "28 - 36",
    SUM(37_41) as "37 - 41",
    SUM(above41) as ">= 42"
from
    (select
        IF(outcome_value.name like 'Single%', "Primi", IF(outcome_value.name like 'Twins%', "Multi", "Grand Multi")) as delivery_outcome,
        IF(outcome_value.name like 'Single%', 1, IF(outcome_value.name like 'Twins%', 2, 3)) as sort_order,
        SUM(if(gestation_period_obs.value_numeric between 22 and 27, 1, 0)) as 22_27,
        SUM(if(gestation_period_obs.value_numeric between 28 and 36, 1, 0)) as 28_36,
        SUM(if(gestation_period_obs.value_numeric between 37 and 41, 1, 0)) as 37_41,
        SUM(if(gestation_period_obs.value_numeric >= 42, 1, 0)) as above41
    from obs outcome_of_delivery_obs
        left outer join obs gestation_period_obs on outcome_of_delivery_obs.person_id = gestation_period_obs.person_id and  gestation_period_obs.concept_id = (select concept_id from concept_name where name = 'Delivery Note, Gestation period' and concept_name_type = 'FULLY_SPECIFIED') and gestation_period_obs.voided = false
        inner join concept_name outcome_value on outcome_value.concept_id = outcome_of_delivery_obs.value_coded and outcome_value.concept_name_type = 'FULLY_SPECIFIED'
    where
        outcome_of_delivery_obs.concept_id = (select concept_id from concept_name where name = "Delivery Note, Outcome of Delivery" and concept_name_type="FULLY_SPECIFIED")
        and CAST(outcome_of_delivery_obs.obs_datetime as DATE) between "#startDate#" and "#endDate#"
        and outcome_of_delivery_obs.voided = false
    group by outcome_value.name) simpler_form
group by delivery_outcome
order by sort_order;