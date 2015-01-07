SET @start_date = '2014-10-01';
SET @end_date = '2014-12-31';
select 0 into @serial_number;
select concept_id into @positive from concept_view where concept_full_name = 'Positive';
select concept_id into @negative from concept_view where concept_full_name = 'Negative';
select concept_id into @sexworker  from concept_view where concept_full_name = 'Sex Worker';
select concept_id into @MSM_TG from concept_view where concept_full_name = 'MSM & TG';
select concept_id into @sexworker_client from concept_view where concept_full_name = 'Client of Sex Worker';
select concept_id into @PWID from concept_view where concept_full_name = 'People Who Inject Drugs';
select concept_id into @migrant from concept_view where concept_full_name = 'Migrant';
select concept_id into @migrant_spouse from concept_view where concept_full_name = 'Spouse/Partner of Migrant';
select concept_id into @organ_recipient from concept_view where concept_full_name = 'Blood or Organ Recipient';
select concept_id into @others from concept_view where concept_full_name = 'Others';

-- select * from obs_view where obs_datetime > '2014-12-29';
select t1.identifier as 'Client Code',county_district as 'District Code',gender as 'Sex', floor(DATEDIFF(obs_date,birthdate)/365) as 'Age(in yrs)', group_concat(Coded_value separator ',') as 'Risk Group(s)' from

(select pi.identifier, pa.county_district,p.gender,o.concept_full_name,c.concept_full_name as 'Coded_value',o.value_coded, o.value_text,DATE(o.obs_datetime) as 'obs_date',p.birthdate
					from obs_view o
					inner join person p on o.person_id = p.person_id
                    inner join person_address pa on p.person_id = pa.person_id
                    inner join patient_identifier pi on p.person_id = pi.patient_id
                    left outer join concept_view c on o.value_coded = c.concept_id
					where (o.concept_full_name in ('HCT, Risk Group','PMTCT, Risk Group') and o.value_coded in (@sexworker,@MSM_TG,@sexworker_client,@PWID,@migrant,@migrant_spouse,@organ_recipient,@others))
                    and (o.obs_datetime between @start_date and @end_date)) as t1
                    
inner join 

(select pi.identifier
					from obs_view o
                    inner join patient_identifier pi on o.person_id = pi.patient_id
					where ((o.concept_full_name = 'HCT, Result if tested' and o.value_coded in (@positive)) or (o.concept_full_name='HIV Tridot' and o.value_text in ('Positive')))
                    and (o.obs_datetime between @start_date and @end_date) group by pi.identifier) as t2 
                    
on t1.identifier = t2.identifier group by t1.identifier, obs_date
