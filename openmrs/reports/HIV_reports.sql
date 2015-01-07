SET @start_date = '2014-10-01';
SET @end_date = '2014-12-31';
select @positive := concept_id from concept_view where concept_full_name = 'Positive';
select @negative := concept_id from concept_view where concept_full_name = 'Negative';
select @sexworker := concept_id from concept_view where concept_full_name = 'Sex Worker';
select @MSM_TG := concept_id from concept_view where concept_full_name = 'MSM & TG';
select @sexworker_client := concept_id from concept_view where concept_full_name = 'Client of Sex Worker';
select @PWID := concept_id from concept_view where concept_full_name = 'People Who Inject Drugs';
select @migrant := concept_id from concept_view where concept_full_name = 'Migrant';
select @migrant_spouse := concept_id from concept_view where concept_full_name = 'Spouse/Partner of Migrant';
select @organ_recipient := concept_id from concept_view where concept_full_name = 'Blood or Organ Recipient';
select @others := concept_id from concept_view where concept_full_name = 'Others';

-- HIV Testing and Counseling (HTC) Programme 
-- ------------------------------------------
-- ------------------------------------------


-- ------------------------------------------
-- Age Group <= 14yrs 
-- ------------------------------------------

SELECT '<=14yrs - Tested' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 < 15) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all

SELECT '<=14yrs - Positive' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 < 15) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all    
    
-- ------------------------------------------
-- Age Group 15-19yrs
-- ------------------------------------------
SELECT '15-19yrs - Tested' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 15 and 20) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all

SELECT '15-19yrs - Positive' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 15 and 20) and (obs_view.obs_datetime between @start_date and @end_date)


union all


-- ------------------------------------------
-- Age Group 20-24 14yrs
-- ------------------------------------------
SELECT '20-24yrs - Tested' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 20 and 25) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all

SELECT '20-24yrs - Positive' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 20 and 25) and (obs_view.obs_datetime between @start_date and @end_date)


union all


-- ------------------------------------------
-- Age Group 25-49yrs
-- ------------------------------------------
SELECT '25-49yrs - Tested' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 25 and 50) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all

SELECT '25-49yrs - Positive' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 25 and 50) and (obs_view.obs_datetime between @start_date and @end_date)


union all


-- ------------------------------------------
-- Age Group >= 50yrs
-- ------------------------------------------
SELECT '>=50yrs - Tested' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Tested before' and obs_view.value_coded = 1, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'|'Negative'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 >= 50) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all

SELECT '>=50yrs - Positive' as Indicator,																	
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'M',1,0),0),0))) as 'Sex Worker - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender = 'F',1,0),0),0))) as 'Sex Worker - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Sex Worker - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'M',1,0),0),0))) as 'Other MSM & TG - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender = 'F',1,0),0),0))) as 'Other MSM & TG - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @MSM_TG,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Other MSM & TG - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'M',1,0),0),0))) as 'Clients of Sex Workers - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender = 'F',1,0),0),0))) as 'Clients of Sex Workers - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @sexworker_client,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Clients of Sex Workers - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'M',1,0),0),0))) as 'People Who Inject Drugs - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender = 'F',1,0),0),0))) as 'People Who Inject Drugs - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @PWID,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'People Who Inject Drugs - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'M',1,0),0),0))) as 'Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender = 'F',1,0),0),0))) as 'Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'M',1,0),0),0))) as 'Spouse/Partners of Migrants - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender = 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @migrant_spouse,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Spouse/Partners of Migrants - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'M',1,0),0),0))) as 'Blood or Organ Recipients - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender = 'F',1,0),0),0))) as 'Blood or Organ Recipients - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @organ_recipient,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Blood or Organ Recipients - TG',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'M',1,0),0),0))) as 'Others - Male',
	sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender = 'F',1,0),0),0))) as 'Others - Female',
    sum(if(obs_view.concept_full_name='HTC, Result if tested' and obs_view.value_coded = @positive, if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),
		if(obs_view.concept_full_name = 'HIV Tridot' and (obs_view.value_text='Positive'), if(obs_view.concept_full_name='HTC, Risk Group' and obs_view.value_coded = @others,if(person.gender != 'M' and person.gender != 'F',1,0),0),0))) as 'Others - TG'    
    from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and 
    visit.patient_id = person.person_id and
	(DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 >= 50) and (obs_view.obs_datetime between @start_date and @end_date)

















































-- Parameters
SET @start_date = '2014-10-01';
SET @end_date = '2014-12-01';

-- HIV Testing and Counseling (HTC) Programme 
-- ------------------------------------------
-- ------------------------------------------



-- ------------------------------------------
-- Age Group <= 14yrs 
-- ------------------------------------------

SELECT '<=14yrs - Tested' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 < 15) and (obs_view.obs_datetime between @start_date and @end_date)

union all
    
SELECT '<=14yrs - Positive' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 < 15) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all 


-- ------------------------------------------
-- Age Group 15-19yrs
-- ------------------------------------------
SELECT '15-19yrs - Tested' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 15 and 20) and (obs_view.obs_datetime between @start_date and @end_date)

union all
    
SELECT '15-19yrs - Positive' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 15 and 20) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all

-- ------------------------------------------
-- Age Group 20-24 14yrs
-- ------------------------------------------
SELECT '20-24yrs - Tested' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 20 and 25) and (obs_view.obs_datetime between @start_date and @end_date)

union all
    
SELECT '20-24yrs - Positive' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 20 and 25) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all 

-- ------------------------------------------
-- Age Group 25-49yrs
-- ------------------------------------------
SELECT '25-49yrs - Tested' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 25 and 50) and (obs_view.obs_datetime between @start_date and @end_date)

union all
    
SELECT '25-49yrs - Positive' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 between 25 and 50) and (obs_view.obs_datetime between @start_date and @end_date)
    
union all

-- ------------------------------------------
-- Age Group >= 50yrs
-- ------------------------------------------
SELECT '>=50yrs - Tested' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive'|'Negative', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 >= 50) and (obs_view.obs_datetime between @start_date and @end_date)

union all
    
SELECT '>=50yrs - Positive' as Indicator,
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'M',1,0),0),0)) as 'Male',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender = 'F',1,0),0),0)) as 'Female',
       sum(if(obs_view.concept_full_name = 'HIV Tridot', if(obs_view.value_text='Positive', if(person.gender != 'M' and person.gender != 'F',1,0),0),0)) as 'TG',
       sum(if(obs_view.concept_full_name = 'Nutritional Values',if(person.gender = 'M',1,0),0)) as 'Nutritional Values'
       from obs_view,encounter,visit,person where obs_view.encounter_id = encounter.encounter_id and encounter.visit_id = visit.visit_id and visit.patient_id = person.person_id and
       (DATEDIFF(obs_view.obs_datetime,person.birthdate)/365 >= 50) and (obs_view.obs_datetime between @start_date and @end_date)
