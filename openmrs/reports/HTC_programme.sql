SET @start_date = '2015-01-05';
SET @end_date = '2015-01-22';

-- HIV Testing and Counseling (HCT) Programme
-- ------------------------------------------
-- ------------------------------------------


-- ------------------------------------------
-- Age Group <= 14yrs
-- ------------------------------------------
select '<=14yrs - Tested' as Indicator,
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
  inner join person p on o.person_id = p.person_id
  left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
  where ((o.concept_full_name = 'HTC, Result if tested' and cn.name in ('Positive','Negative')) or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text in ('Positive','Negative')))and
      (DATEDIFF(o.obs_datetime,p.birthdate)/365 < 15) and
      (o.obs_datetime between @start_date and @end_date) group by person_id ) as tested14

union all

select '<=14yrs - Positive' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name = 'Positive') or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text = 'Positive'))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 < 15) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as positive14

union all

-- ------------------------------------------
-- Age Group 15-19yrs
-- ------------------------------------------
select '15-19yrs - Tested' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name in ('Positive', 'Negative')) or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text in ('Positive','Negative')))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 between 15 and 20) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as tested19

union all

select '15-19yrs - Positive' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name = 'Positive') or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text = 'Positive'))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 between 15 and 20) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as positive19

union all

-- ------------------------------------------
-- Age Group 20-24yrs
-- ------------------------------------------
select '20-24yrs - Tested' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name in ('Positive', 'Negative')) or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text in ('Positive','Negative')))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 between 20 and 25) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as tested24

union all

select '20-24yrs - Positive' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name = 'Positive') or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text = 'Positive'))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 between 20 and 25) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as positive24

union all

-- ------------------------------------------
-- Age Group 25-49yrs
-- ------------------------------------------
select '25-49yrs - Tested' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name in ('Positive', 'Negative')) or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text in ('Positive','Negative')))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 between 25 and 50) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as tested49

union all

select '25-49yrs - Positive' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name = 'Positive') or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text = 'Positive'))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 between 25 and 50) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as positive49

union all

-- ------------------------------------------
-- Age Group >=50yrs
-- ------------------------------------------
select '>=50yrs - Tested' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name in ('Positive', 'Negative')) or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text in ('Positive','Negative')))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 >= 50) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as tested_above50

union all

select '>=50yrs - Positive' as Indicator,
		ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Sex Worker'),1,0)),0) as 'Sex Worker - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'MSM and Transgenders'),1,0)),0) as 'Other MSM & TG - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Client of Sex Worker'),1,0)),0) as 'Clients of Sex Workers - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'People Who Inject Drugs'),1,0)),0) as 'People Who Inject Drugs - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Migrant'),1,0)),0) as 'Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant'),1,0)),0) as 'Spouse/Partners of Migrants - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Blood or Organ Recipient'),1,0)),0) as 'Blood or Organ Recipients - TG',
       ifnull(sum(if(gender='M' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Male',
       ifnull(sum(if(gender='F' and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - Female',
       ifnull(sum(if(gender not in ('M','F') and person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'HTC, Risk Group' and value_concept_full_name = 'Others'),1,0)),0) as 'Others - TG'
 from (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, p.birthdate, o.obs_datetime from obs_view o
					inner join person p on o.person_id = p.person_id
					left join concept_name cn on cn.concept_id = o.value_coded and cn.concept_name_type = 'FULLY_SPECIFIED'
					where ((o.concept_full_name = 'HTC, Result if tested' and cn.name = 'Positive') or (o.concept_full_name in ('HIV (Blood)','HIV (Serum)') and o.value_text = 'Positive'))and
                    (DATEDIFF(o.obs_datetime,p.birthdate)/365 >= 50) and
					(o.obs_datetime between @start_date and @end_date) group by person_id ) as positive_above50

