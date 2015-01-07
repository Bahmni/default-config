SET @start_date = '2014-10-01';
SET @end_date = '2015-02-01';

select concept_id into @OIBP from concept_view where concept_full_name = 'OI Bacterial Pneumonia';
select concept_id into @OITB from concept_view where concept_full_name = 'OI TB';
select concept_id into @OIC from concept_view where concept_full_name = 'OI Candidiasis';
select concept_id into @OID from concept_view where concept_full_name = 'OI Diarrhoea';
select concept_id into @OICM from concept_view where concept_full_name = 'OI Crypto Meningitis';
select concept_id into @OIPCP from concept_view where concept_full_name = 'OI PCP';
select concept_id into @OICV from concept_view where concept_full_name = 'OI Cytomegato Virus';
select concept_id into @OIHZ from concept_view where concept_full_name = 'OI Herpes Zoster';
select concept_id into @OIGH from concept_view where concept_full_name = 'OI Genital Herpes';
select concept_id into @OIT from concept_view where concept_full_name = 'OI Taxoplasmosis';
select concept_id into @others from concept_view where concept_full_name = 'Others';


select 'Diagnosed - Male' as 'Opportunistic Infections',
		ifnull(sum(if(value_coded=@OIBP and gender='M',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB and gender='M',1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC and gender='M',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID and gender='M',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM and gender='M',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP and gender='M',1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV and gender='M',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ and gender='M',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH and gender='M',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT and gender='M',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others and gender='M',1,0)),0) as 'Others'
        from
(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        where o.concept_full_name = 'ART, ART opportunistic infections' and o.value_coded is not null and o.obs_datetime between @start_date and @end_date 
        group by o.person_id, o.concept_full_name, o.value_coded) as t1
        
union all 

select 'Diagnosed - Female' as 'Opportunistic Infections',
		ifnull(sum(if(value_coded=@OIBP and gender='F',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB and gender='F',1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC and gender='F',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID and gender='F',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM and gender='F',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP and gender='F',1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV and gender='F',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ and gender='F',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH and gender='F',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT and gender='F',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others and gender='F',1,0)),0) as 'Others'
        from 
(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        where o.concept_full_name = 'ART, ART opportunistic infections' and o.value_coded is not null and o.obs_datetime between @start_date and @end_date 
        group by o.person_id, o.concept_full_name, o.value_coded) as t2
        
union all 

select 'Diagnosed - TG' as 'Opportunistic Infections',
		ifnull(sum(if(value_coded=@OIBP and gender not in ('F','M'),1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB and gender not in ('F','M'),1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC and gender not in ('F','M'),1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID and gender not in ('F','M'),1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM and gender not in ('F','M'),1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP and gender not in ('F','M'),1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV and gender not in ('F','M'),1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ and gender not in ('F','M'),1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH and gender not in ('F','M'),1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT and gender not in ('F','M'),1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others and gender not in ('F','M'),1,0)),0) as 'Others'
        from 
(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        where o.concept_full_name = 'ART, ART opportunistic infections' and o.value_coded is not null and o.obs_datetime between @start_date and @end_date 
        group by o.person_id, o.concept_full_name, o.value_coded) as t3
        
union all

select 'Treated - Male' as 'Opportunistic Infections',
		ifnull(sum(if(value_coded=@OIBP and gender='M',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB and gender='M',1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC and gender='M',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID and gender='M',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM and gender='M',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP and gender='M',1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV and gender='M',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ and gender='M',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH and gender='M',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT and gender='M',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others and gender='M',1,0)),0) as 'Others'
        from
(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        where o.concept_full_name = 'ART, ART opportunistic infections' and o.value_coded is not null and 
        o.person_id in (select person_id from obs_view where concept_full_name = 'ART, ART drugs prescribed for prophylaxis' and value_text is not null and obs_datetime between @start_date and @end_date group by person_id) 
        and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t4
        
union all 

select 'Treated - Female' as 'Opportunistic Infections',
		ifnull(sum(if(value_coded=@OIBP and gender='F',1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB and gender='F',1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC and gender='F',1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID and gender='F',1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM and gender='F',1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP and gender='F',1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV and gender='F',1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ and gender='F',1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH and gender='F',1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT and gender='F',1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others and gender='F',1,0)),0) as 'Others'
        from 
(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        where o.concept_full_name = 'ART, ART opportunistic infections' and o.value_coded is not null and 
        o.person_id in (select person_id from obs_view where concept_full_name = 'ART, ART drugs prescribed for prophylaxis' and value_text is not null and obs_datetime between @start_date and @end_date group by person_id)
        and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t5
        
union all 

select 'Treated - TG' as 'Opportunistic Infections',
		ifnull(sum(if(value_coded=@OIBP and gender not in ('F','M'),1,0)),0) as 'Bacterial Pneumonia',
        ifnull(sum(if(value_coded=@OITB and gender not in ('F','M'),1,0)),0) as 'TB',
        ifnull(sum(if(value_coded=@OIC and gender not in ('F','M'),1,0)),0) as 'Candidiasis',
        ifnull(sum(if(value_coded=@OID and gender not in ('F','M'),1,0)),0) as 'Diarrhoea',
        ifnull(sum(if(value_coded=@OICM and gender not in ('F','M'),1,0)),0) as 'Cryptococcal Meningitis',
        ifnull(sum(if(value_coded=@OIPCP and gender not in ('F','M'),1,0)),0) as 'PCP',
        ifnull(sum(if(value_coded=@OICV and gender not in ('F','M'),1,0)),0) as 'Cytomegato Virus',
        ifnull(sum(if(value_coded=@OIHZ and gender not in ('F','M'),1,0)),0) as 'Herpes Zoster',
        ifnull(sum(if(value_coded=@OIGH and gender not in ('F','M'),1,0)),0) as 'Genital Herpes',
        ifnull(sum(if(value_coded=@OIT and gender not in ('F','M'),1,0)),0) as 'Toxoplasmosis',
        ifnull(sum(if(value_coded=@others and gender not in ('F','M'),1,0)),0) as 'Others'
        from 
(select o.person_id,p.gender,o.concept_full_name,o.value_coded from obs_view o
		inner join person p on o.person_id=p.person_id
        where o.concept_full_name = 'ART, ART opportunistic infections' and o.value_coded is not null and 
        o.person_id in (select person_id from obs_view where concept_full_name = 'ART, ART drugs prescribed for prophylaxis' and value_text is not null and obs_datetime between @start_date and @end_date group by person_id)
        and o.obs_datetime between @start_date and @end_date group by o.person_id, o.concept_full_name, o.value_coded) as t6;
