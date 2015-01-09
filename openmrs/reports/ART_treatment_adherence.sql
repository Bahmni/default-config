SET @start_date = '2014-10-01';
SET @end_date = '2015-02-01';
select concept_id into @adh_a from concept_view where concept_full_name = 'Adherence Level A';
select concept_id into @adh_b from concept_view where concept_full_name = 'Adherence Level B';
select concept_id into @adh_c from concept_view where concept_full_name = 'Adherence Level C';

select 'Accessed' as 'Treatment Adherence on ART',
		count(*) as 'No of Cases' from obs_view where concept_full_name = 'ART, ART adherence to ART' and 
        value_coded is not null and obs_datetime < @end_date

union all

select '< 95% (A)' as 'Treatment Adherence on ART',
		count(*) as 'No of Cases' from obs_view where concept_full_name = 'ART, ART adherence to ART' and 
        value_coded = @adh_a and obs_datetime < @end_date

union all 

select '80-95% (B)' as 'Treatment Adherence on ART',
		count(*) as 'No of Cases' from obs_view where concept_full_name = 'ART, ART adherence to ART' and 
        value_coded = @adh_b and obs_datetime < @end_date

union all 

select '< 80% (C)' as 'Treatment Adherence on ART',
		count(*) as 'No of Cases' from obs_view where concept_full_name = 'ART, ART adherence to ART' and 
        value_coded = @adh_c and obs_datetime < @end_date

