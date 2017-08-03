SET @start_date = '2014-10-01';
SET @end_date = '2015-02-01';

select concept_id into @positive from concept_view where concept_full_name = 'Positive';
select concept_id into @negative from concept_view where concept_full_name = 'Negative';
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
select concept_id into @Refer_FP from concept_view where concept_full_name = 'Refer for other FP services';

drop table if exists TB_positive;

create table TB_positive as select person_id from obs_view
	where concept_full_name in ('HIVTC, Smear TB assessment at enrollment','HIVTC, Culture TB assessment at enrollment','HIVTC, Chest X-Ray TB assessment at enrollment','HIVTC, Gene Expert TB assessment at enrollment')
	and value_coded = @positive and obs_datetime between @start_date and @end_date group by person_id;

select '< 5 years' as 'OI Status : Age Group',
	ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender = 'F',1,0)),0) as 'Served for OI - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender = 'M',1,0)),0) as 'Served for OI - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender not in ('M','F'),1,0)),0) as 'Served for OI - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender = 'F',1,0)),0) as 'Treated OI - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender = 'M',1,0)),0) as 'Treated OI - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender not in ('M','F'),1,0)),0) as 'Treated OI - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender = 'F',1,0)),0) as 'Assessed for TB - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender = 'M',1,0)),0) as 'Assessed for TB - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender not in ('M','F'),1,0)),0) as 'Assessed for TB - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender = 'F',1,0)),0) as 'IPT initiated - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender = 'M',1,0)),0) as 'IPT initiated - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender not in ('M','F'),1,0)),0) as 'IPT initiated - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender = 'F',1,0)),0) as 'New clients on TB treatment - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender = 'M',1,0)),0) as 'New clients on TB treatment - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender not in ('M','F'),1,0)),0) as 'New clients on TB treatment - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender = 'F',1,0)),0) as 'TB HIV patients recieved CPT - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender = 'M',1,0)),0) as 'TB HIV patients recieved CPT - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender not in ('M','F'),1,0)),0) as 'TB HIV patients recieved CPT - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender = 'F',1,0)),0) as 'Screened for FP need - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender = 'M',1,0)),0) as 'Screened for FP need - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender not in ('M','F'),1,0)),0) as 'Screened for FP need - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender = 'F',1,0)),0) as 'Using any FP method - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender = 'M',1,0)),0) as 'Using any FP method - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender not in ('M','F'),1,0)),0) as 'Using any FP method - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender = 'F',1,0)),0) as 'Referred for other FP - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender = 'M',1,0)),0) as 'Referred for other FP - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender not in ('M','F'),1,0)),0) as 'Referred for other FP - TG' from
	(select o.person_id, p.gender, o.concept_full_name, o.value_coded, o.value_text, o.value_datetime, o.obs_datetime, p.birthdate from obs_view o
		inner join person p on o.person_id = p.person_id
        	where ((o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null) or
        	(o.concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and o.value_text is not null) or 
        	(o.concept_full_name = 'HIVTC, TB Screened' and o.value_coded = 1) or
        	(o.concept_full_name = 'HIVTC, HIV care IPT start date' and o.value_datetime between @start_date and @end_date) or 
        	(o.concept_full_name = 'HIVTC, TB Treatment start date' and o.value_datetime between @start_date and @end_date) or 
        	(o.concept_full_name = 'HIVTC, HIV care CPT start date' and o.value_datetime between @start_date and @end_date and o.person_id in (select person_id from TB_positive)) or 
        	(o.concept_full_name = 'HIVTC, Need FP assessment' and o.value_coded = 1) or 
        	(o.concept_full_name = 'HIVTC, If not FP why' and o.value_coded is not null))
        	and (DATEDIFF(o.obs_datetime,p.birthdate)/365 < 5)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id,o.concept_full_name,o.value_coded) as t1
        

union all


