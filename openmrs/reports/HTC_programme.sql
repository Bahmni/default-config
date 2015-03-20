SET @start_date = '2015-03-15';
SET @end_date = '2015-03-20';

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
      (o.obs_datetime between @start_date and @end_date) group by person_id ) as tested14;
      
SELECT entries.name AS 'HTC Programme - Tested',
		SUM(IF(entries.risk_group = 'Sex Worker' && entries.gender = 'M',1,0)) AS 'Sex Workers - Male',
		SUM(IF(entries.risk_group = 'Sex Worker' && entries.gender = 'F',1,0)) AS 'Sex Workers - Female',		
        SUM(IF(entries.risk_group = 'Sex Worker' && entries.gender = 'O',1,0)) AS 'Sex Workers - TG',		
        SUM(IF(entries.risk_group = 'People Who Inject Drugs' && entries.gender = 'M',1,0)) AS 'People Who Inject Drugs - Male',
		SUM(IF(entries.risk_group = 'People Who Inject Drugs' && entries.gender = 'F',1,0)) AS 'People Who Inject Drugs - Female',		
        SUM(IF(entries.risk_group = 'People Who Inject Drugs' && entries.gender = 'O',1,0)) AS 'People Who Inject Drugs - TG',		
        SUM(IF(entries.risk_group = 'MSM and Transgenders' && entries.gender = 'M',1,0)) AS 'MSM and Transgenders - Male',
		SUM(IF(entries.risk_group = 'MSM and Transgenders' && entries.gender = 'F',1,0)) AS 'MSM and Transgenders - Female',
		SUM(IF(entries.risk_group = 'MSM and Transgenders' && entries.gender = 'O',1,0)) AS 'MSM and Transgenders - TG',
		SUM(IF(entries.risk_group = 'Blood or Organ Recipient' && entries.gender = 'M',1,0)) AS 'Blood or Organ Recipient - Male',
		SUM(IF(entries.risk_group = 'Blood or Organ Recipient' && entries.gender = 'F',1,0)) AS 'Blood or Organ Recipient - Female',		
        SUM(IF(entries.risk_group = 'Blood or Organ Recipient' && entries.gender = 'O',1,0)) AS 'Blood or Organ Recipient - TG',		
        SUM(IF(entries.risk_group = 'Client of Sex Worker' && entries.gender = 'M',1,0)) AS 'Client of Sex Worker - Male',
		SUM(IF(entries.risk_group = 'Client of Sex Worker' && entries.gender = 'F',1,0)) AS 'Client of Sex Worker - Female',
        SUM(IF(entries.risk_group = 'Client of Sex Worker' && entries.gender = 'O',1,0)) AS 'Client of Sex Worker - TG',
        SUM(IF(entries.risk_group = 'Migrant' && entries.gender = 'M',1,0)) AS 'Migrant- Male',
		SUM(IF(entries.risk_group = 'Migrant' && entries.gender = 'F',1,0)) AS 'Migrant- Female',
        SUM(IF(entries.risk_group = 'Migrant' && entries.gender = 'O',1,0)) AS 'Migrant- TG',
        SUM(IF(entries.risk_group = 'Others' && entries.gender = 'M',1,0)) AS 'Others - Male',
		SUM(IF(entries.risk_group = 'Others' && entries.gender = 'F',1,0)) AS 'Others - Female',		        
        SUM(IF(entries.risk_group = 'Others' && entries.gender = 'O',1,0)) AS 'Others - TG'		        
FROM      
(SELECT 	
	 person.person_id,
	 person.gender,
     person.birthdate,
     value_concepts.concept_full_name AS risk_group,
     value_tested.concept_full_name AS tested,
     test_order.order_id,
     reporting_age_group.name,
     reporting_age_group.sort_order
FROM visit 
JOIN encounter ON visit.visit_id = encounter.visit_id
	AND DATE(visit.date_stopped) BETWEEN @start_date AND @end_date
INNER JOIN obs AS risk_group ON risk_group.encounter_id = encounter.encounter_id
INNER JOIN concept_view ON risk_group.concept_id = concept_view.concept_id
	AND concept_view.concept_full_name = 'HTC, Risk Group'
INNER JOIN concept_view AS value_concepts ON risk_group.value_coded = value_concepts.concept_id
INNER JOIN person ON risk_group.person_id = person.person_id
LEFT OUTER JOIN obs AS previously_tested ON previously_tested.obs_group_id = risk_group.obs_group_id 
INNER JOIN concept_view previously_tested_concept ON previously_tested.concept_id = previously_tested_concept.concept_id
  	AND previously_tested_concept.concept_full_name = 'HTC, Tested before'
INNER JOIN concept_view AS value_tested ON value_tested.concept_id = previously_tested.value_coded
LEFT OUTER JOIN orders AS test_order ON test_order.patient_id = person.person_id
 	AND test_order.order_type_id = 3
LEFT OUTER JOIN concept_view test_concept ON test_order.concept_id = test_concept.concept_id
   	AND test_concept.concept_full_name IN ('HIV (Blood)', 'HIV (Serum)')
RIGHT OUTER JOIN reporting_age_group ON visit.date_stopped BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
WHERE reporting_age_group.report_group_name = 'HTC Programme'
) AS entries
GROUP BY entries.name
ORDER BY entries.sort_order;
