select 
    reporting_age_group.name as "Maternal Age / Gestation Period",
    IF(inner_table.22_27 is not null, inner_table.22_27, 0) as "22 - 27",
    IF(inner_table.28_36 is not null, inner_table.28_36, 0) as "28 - 36",
    IF(inner_table.37_41 is not null, inner_table.37_41, 0) as "37 - 41",
    IF(inner_table.above41 is not null, inner_table.above41, 0) as ">=42"
from reporting_age_group
left outer join
    (select age_group.name,
        age_group.id as age_group_id,
        SUM(if(gestation_period_obs.value_numeric between 22 and 27, 1, 0)) as 22_27,
        SUM(if(gestation_period_obs.value_numeric between 28 and 36, 1, 0)) as 28_36,
        SUM(if(gestation_period_obs.value_numeric between 37 and 41, 1, 0)) as 37_41,
        SUM(if(gestation_period_obs.value_numeric >= 42, 1, 0)) as above41
    from obs outcome_of_delivery_obs
        inner join person on outcome_of_delivery_obs.person_id = person.person_id
        inner join obs gestation_period_obs on outcome_of_delivery_obs.person_id = gestation_period_obs.person_id and  gestation_period_obs.concept_id = (select concept_id from concept_name where name = 'Delivery Note, Gestation period' and concept_name_type = 'FULLY_SPECIFIED') and gestation_period_obs.voided = false
        right outer join reporting_age_group age_group on (outcome_of_delivery_obs.obs_datetime BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL age_group.min_years YEAR), INTERVAL age_group.min_days DAY)) AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL age_group.max_years YEAR), INTERVAL age_group.max_days DAY))) and age_group.report_group_name = 'Maternal Age'
    where
        outcome_of_delivery_obs.voided = false
        and CAST(outcome_of_delivery_obs.obs_datetime as DATE) between "#startDate#" and "#endDate#"
        and outcome_of_delivery_obs.concept_id = (select concept_id from concept_name where name = "Delivery Note, Outcome of Delivery" and concept_name_type="FULLY_SPECIFIED")
    group by age_group.name) inner_table on inner_table.age_group_id = reporting_age_group.id
where
    reporting_age_group.report_group_name = 'Maternal Age';
