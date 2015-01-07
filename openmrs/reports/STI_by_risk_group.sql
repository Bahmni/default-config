ET @end_date = '2015-02-01';
select concept_id into @positive from concept_view where concept_full_name = 'Positive';
select concept_id into @negative from concept_view where concept_full_name = 'Negative';
select concept_id into @sexworker  from concept_view where concept_full_name = 'Sex Worker';
select concept_id into @MSM_TG from concept_view where concept_full_name = 'MSM & TG';
select concept_id into @sexworker_client from concept_view where concept_full_name = 'Client of Sex Worker';
select concept_id into @PWID from concept_view where concept_full_name = 'People Who Inject Drugs';
select concept_id into @migrant from concept_view where concept_full_name = 'Migrant';
select concept_id into @migrant_spouse from concept_view where concept_full_name = 'Spouse/Partner of Migrant';
select concept_id into @organ_recipient from concept_view where concept_full_name = 'Blood or Organ Recipient';
select concept_id into @pregnant from concept_view where concept_full_name = 'Pregnancy';
select concept_id into @others from concept_view where concept_full_name = 'Others';
select concept_id into @urestral_discharge from concept_view where concept_full_name = 'Urethral Discharge Syndrome';
select concept_id into @scortal_swelling from concept_view where concept_full_name = 'Scortal Swelling Syndrome';
select concept_id into @vaginal_discharge from concept_view where concept_full_name = 'Vaginal Discharge Syndrome';
select concept_id into @lower_abdominal_pain from concept_view where concept_full_name = 'Lower Abdominal Pain Syndrome';
select concept_id into @genital_ulcer_disease from concept_view where concept_full_name = 'Genital Ulcer Disease Syndrome';
select concept_id into @inguinal_bubo from concept_view where concept_full_name = 'Inguinal Bubo Syndrome';
select concept_id into @cervisitis from concept_view where concept_full_name = 'Cervisitis';
select concept_id into @vaginitis from concept_view where concept_full_name = 'Vaginitis';
select concept_id into @herpes_genitalis from concept_view where concept_full_name = 'Herpes Genitalis';


create table if not exists FemaleSexWorkers as select o.person_id from obs_view o inner join person p on o.person_id = p.person_id
	where o.concept_full_name = 'STI, Risk Group' and o.value_coded = @sexworker and  p.gender='F' and o.obs_datetime between @start_date and @end_date group by o.person_id;
create table if not exists Other_MSM_and_TG as select person_id from obs_view where concept_full_name = 'STI, Risk Group' and value_coded = @MSM_TG and obs_datetime between @start_date and @end_date group by person_id;
create table if not exists SexWorkers_Client as select person_id from obs_view where concept_full_name = 'STI, Risk Group' and value_coded = @sexworker_client and obs_datetime between @start_date and @end_date group by person_id;
create table if not exists PWID as select person_id from obs_view where concept_full_name = 'STI, Risk Group' and value_coded = @PWID and obs_datetime between @start_date and @end_date group by person_id;
create table if not exists Migrants as select o.person_id from obs_view o inner join person p on o.person_id = p.person_id
	where o.concept_full_name = 'STI, Risk Group' and o.value_coded = @migrant and p.gender='M' and o.obs_datetime between @start_date and @end_date group by o.person_id;
create table if not exists Spouse_of_Migrants as select person_id from obs_view where concept_full_name = 'STI, Risk Group' and value_coded = @migrant_spouse and obs_datetime between @start_date and @end_date group by person_id;
create table if not exists Pregnant_women as select o.person_id from obs_view o inner join person p on o.person_id = p.person_id
	where o.concept_full_name = 'HCT, Reason for test' and o.value_coded = @pregnant and p.gender='F' and o.obs_datetime between @start_date and @end_date group by o.person_id;
create table if not exists Organ_Recipients as select person_id from obs_view where concept_full_name = 'STI, Risk Group' and value_coded = @organ_recipient and obs_datetime between @start_date and @end_date group by person_id;
create table if not exists Other_Risk_Group as select person_id from obs_view where concept_full_name = 'STI, Risk Group' and value_coded = @others and obs_datetime between @start_date and @end_date group by person_id;
create table if not exists STI_etiology_treated as select person_id from obs_view where concept_full_name = 'STI, Etiological Treatment' and value_coded = 1 and obs_datetime between @start_date and @end_date group by person_id;




select 'Female Sex Workers (FSWs)' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'
        
from (        
select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from FemaleSexWorkers) f on f.person_id = o.person_id where 
		((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
        (o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t1
                        
                        
union all

select 'People Who Inject Drugs (PWIDs)' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from PWID) P on P.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t2
        
        
union all

select 'MSM and TG' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from Other_MSM_and_TG) msm on msm.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t3
        
union all

select 'Clients of FSWs' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from SexWorkers_Client) SC on SC.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t4
        
union all

select 'Male migrants' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from Migrants) M on M.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t5

union all

select 'Spouses of migrants' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from Spouse_of_Migrants) SM on SM.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t6
        

union all

select 'Pregnant women' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from Pregnant_women) PW on PW.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t7

union all

select 'Neonates' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'
        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join person p on p.person_id = o.person_id where 
        datediff(o.obs_datetime,p.birthdate) <= 28 and
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t8


union all

select 'Other' as 'Risk Group / Key Population Group',
		ifnull(sum(if(concept_full_name='STI, Type of Case',1,0)),0) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @urestral_discharge,1,0)),0) as 'Urethral Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @scortal_swelling,1,0)),0) as 'Scortal Swelling',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginal_discharge,1,0)),0) as 'Vaginal Discharge',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @lower_abdominal_pain,1,0)),0) as 'Lower Abdominal Pain',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @genital_ulcer_disease,1,0)),0) as 'Genital Ulcer Disease',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @inguinal_bubo,1,0)),0) as 'Inguinal Bubo',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @others,1,0)),0) as 'Other',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @cervisitis,1,0)),0) as 'Cervisitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @vaginitis,1,0)),0) as 'Vaginitis',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_coded = @herpes_genitalis,1,0)),0) as 'Herpes Genitalis',
        ifnull(sum(if(concept_full_name='STI, GNID +ve',1,0)),0) as 'GNID - GM Stain +ve',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_coded from obs_view o 
		inner join (select person_id from Other_Risk_Group) ORG on ORG.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_coded is not null) or 
        (o.concept_full_name in ('STI, GNID +ve','STI, Syphilis Screening') and o.value_coded = 1) or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded in (@urestral_discharge,@scortal_swelling,@vaginal_discharge,@lower_abdominal_pain,@genital_ulcer_disease,@inguinal_bubo,@cervisitis,@vaginitis,@herpes_genitalis,@others))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_coded) as t9;



drop table FemaleSexWorkers; 
drop table Other_MSM_and_TG; 
drop table SexWorkers_Client; 
drop table PWID;
drop table Migrants; 
drop table Spouse_of_Migrants;
drop table Pregnant_women;
drop table Organ_Recipients;
drop table Other_Risk_Group;
drop table STI_etiology_treated;
