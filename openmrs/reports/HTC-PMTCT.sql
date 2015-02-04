SET @start_date = '2014-10-01';
SET @end_date = '2015-01-31';

select @serial_number:=@serial_number+1 as 'S.No',`Client Code`,`District Code`,Sex,`Age(in yrs)`,`Risk Group(s)`,`Initial CD4 Count`,`WHO Stage` from
(select t1.identifier as 'Client Code',county_district as 'District Code',gender as 'Sex', floor(DATEDIFF(obs_date,birthdate)/365) as 'Age(in yrs)', 
	group_concat(risk_group separator ',') as 'Risk Group(s)', CD4 as 'Initial CD4 Count', WHO as 'WHO Stage' from

	(select pi.identifier, o.person_id, pa.county_district,p.gender,o.concept_full_name,c.concept_full_name as 'risk_group',
		o.value_coded, o.value_text,DATE(o.obs_datetime) as 'obs_date',p.birthdate
		from obs_view o
		inner join person p on o.person_id = p.person_id
        	inner join person_address pa on p.person_id = pa.person_id
        	inner join patient_identifier pi on p.person_id = pi.patient_id
        	left outer join concept_view c on o.value_coded = c.concept_id
		where (o.concept_full_name in ('HTC, Risk Group','PMTCT, Risk Group') and o.value_coded is not null)
        	and (o.obs_datetime between @start_date and @end_date) group by o.person_id, o.concept_full_name, c.concept_full_name) as t1
                    
	inner join 

	(select person_id from obs_view	
		where ((concept_full_name = 'HTC, Result if tested'
		and value_coded in (select concept_id from concept_view where concept_full_name = 'Positive')) or (concept_full_name in ('HIV (Blood)','HIV (Serum)') and value_text in ('Positive')))
        	and (obs_datetime between @start_date and @end_date) group by person_id) as t2 on t1.person_id = t2.person_id
                    
	inner join

	(select person_id, value_numeric as 'CD4',min(obs_datetime) from obs_view 
		where concept_full_name = 'CD4' group by person_id)as t3 on t1.person_id = t3.person_id
 
	inner join

	(select o.person_id,c.concept_full_name as 'WHO' from obs_view o
		inner join concept_view c on o.value_coded = c.concept_id
		where o.concept_full_name in ('HTC, WHO Staging', 'PMTCT, WHO clinical staging') and o.value_coded is not null and (o.person_id,o.obs_datetime) in
		(select person_id, max(obs_datetime) as 'obs_datetime' from
			(select o.person_id,o.concept_full_name,o.obs_datetime,o.value_coded, c.concept_full_name as 'WHO_Stage' from obs_view o
				inner join concept_view c on o.value_coded = c.concept_id        
				where o.concept_full_name in ('HTC, WHO Staging', 'PMTCT, WHO clinical staging') and o.value_coded is not null 
				group by o.person_id,o.concept_full_name having max(o.obs_datetime)) as t1 group by t1.person_id)) as t4 on t1.person_id = t4.person_id

  join

  (SELECT @serial_number := 0) as r

group by t1.identifier order by t1.person_id) as final_table;
