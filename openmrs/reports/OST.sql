SET @start_date = '2014-10-01';
SET @end_date = '2015-01-01';
select concept_id into @positive from concept_view where concept_full_name = 'Positive';
select concept_id into @negative from concept_view where concept_full_name = 'Negative';

select concept_id into @ost_new from concept_view where concept_full_name = 'New';
select concept_id into @ost_reg from concept_view where concept_full_name = 'Regular';
select concept_id into @ost_transfer_in from concept_view where concept_full_name = 'Transfer In';


select 'Clients on OST at the End of' as 'OST', 'Last' as 'Month',
       ifnull(sum(if(gender='F',1,0)),0) as 'Female',
       ifnull(sum(if(gender='M',1,0)),0) as 'Male',
       ifnull(sum(if(gender not in ('F','M'),1,0)),0) as 'TG' from
       (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, o.obs_datetime from obs_view o
       	       inner join person p on o.person_id = p.person_id
	       where o.concept_full_name = 'OST, Enrollment Type' and o.value_coded is not null and
	       (o.obs_datetime < @start_date) group by person_id) as t1 
                    
union all

select 'New Clients Enrolled at' as 'OST', 'This' as 'Month',
       ifnull(sum(if(gender='F',1,0)),0) as 'Female',
       ifnull(sum(if(gender='M',1,0)),0) as 'Male',
       ifnull(sum(if(gender not in ('F','M'),1,0)),0) as 'TG' from
       (select o.person_id, o.concept_full_name, o.value_text,o.value_coded, p.gender, o.obs_datetime from obs_view o
       	       inner join person p on o.person_id = p.person_id
	       where o.concept_full_name = 'OST, Enrollment Type' and o.value_coded = @ost_new and   
	       (o.obs_datetime between @start_date and @end_date) group by person_id) as t2

union all

select 'Clients Re-entry at' as 'OST', 'This' as 'Month',
       ifnull(sum(if(gender='F',1,0)),0) as 'Female',
       ifnull(sum(if(gender='M',1,0)),0) as 'Male',
       ifnull(sum(if(gender not in ('F','M'),1,0)),0) as 'TG' from
       (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, o.obs_datetime from obs_view o
	       inner join person p on o.person_id = p.person_id
	       where o.concept_full_name = 'OST, Enrollment Type' and o.value_coded = @ost_reg and   
	       (o.obs_datetime between @start_date and @end_date) group by person_id) as t3

union all

select 'Clients +ve Discharge at' as 'OST', 'This' as 'Month',
       ifnull(sum(if(gender='F',1,0)),0) as 'Female',
       ifnull(sum(if(gender='M',1,0)),0) as 'Male',
       ifnull(sum(if(gender not in ('F','M'),1,0)),0) as 'TG' from
       (select t4_1.person_id, concept_full_name, value_text, value_coded, gender, obs_datetime from 
		(select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, o.obs_datetime from obs_view o
			inner join person p on o.person_id = p.person_id
			where o.concept_full_name = 'OST, Date of Transfer Out' and o.value_datetime is not null
       			and (o.obs_datetime between @start_date and @end_date) group by person_id) as t4_1
		inner join
                (select p.person_id as 'Person_ID' from obs_view o
			inner join person p on o.person_id = p.person_id
			where ((o.concept_full_name = 'HCT, Result if tested' and o.value_coded in (@positive)) or (o.concept_full_name='HIV Tridot' and o.value_text in ('Positive')))
                    	and (o.obs_datetime between @start_date and @end_date) group by p.person_id) as t4_2 on t4_1.person_id=t4_2.Person_ID) as t4
                    
union all

select 'Clients Drop Out at' as 'OST', 'This' as 'Month',
       ifnull(sum(if(gender='F',1,0)),0) as 'Female',
       ifnull(sum(if(gender='M',1,0)),0) as 'Male',
       ifnull(sum(if(gender not in ('F','M'),1,0)),0) as 'TG' from
       (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, o.obs_datetime from obs_view o
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name = 'OST, Date of Drop out' and o.value_datetime is not null and   
		(o.obs_datetime between @start_date and @end_date) group by person_id) as t5

union all

select 'Clients on OST at the End of' as 'OST', 'This' as 'Month',
       ifnull(sum(if(gender='F',1,0)),0) as 'Female',
       ifnull(sum(if(gender='M',1,0)),0) as 'Male',
       ifnull(sum(if(gender not in ('F','M'),1,0)),0) as 'TG' from
       (select o.person_id, o.concept_full_name, o.value_text, o.value_coded, p.gender, o.obs_datetime from obs_view o
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name = 'OST, Enrollment Type' and o.value_coded is not null and  
		(o.obs_datetime <= @end_date) group by person_id) as t6
