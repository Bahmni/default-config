SET @start_date = '2014-10-01';
SET @end_date = '2015-02-01';

select 	'STI - Screened/Counseled' as 'STI Cases by Sex & Age Group',
		ifnull(sum(if(Age < 15 and gender='F',1,0)),0) as '<=14yrs - Female',
        ifnull(sum(if(Age < 15 and gender='M',1,0)),0) as '<=14yrs - Male',
        ifnull(sum(if(Age < 15 and gender not in ('F','M'),1,0)),0) as '<=14yrs - TG',
        ifnull(sum(if(Age between 15 and 20 and gender='F',1,0)),0) as '15-19yrs - Female',
        ifnull(sum(if(Age between 15 and 20 and gender='M',1,0)),0) as '15-19yrs - Male',
        ifnull(sum(if(Age between 15 and 20 and gender not in ('F','M'),1,0)),0) as '15-19yrs - TG',
        ifnull(sum(if(Age between 20 and 25 and gender='F',1,0)),0) as '20-24yrs - Female',
        ifnull(sum(if(Age between 20 and 25 and gender='M',1,0)),0) as '20-24yrs - Male',
        ifnull(sum(if(Age between 20 and 25 and gender not in ('F','M'),1,0)),0) as '20-24yrs - TG',
        ifnull(sum(if(Age between 25 and 50 and gender='F',1,0)),0) as '25-49yrs - Female',
        ifnull(sum(if(Age between 25 and 50 and gender='M',1,0)),0) as '25-49yrs - Male',
        ifnull(sum(if(Age between 25 and 50 and gender not in ('F','M'),1,0)),0) as '25-49yrs - TG',
        ifnull(sum(if(Age >= 50 and gender='F',1,0)),0) as '>=50yrs - Female',
        ifnull(sum(if(Age >= 50 and gender='M',1,0)),0) as '>=50yrs - Male',
        ifnull(sum(if(Age >= 50 and gender not in ('F','M'),1,0)),0) as '>=50yrs - TG'

from (select o.person_id, p.gender, p.birthdate,datediff(o.obs_datetime,p.birthdate)/365 as 'Age' from obs_view o 
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name = 'STI, STI Counseling' and o.value_coded = 1 and 
		o.obs_datetime between @start_date and @end_date group by o.person_id) as t1

union all 

select 	'STI - Diagnosed' as 'STI Cases by Sex & Age Group',
		ifnull(sum(if(Age < 15 and gender='F',1,0)),0) as '<=14yrs - Female',
        ifnull(sum(if(Age < 15 and gender='M',1,0)),0) as '<=14yrs - Male',
        ifnull(sum(if(Age < 15 and gender not in ('F','M'),1,0)),0) as '<=14yrs - TG',
        ifnull(sum(if(Age between 15 and 20 and gender='F',1,0)),0) as '15-19yrs - Female',
        ifnull(sum(if(Age between 15 and 20 and gender='M',1,0)),0) as '15-19yrs - Male',
        ifnull(sum(if(Age between 15 and 20 and gender not in ('F','M'),1,0)),0) as '15-19yrs - TG',
        ifnull(sum(if(Age between 20 and 25 and gender='F',1,0)),0) as '20-24yrs - Female',
        ifnull(sum(if(Age between 20 and 25 and gender='M',1,0)),0) as '20-24yrs - Male',
        ifnull(sum(if(Age between 20 and 25 and gender not in ('F','M'),1,0)),0) as '20-24yrs - TG',
        ifnull(sum(if(Age between 25 and 50 and gender='F',1,0)),0) as '25-49yrs - Female',
        ifnull(sum(if(Age between 25 and 50 and gender='M',1,0)),0) as '25-49yrs - Male',
        ifnull(sum(if(Age between 25 and 50 and gender not in ('F','M'),1,0)),0) as '25-49yrs - TG',
        ifnull(sum(if(Age >= 50 and gender='F',1,0)),0) as '>=50yrs - Female',
        ifnull(sum(if(Age >= 50 and gender='M',1,0)),0) as '>=50yrs - Male',
        ifnull(sum(if(Age >= 50 and gender not in ('F','M'),1,0)),0) as '>=50yrs - TG'

from (select o.person_id, p.gender, p.birthdate,datediff(o.obs_datetime,p.birthdate)/365 as 'Age' from obs_view o 
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name = 'STI, STI Diagnosis Syndrome' and o.value_coded is not null and 
		o.obs_datetime between @start_date and @end_date group by o.person_id) as t2

union all 

select 	'STI - Treated' as 'STI Cases by Sex & Age Group',
		ifnull(sum(if(Age < 15 and gender='F',1,0)),0) as '<=14yrs - Female',
        ifnull(sum(if(Age < 15 and gender='M',1,0)),0) as '<=14yrs - Male',
        ifnull(sum(if(Age < 15 and gender not in ('F','M'),1,0)),0) as '<=14yrs - TG',
        ifnull(sum(if(Age between 15 and 20 and gender='F',1,0)),0) as '15-19yrs - Female',
        ifnull(sum(if(Age between 15 and 20 and gender='M',1,0)),0) as '15-19yrs - Male',
        ifnull(sum(if(Age between 15 and 20 and gender not in ('F','M'),1,0)),0) as '15-19yrs - TG',
        ifnull(sum(if(Age between 20 and 25 and gender='F',1,0)),0) as '20-24yrs - Female',
        ifnull(sum(if(Age between 20 and 25 and gender='M',1,0)),0) as '20-24yrs - Male',
        ifnull(sum(if(Age between 20 and 25 and gender not in ('F','M'),1,0)),0) as '20-24yrs - TG',
        ifnull(sum(if(Age between 25 and 50 and gender='F',1,0)),0) as '25-49yrs - Female',
        ifnull(sum(if(Age between 25 and 50 and gender='M',1,0)),0) as '25-49yrs - Male',
        ifnull(sum(if(Age between 25 and 50 and gender not in ('F','M'),1,0)),0) as '25-49yrs - TG',
        ifnull(sum(if(Age >= 50 and gender='F',1,0)),0) as '>=50yrs - Female',
        ifnull(sum(if(Age >= 50 and gender='M',1,0)),0) as '>=50yrs - Male',
        ifnull(sum(if(Age >= 50 and gender not in ('F','M'),1,0)),0) as '>=50yrs - TG'

