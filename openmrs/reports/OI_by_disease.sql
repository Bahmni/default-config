SET @start_date = '2013-01-01';
SET @end_date = '2014-02-01';

select 'Diagnosed - Male' as 'Opportunistic Infections',
	ifnull(sum(if(value_concept_full_name='Bacterial Pneumonia Opportunistic Infection',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_concept_full_name='Tuberculosis Opportunistic Infection',1,0)),0) as 'TB',
        ifnull(sum(if(value_concept_full_name='Candidiasis Opportunistic Infection',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_concept_full_name='Diarrhoea Opportunistic Infection',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_concept_full_name='Crypto Meningitis Opportunistic Infection',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_concept_full_name='Pneumocysitis Pneumonia Opportunistic Infection',1,0)),0) as 'PCP',
        ifnull(sum(if(value_concept_full_name='Cytomegato Virus Opportunistic Infection',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_concept_full_name='Herpes Zoster Opportunistic Infection',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_concept_full_name='Herpes Genitalis Opportunistic Infection',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_concept_full_name='Toxicity side effects',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_concept_full_name='Others',1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_concept_full_name is not null and p.gender = 'M'
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_concept_full_name) as t1
        
union all 

select 'Diagnosed - Female' as 'Opportunistic Infections',
	ifnull(sum(if(value_concept_full_name='Bacterial Pneumonia Opportunistic Infection',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_concept_full_name='Tuberculosis Opportunistic Infection',1,0)),0) as 'TB',
        ifnull(sum(if(value_concept_full_name='Candidiasis Opportunistic Infection',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_concept_full_name='Diarrhoea Opportunistic Infection',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_concept_full_name='Crypto Meningitis Opportunistic Infection',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_concept_full_name='Pneumocysitis Pneumonia Opportunistic Infection',1,0)),0) as 'PCP',
        ifnull(sum(if(value_concept_full_name='Cytomegato Virus Opportunistic Infection',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_concept_full_name='Herpes Zoster Opportunistic Infection',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_concept_full_name='Herpes Genitalis Opportunistic Infection',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_concept_full_name='Toxicity side effects',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_concept_full_name='Others',1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_concept_full_name is not null and p.gender = 'F' 
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_concept_full_name) as t2
        
union all 

select 'Diagnosed - TG' as 'Opportunistic Infections',
	ifnull(sum(if(value_concept_full_name='Bacterial Pneumonia Opportunistic Infection',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_concept_full_name='Tuberculosis Opportunistic Infection',1,0)),0) as 'TB',
        ifnull(sum(if(value_concept_full_name='Candidiasis Opportunistic Infection',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_concept_full_name='Diarrhoea Opportunistic Infection',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_concept_full_name='Crypto Meningitis Opportunistic Infection',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_concept_full_name='Pneumocysitis Pneumonia Opportunistic Infection',1,0)),0) as 'PCP',
        ifnull(sum(if(value_concept_full_name='Cytomegato Virus Opportunistic Infection',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_concept_full_name='Herpes Zoster Opportunistic Infection',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_concept_full_name='Herpes Genitalis Opportunistic Infection',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_concept_full_name='Toxicity side effects',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_concept_full_name='Others',1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_concept_full_name is not null and p.gender not in ('F','M') 
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_concept_full_name) as t3
        
union all

select 'Treated - Male' as 'Opportunistic Infections',
	ifnull(sum(if(value_concept_full_name='Bacterial Pneumonia Opportunistic Infection',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_concept_full_name='Tuberculosis Opportunistic Infection',1,0)),0) as 'TB',
        ifnull(sum(if(value_concept_full_name='Candidiasis Opportunistic Infection',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_concept_full_name='Diarrhoea Opportunistic Infection',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_concept_full_name='Crypto Meningitis Opportunistic Infection',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_concept_full_name='Pneumocysitis Pneumonia Opportunistic Infection',1,0)),0) as 'PCP',
        ifnull(sum(if(value_concept_full_name='Cytomegato Virus Opportunistic Infection',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_concept_full_name='Herpes Zoster Opportunistic Infection',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_concept_full_name='Herpes Genitalis Opportunistic Infection',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_concept_full_name='Toxicity side effects',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_concept_full_name='Others',1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_concept_full_name is not null and p.gender='M'
        	and o.person_id in (select person_id from obs_view where concept_full_name='HIVTC, Opportunistic Infection Treatment' and value_text is not null
                              and obs_datetime between @start_date and @end_date group by person_id)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_concept_full_name) as t4
        
union all 

select 'Treated - Female' as 'Opportunistic Infections',
	ifnull(sum(if(value_concept_full_name='Bacterial Pneumonia Opportunistic Infection',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_concept_full_name='Tuberculosis Opportunistic Infection',1,0)),0) as 'TB',
        ifnull(sum(if(value_concept_full_name='Candidiasis Opportunistic Infection',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_concept_full_name='Diarrhoea Opportunistic Infection',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_concept_full_name='Crypto Meningitis Opportunistic Infection',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_concept_full_name='Pneumocysitis Pneumonia Opportunistic Infection',1,0)),0) as 'PCP',
        ifnull(sum(if(value_concept_full_name='Cytomegato Virus Opportunistic Infection',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_concept_full_name='Herpes Zoster Opportunistic Infection',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_concept_full_name='Herpes Genitalis Opportunistic Infection',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_concept_full_name='Toxicity side effects',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_concept_full_name='Others',1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_concept_full_name is not null and p.gender='F'
        	and o.person_id in (select person_id from obs_view where concept_full_name='HIVTC, Opportunistic Infection Treatment' and value_text is not null
                              and obs_datetime between @start_date and @end_date group by person_id)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_concept_full_name) as t5
        
union all 

select 'Treated - TG' as 'Opportunistic Infections',
	ifnull(sum(if(value_concept_full_name='Bacterial Pneumonia Opportunistic Infection',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_concept_full_name='Tuberculosis Opportunistic Infection',1,0)),0) as 'TB',
        ifnull(sum(if(value_concept_full_name='Candidiasis Opportunistic Infection',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_concept_full_name='Diarrhoea Opportunistic Infection',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_concept_full_name='Crypto Meningitis Opportunistic Infection',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_concept_full_name='Pneumocysitis Pneumonia Opportunistic Infection',1,0)),0) as 'PCP',
        ifnull(sum(if(value_concept_full_name='Cytomegato Virus Opportunistic Infection',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_concept_full_name='Herpes Zoster Opportunistic Infection',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_concept_full_name='Herpes Genitalis Opportunistic Infection',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_concept_full_name='Toxicity side effects',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_concept_full_name='Others',1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_concept_full_name is not null and p.gender not in ('F','M')
        	and o.person_id in (select person_id from obs_view where concept_full_name='HIVTC, Opportunistic Infection Treatment' and value_text is not null
                              and obs_datetime between @start_date and @end_date group by person_id)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_concept_full_name) as t6;


