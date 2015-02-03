SET @start_date = '2014-10-01';
SET @end_date = '2015-02-01';

select concept_id into @OIBP from concept_view where concept_full_name = 'Bacterial Pneumonia';
select concept_id into @OITB from concept_view where concept_full_name = 'Tuberculosis';
select concept_id into @OIC from concept_view where concept_full_name = 'Candidiasis';
select concept_id into @OID from concept_view where concept_full_name = 'Diarrhoea';
select concept_id into @OICM from concept_view where concept_full_name = 'Crypto Meningitis';
select concept_id into @OIPCP from concept_view where concept_full_name = 'Pneumocysitis Pneumonia';
select concept_id into @OICV from concept_view where concept_full_name = 'Cytomegato Virus';
select concept_id into @OIHZ from concept_view where concept_full_name = 'Herpes Zoster';
select concept_id into @OIGH from concept_view where concept_full_name = 'Herpes Genitalis';
select concept_id into @OIT from concept_view where concept_full_name = 'Taxoplasmosis';
select concept_id into @others from concept_view where concept_full_name = 'Others';

drop table OI_treated;

create table OI_treated as select person_id from obs_view where concept_full_name='HIVTC, Opportunistic Infection Treatment' and value_text is not null 
	and obs_datetime between @start_date and @end_date group by person_id;

select 'Diagnosed - Male' as 'Opportunistic Infections',
	ifnull(sum(if(value_coded=@OIBP,1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB,1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC,1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID,1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM,1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP,1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV,1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ,1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH,1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT,1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others,1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null and p.gender = 'M' 
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t1
        
union all 

select 'Diagnosed - Female' as 'Opportunistic Infections',
	ifnull(sum(if(value_coded=@OIBP,1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB,1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC,1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID,1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM,1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP,1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV,1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ,1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH,1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT,1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others,1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null and p.gender = 'F' 
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t2
        
union all 

select 'Diagnosed - TG' as 'Opportunistic Infections',
	ifnull(sum(if(value_coded=@OIBP,1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB,1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC,1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID,1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM,1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP,1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV,1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ,1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH,1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT,1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others,1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null and p.gender not in ('F','M') 
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t3
        
union all

select 'Treated - Male' as 'Opportunistic Infections',
	ifnull(sum(if(value_coded=@OIBP,1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB,1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC,1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID,1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM,1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP,1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV,1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ,1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH,1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT,1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others,1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null and p.gender='M'
        	and o.person_id in (select person_id from OI_treated)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t4
        
union all 

select 'Treated - Female' as 'Opportunistic Infections',
	ifnull(sum(if(value_coded=@OIBP,1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB,1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC,1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID,1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM,1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP,1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV,1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ,1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH,1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT,1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others,1,0)),0) as 'Others' from 
	(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null and p.gender='F'
        	and o.person_id in (select person_id from OI_treated)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t5
        
union all 

select 'Treated - TG' as 'Opportunistic Infections',
	ifnull(sum(if(value_coded=@OIBP,1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB,1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC,1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID,1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM,1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP,1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV,1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ,1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH,1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT,1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others,1,0)),0) as 'Others' from
	(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        	where o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null and p.gender not in ('F','M')
        	and o.person_id in (select person_id from OI_treated)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t6;


