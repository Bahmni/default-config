SET @start_date = '2013-01-01';
SET @end_date = '2014-01-20';

drop table if exists FemaleSexWorkers; 
drop table if exists Other_MSM_and_TG; 
drop table if exists SexWorkers_Client; 
drop table if exists PWID;
drop table if exists Migrants; 
drop table if exists Spouse_of_Migrants;
drop table if exists Pregnant_women;
drop table if exists Other_Risk_Group;
drop table if exists STI_etiology_treated;
drop table if exists STI_cases;


create table FemaleSexWorkers as select o.person_id from valid_coded_obs_view o inner join person p on o.person_id = p.person_id
where o.concept_full_name = 'STI, Risk Group' and o.value_concept_full_name = 'Sex Worker' and  p.gender = 'F' and o.obs_datetime between @start_date and @end_date group by o.person_id;
create table Other_MSM_and_TG as select person_id from valid_coded_obs_view where concept_full_name = 'STI, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id;
create table SexWorkers_Client as select person_id from valid_coded_obs_view where concept_full_name = 'STI, Risk Group' and value_concept_full_name = 'Client of Sex Worker' and obs_datetime between @start_date and @end_date group by person_id;
create table PWID as select person_id from valid_coded_obs_view where concept_full_name = 'STI, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id;
create table Migrants as select o.person_id from valid_coded_obs_view o inner join person p on o.person_id = p.person_id
where o.concept_full_name = 'STI, Risk Group' and o.value_concept_full_name = 'Migrant' and p.gender='M' and o.obs_datetime between @start_date and @end_date group by o.person_id;
create table Spouse_of_Migrants as select person_id from valid_coded_obs_view where concept_full_name = 'STI, Risk Group' and value_concept_full_name = 'Spouse/Partner of Migrant' and obs_datetime between @start_date and @end_date group by person_id;
create table Pregnant_women as select o.person_id from valid_coded_obs_view o inner join person p on o.person_id = p.person_id
where o.concept_full_name = 'HTC, Reason for test' and o.value_concept_full_name = 'Pregnancy' and p.gender='F' and o.obs_datetime between @start_date and @end_date group by o.person_id;
create table Other_Risk_Group as select person_id from valid_coded_obs_view where concept_full_name = 'STI, Risk Group' and value_concept_full_name = 'Others' and obs_datetime between @start_date and @end_date group by person_id;
create table STI_etiology_treated as select person_id from valid_coded_obs_view where concept_full_name = 'STI, Etiological Treatment' and value_concept_full_name = 'True' and obs_datetime between @start_date and @end_date group by person_id;
create table STI_cases as select person_id,obs_datetime from valid_coded_obs_view where concept_full_name like 'STI, %' and obs_datetime between @start_date and @end_date group by person_id;


select 'Female Sex Workers (FSWs)' as 'Risk Group / Key Population Group',
       (select count(*) as 'Total' from (select s.person_id from STI_cases s inner join FemaleSexWorkers F on F.person_id = s.person_id) as Total_FSW) as 'Total Cases Assessed',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