select '5-14 years' as 'OI Status : Age Group',
	ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender = 'F',1,0)),0) as 'Served for OI - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender = 'M',1,0)),0) as 'Served for OI - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender not in ('M','F'),1,0)),0) as 'Served for OI - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender = 'F',1,0)),0) as 'Treated OI - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender = 'M',1,0)),0) as 'Treated OI - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender not in ('M','F'),1,0)),0) as 'Treated OI - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender = 'F',1,0)),0) as 'Assessed for TB - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender = 'M',1,0)),0) as 'Assessed for TB - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender not in ('M','F'),1,0)),0) as 'Assessed for TB - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender = 'F',1,0)),0) as 'IPT initiated - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender = 'M',1,0)),0) as 'IPT initiated - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender not in ('M','F'),1,0)),0) as 'IPT initiated - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender = 'F',1,0)),0) as 'New clients on TB treatment - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender = 'M',1,0)),0) as 'New clients on TB treatment - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender not in ('M','F'),1,0)),0) as 'New clients on TB treatment - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender = 'F',1,0)),0) as 'TB HIV patients recieved CPT - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender = 'M',1,0)),0) as 'TB HIV patients recieved CPT - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender not in ('M','F'),1,0)),0) as 'TB HIV patients recieved CPT - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender = 'F',1,0)),0) as 'Screened for FP need - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender = 'M',1,0)),0) as 'Screened for FP need - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender not in ('M','F'),1,0)),0) as 'Screened for FP need - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender = 'F',1,0)),0) as 'Using any FP method - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender = 'M',1,0)),0) as 'Using any FP method - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender not in ('M','F'),1,0)),0) as 'Using any FP method - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender = 'F',1,0)),0) as 'Referred for other FP - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender = 'M',1,0)),0) as 'Referred for other FP - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender not in ('M','F'),1,0)),0) as 'Referred for other FP - TG' from
	(select o.person_id, p.gender, o.concept_full_name, o.value_coded, o.value_text, o.value_datetime, o.obs_datetime, p.birthdate from obs_view o
		inner join person p on o.person_id = p.person_id
        	where ((o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null) or
        	(o.concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and o.value_text is not null) or 
        	(o.concept_full_name = 'HIVTC, TB Screened' and o.value_coded = 1) or
        	(o.concept_full_name = 'HIVTC, HIV care IPT start date' and o.value_datetime between @start_date and @end_date) or 
        	(o.concept_full_name = 'HIVTC, TB Treatment start date' and o.value_datetime between @start_date and @end_date) or 
        	(o.concept_full_name = 'HIVTC, HIV care CPT start date' and o.value_datetime between @start_date and @end_date and o.person_id in (select person_id from TB_positive)) or 
        	(o.concept_full_name = 'HIVTC, Need FP assessment' and o.value_coded = 1) or 
        	(o.concept_full_name = 'HIVTC, If not FP why' and o.value_coded is not null))
        	and (DATEDIFF(o.obs_datetime,p.birthdate)/365 between 5 and 15)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id,o.concept_full_name,o.value_coded) as t2
        

union all


select '>= 15 years' as 'OI Status : Age Group',
	ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender = 'F',1,0)),0) as 'Served for OI - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender = 'M',1,0)),0) as 'Served for OI - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and gender not in ('M','F'),1,0)),0) as 'Served for OI - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender = 'F',1,0)),0) as 'Treated OI - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender = 'M',1,0)),0) as 'Treated OI - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and gender not in ('M','F'),1,0)),0) as 'Treated OI - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender = 'F',1,0)),0) as 'Assessed for TB - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender = 'M',1,0)),0) as 'Assessed for TB - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Screened' and gender not in ('M','F'),1,0)),0) as 'Assessed for TB - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender = 'F',1,0)),0) as 'IPT initiated - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender = 'M',1,0)),0) as 'IPT initiated - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care IPT start date' and gender not in ('M','F'),1,0)),0) as 'IPT initiated - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender = 'F',1,0)),0) as 'New clients on TB treatment - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender = 'M',1,0)),0) as 'New clients on TB treatment - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, TB Treatment start date' and gender not in ('M','F'),1,0)),0) as 'New clients on TB treatment - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender = 'F',1,0)),0) as 'TB HIV patients recieved CPT - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender = 'M',1,0)),0) as 'TB HIV patients recieved CPT - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, HIV care CPT start date' and gender not in ('M','F'),1,0)),0) as 'TB HIV patients recieved CPT - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender = 'F',1,0)),0) as 'Screened for FP need - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender = 'M',1,0)),0) as 'Screened for FP need - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, Need FP assessment' and gender not in ('M','F'),1,0)),0) as 'Screened for FP need - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender = 'F',1,0)),0) as 'Using any FP method - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender = 'M',1,0)),0) as 'Using any FP method - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and gender not in ('M','F'),1,0)),0) as 'Using any FP method - TG',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender = 'F',1,0)),0) as 'Referred for other FP - Female',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender = 'M',1,0)),0) as 'Referred for other FP - Male',
        ifnull(sum(if(concept_full_name = 'HIVTC, If not FP why' and value_coded = @Refer_FP and gender not in ('M','F'),1,0)),0) as 'Referred for other FP - TG' from
	(select o.person_id, p.gender, o.concept_full_name, o.value_coded, o.value_text, o.value_datetime, o.obs_datetime, p.birthdate from obs_view o
		inner join person p on o.person_id = p.person_id
        	where ((o.concept_full_name = 'HIVTC, Opportunistic Infection Diagnosis' and o.value_coded is not null) or
        	(o.concept_full_name = 'HIVTC, Opportunistic Infection Treatment' and o.value_text is not null) or 
        	(o.concept_full_name = 'HIVTC, TB Screened' and o.value_coded = 1) or
        	(o.concept_full_name = 'HIVTC, HIV care IPT start date' and o.value_datetime between @start_date and @end_date) or 
        	(o.concept_full_name = 'HIVTC, TB Treatment start date' and o.value_datetime between @start_date and @end_date) or 
        	(o.concept_full_name = 'HIVTC, HIV care CPT start date' and o.value_datetime between @start_date and @end_date and o.person_id in (select person_id from TB_positive)) or 
        	(o.concept_full_name = 'HIVTC, Need FP assessment' and o.value_coded = 1) or 
        	(o.concept_full_name = 'HIVTC, If not FP why' and o.value_coded is not null))
        	and (DATEDIFF(o.obs_datetime,p.birthdate)/365 >= 15)
        	and o.obs_datetime between @start_date and @end_date group by o.person_id,o.concept_full_name,o.value_coded) as t3;
        

