SET @start_date = '2014-01-01';
SET @end_date = '2014-01-02';

select  (select count(*) from (select person_id from obs_view where concept_full_name = 'HIVTC, HIV care CPT start date' and value_datetime between @start_date and @end_date group by person_id) as CPT) as 'Prophylaxis - Started CPT',
        (select count(*) from (select person_id from obs_view where concept_full_name = 'HIVTC, HIV care IPT start date' and value_datetime between @start_date and @end_date group by person_id) as IPT) as 'Prophylaxis - Started IPT',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result within 2m' and value_concept_full_name = "Positive",1,0)),0) as 'Within 2 months - Positive',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result within 2m' and value_concept_full_name = "Negative",1,0)),0) as 'Within 2 months - Negative',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result 2-9m' and value_concept_full_name = "Positive",1,0)),0) as '2-9 months - Positive',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result 2-9m' and value_concept_full_name = "Negative",1,0)),0) as '2-9 months - Negative',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result 9-18m' and value_concept_full_name = "Positive",1,0)),0) as '9-18 months - Positive',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result 9-18m' and value_concept_full_name = "Negative",1,0)),0) as '9-18 months - Negative',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result after 18m' and value_concept_full_name = "Positive",1,0)),0) as 'Anybody > 18 months - Positive',
        ifnull(sum(if(concept_full_name='HIVTC, HIV diagnosis result after 18m' and value_concept_full_name = "Negative",1,0)),0) as 'Anybody > 18 months - Negative'

from
  (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
    inner join person p on o.person_id = p.person_id
  where o.concept_full_name in ('HIVTC, HIV diagnosis result within 2m','HIVTC, HIV diagnosis result 2-9m','HIVTC, HIV diagnosis result 9-18m','HIVTC, HIV diagnosis result after 18m') and o.value_concept_full_name in ("Positive","Negative") and
        (o.obs_datetime between @start_date and @end_date) group by o.person_id, o.concept_full_name, o.value_coded) as t1;