from (
       select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o
         inner join (select person_id from FemaleSexWorkers) f on f.person_id = o.person_id where
         ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or
          (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
          (o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and
         (obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t1
                                                
union all

select 'People Who Inject Drugs (PWIDs)' as 'Risk Group / Key Population Group',
	(select count(*) as 'Total' from (select s.person_id from STI_cases s inner join PWID P on P.person_id = s.person_id) as Total_PWID) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
		inner join (select person_id from PWID) P on P.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
		(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
		(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t2
        
        
union all

select 'MSM and TG' as 'Risk Group / Key Population Group',
        (select count(*) as 'Total' from (select s.person_id from STI_cases s inner join Other_MSM_and_TG MSM on MSM.person_id = s.person_id) as Total_MSM) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
	inner join (select person_id from Other_MSM_and_TG) msm on msm.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
	(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
	(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t3
        
union all

select 'Clients of FSWs' as 'Risk Group / Key Population Group',
        (select count(*) as 'Total' from (select s.person_id from STI_cases s inner join SexWorkers_Client SC on SC.person_id = s.person_id) as Total_SWC) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
	inner join (select person_id from SexWorkers_Client) SC on SC.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
	(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
	(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t4

        
union all 


select 'Male migrants' as 'Risk Group / Key Population Group',
        (select count(*) as 'Total' from (select s.person_id from STI_cases s inner join Migrants M on M.person_id = s.person_id) as Total_Migrants) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
	inner join (select person_id from Migrants) M on M.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
	(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
	(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t5

union all

select 'Spouses of migrants' as 'Risk Group / Key Population Group',
		(select count(*) as 'Total' from (select s.person_id from STI_cases s inner join Spouse_of_Migrants SM on SM.person_id = s.person_id) as Total_SM) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
	inner join (select person_id from Spouse_of_Migrants) SM on SM.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
	(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
	(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t6
        

union all

select 'Pregnant women' as 'Risk Group / Key Population Group',
        (select count(*) as 'Total' from (select s.person_id from STI_cases s inner join Pregnant_women PW on PW.person_id = s.person_id) as Total_Pregnant) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
	inner join (select person_id from Pregnant_women) PW on PW.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
	(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
	(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t7

union all



select 'Neonates' as 'Risk Group / Key Population Group',
        (select count(*) as 'Total' from (select s.person_id from STI_cases s inner join person p on p.person_id = s.person_id and datediff(s.obs_datetime,p.birthdate) <=28) as Total_Neonates) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'
        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
	inner join person p on p.person_id = o.person_id where 
        datediff(o.obs_datetime,p.birthdate) <= 28 and
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
	(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
	(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t8

union all

select 'Other' as 'Risk Group / Key Population Group',
        (select count(*) as 'Total' from (select s.person_id from STI_cases s inner join Other_Risk_Group O on O.person_id = s.person_id) as Total_ORG) as 'Total Cases Assessed',
        ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Urethral Discharge Syndrome',1,0)),0) as 'Urethral Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Scortal Swelling Syndrome',1,0)),0) as 'Scortal Swelling',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginal Discharge Syndrome',1,0)),0) as 'Vaginal Discharge',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Lower Abdominal Pain Syndrome',1,0)),0) as 'Lower Abdominal Pain',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Genital Ulcer Disease Syndrome',1,0)),0) as 'Genital Ulcer Disease',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Inguinal Bubo Syndrome',1,0)),0) as 'Inguinal Bubo',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Others',1,0)),0) as 'Other',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Cervisitis',1,0)),0) as 'Cervisitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Vaginitis',1,0)),0) as 'Vaginitis',
       ifnull(sum(if(concept_full_name='STI, STI Diagnosis Syndrome' and value_concept_full_name = 'Herpes Genitalis',1,0)),0) as 'Herpes Genitalis',
       ifnull(sum(if(concept_full_name='STI, Gram-Negative Intracellular Diplococci +ve',1,0)),0) as 'GNID - GM Stain +ve',
       ifnull(sum(if(concept_full_name='STI, Syphilis Screening',1,0)),0) as 'Syphilis - Diagnosed',
        ifnull(sum(if(concept_full_name='STI, Syphilis Screening' and person_id in (select person_id from STI_etiology_treated),1,0)),0) as 'Syphilis - Treated'

        
from (select o.person_id,o.concept_full_name,o.value_concept_full_name from valid_coded_obs_view o 
	inner join (select person_id from Other_Risk_Group) ORG on ORG.person_id = o.person_id where 
        ((o.concept_full_name = 'STI, Type of Case' and o.value_concept_full_name is not null) or 
        (o.concept_full_name in ('STI, Gram-Negative Intracellular Diplococci +ve','STI, Syphilis Screening') and o.value_concept_full_name = 'True') or
	(o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_concept_full_name in ('Urethral Discharge Syndrome','Scortal Swelling Syndrome','Vaginal Discharge Syndrome','Lower Abdominal Pain Syndrome','Genital Ulcer Disease Syndrome','Inguinal Bubo Syndrome','Cervisitis','Vaginitis','Herpes Genitalis','Others'))) and 
	(obs_datetime between @start_date and @end_date) group by o.person_id,o.concept_full_name,o.value_concept_full_name) as t9;