from (select o.person_id, p.gender, p.birthdate,datediff(o.obs_datetime,p.birthdate)/365 as 'Age' from obs_view o 
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name in ('STI, Sydromic Treatment','STI, Etiological Treatment') and o.value_coded = 1 and 
		o.obs_datetime between @start_date and @end_date group by o.person_id) as t3
        
union all 

select 	'Presumptive Treatment to SWs' as 'STI Cases by Sex & Age Group',
		ifnull(sum(if(Age < 15 and gender='F',1,0)),0) as '<=14yrs - Female',
        ifnull(sum(if(Age < 15 and gender='M',1,0)),0) as '<=14yrs - Male',
        ifnull(sum(if(Age < 15 and gender not in ('F','M'),1,0)),0) as '<=14yrs - TG',
        ifnull(sum(if(Age between 15 and 20 and gender='F',1,0)),0) as '15-19yrs - Female',
        ifnull(sum(if(Age between 15 and 20 and gender='M',1,0)),0) as '15-19yrs - Male',
        ifnull(sum(if(Age between 15 and 20 and gender not in ('F','M'),1,0)),0) as '15-19yrs - TG',
        ifnull(sum(if(Age between 20 and 25 and gender='F',1,0)),0) as '20-24yrs - Female',
        ifnull(sum(if(Age between 20 and 25 and gender='M',1,0)),0) as '20-24yrs - Male',
        ifnull(sum(if(Age between 20 and 25 and gender not in ('F','M'),1,0)),0) as '20-24yrs - TG',
        ifnull(sum(if(Age between 25 and 50 and gender='F',1,0)),0) as '25-49yrs - Female',
        ifnull(sum(if(Age between 25 and 50 and gender='M',1,0)),0) as '25-49yrs - Male',
        ifnull(sum(if(Age between 25 and 50 and gender not in ('F','M'),1,0)),0) as '25-49yrs - TG',
        ifnull(sum(if(Age >= 50 and gender='F',1,0)),0) as '>=50yrs - Female',
        ifnull(sum(if(Age >= 50 and gender='M',1,0)),0) as '>=50yrs - Male',
        ifnull(sum(if(Age >= 50 and gender not in ('F','M'),1,0)),0) as '>=50yrs - TG'

from (select o.person_id, p.gender, p.birthdate,datediff(o.obs_datetime,p.birthdate)/365 as 'Age' from obs_view o 
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name = 'STI, Presumptive Treatment for Sex Workers' and o.value_coded = 1 and 
		o.obs_datetime between @start_date and @end_date group by o.person_id) as t4
        
union all 

select 	'Asymptomatic Partners Treated' as 'STI Cases by Sex & Age Group',
		ifnull(sum(if(Age < 15 and gender='F',1,0)),0) as '<=14yrs - Female',
        ifnull(sum(if(Age < 15 and gender='M',1,0)),0) as '<=14yrs - Male',
        ifnull(sum(if(Age < 15 and gender not in ('F','M'),1,0)),0) as '<=14yrs - TG',
        ifnull(sum(if(Age between 15 and 20 and gender='F',1,0)),0) as '15-19yrs - Female',
        ifnull(sum(if(Age between 15 and 20 and gender='M',1,0)),0) as '15-19yrs - Male',
        ifnull(sum(if(Age between 15 and 20 and gender not in ('F','M'),1,0)),0) as '15-19yrs - TG',
        ifnull(sum(if(Age between 20 and 25 and gender='F',1,0)),0) as '20-24yrs - Female',
        ifnull(sum(if(Age between 20 and 25 and gender='M',1,0)),0) as '20-24yrs - Male',
        ifnull(sum(if(Age between 20 and 25 and gender not in ('F','M'),1,0)),0) as '20-24yrs - TG',
        ifnull(sum(if(Age between 25 and 50 and gender='F',1,0)),0) as '25-49yrs - Female',
        ifnull(sum(if(Age between 25 and 50 and gender='M',1,0)),0) as '25-49yrs - Male',
        ifnull(sum(if(Age between 25 and 50 and gender not in ('F','M'),1,0)),0) as '25-49yrs - TG',
        ifnull(sum(if(Age >= 50 and gender='F',1,0)),0) as '>=50yrs - Female',
        ifnull(sum(if(Age >= 50 and gender='M',1,0)),0) as '>=50yrs - Male',
        ifnull(sum(if(Age >= 50 and gender not in ('F','M'),1,0)),0) as '>=50yrs - TG'

from (select o.person_id, p.gender, p.birthdate,datediff(o.obs_datetime,p.birthdate)/365 as 'Age' from obs_view o 
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name = 'STI, Asymptomatic Partners Treated' and o.value_coded = 1 and 
		o.obs_datetime between @start_date and @end_date group by o.person_id) as t5
