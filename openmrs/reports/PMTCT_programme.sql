SET @start_date = '2014-10-01';
SET @end_date = '2015-02-01';
select concept_id into @positive from concept_view where concept_full_name = 'Positive';
select concept_id into @negative from concept_view where concept_full_name = 'Negative';
select concept_id into @before_pregnancy from concept_view where concept_full_name = 'Before Pregnancy';
select concept_id into @antenatal from concept_view where concept_full_name = 'Antenatal Period';
select concept_id into @intrapartum from concept_view where concept_full_name = 'Intrapartum';
select concept_id into @postnatal from concept_view where concept_full_name = 'Postnatal';
select concept_id into @exclusive from concept_view where concept_full_name = 'Exclusive Breast Feeding';
select concept_id into @replacement from concept_view where concept_full_name = 'Replacement Breast Feeding';
select concept_id into @mixed from concept_view where concept_full_name = 'Mixed Breast Feeding';


select 
	(select count(*) from (select * from obs_view o where o.concept_full_name like 'ANC,%' and o.obs_datetime between @start_date and @end_date group by o.person_id, date(o.obs_datetime)) t1) as 'Number of ANC Visits',
    (select count(*) from (select * from obs_view where concept_full_name = 'ANC, HIV Counseling' and value_coded = 1 and obs_datetime between @start_date and @end_date group by person_id) t2) as 'Pragnancy - HIV Counseled',
	(select count(*) from (select * from obs_view where concept_full_name = 'ANC, HIV Result Received' and value_coded = 1 and obs_datetime between @start_date and @end_date group by person_id) t3) as 'Pragnancy - HIV Tested',
    (select count(*) from (select * from obs_view where concept_full_name = 'ANC, HIV Test Result' and value_coded = @positive and obs_datetime between @start_date and @end_date group by person_id) t4) as 'Pragnancy - HIV Positive',
    (select count(*) from (select * from obs_view where concept_full_name like 'Delivery Note,%' and (person_id,date(obs_datetime)) in 
		(select person_id,date(obs_datetime) from obs_view where concept_full_name = 'HCT, Pre-test Counceling')
        and obs_datetime between @start_date and @end_date group by person_id, date(obs_datetime)) t5) as 'Labour & Delivery - Counseled',
	(select count(*) from (select * from obs_view where concept_full_name like 'Delivery Note,%' and (person_id,date(obs_datetime)) in 
		(select person_id,date(obs_datetime) from obs_view where concept_full_name = 'HCT, Result' and value_coded is not null)
        and obs_datetime between @start_date and @end_date group by person_id, date(obs_datetime)) t6) as 'Labour & Delivery - Tested',
	(select count(*) from (select * from obs_view where concept_full_name like 'Delivery Note,%' and (person_id,date(obs_datetime)) in 
		(select person_id,date(obs_datetime) from obs_view where concept_full_name = 'HCT, Result' and value_coded = @positive)
        and obs_datetime between @start_date and @end_date group by person_id, date(obs_datetime)) t7) as 'Labour & Delivery - Positive',
    (select count(*) from (select * from obs_view where concept_full_name like 'PNC,%' and (person_id,date(obs_datetime)) in 
		(select person_id,date(obs_datetime) from obs_view where concept_full_name = 'HCT, Pre-test Counceling')
        and obs_datetime between @start_date and @end_date group by person_id, date(obs_datetime)) t8) as 'Puerperium - Counseled',
	(select count(*) from (select * from obs_view where concept_full_name like 'PNC,%' and (person_id,date(obs_datetime)) in 
		(select person_id,date(obs_datetime) from obs_view where concept_full_name = 'HCT, Result' and value_coded is not null)
        and obs_datetime between @start_date and @end_date group by person_id, date(obs_datetime)) t9) as 'Puerperium - Tested',
	(select count(*) from (select * from obs_view where concept_full_name like 'PNC,%' and (person_id,date(obs_datetime)) in 
		(select person_id,date(obs_datetime) from obs_view where concept_full_name = 'HCT, Result' and value_coded = @positive)
        and obs_datetime between @start_date and @end_date group by person_id, date(obs_datetime)) t10) as 'Puerperium - Positive',
	(select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Started ART during' and value_coded = @before_pregnancy and obs_datetime between @start_date and @end_date group by person_id) t11) as 'ART Started - Before Pragnancy',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Started ART during' and value_coded = @antenatal and obs_datetime between @start_date and @end_date group by person_id) t12) as 'ART Started - Pragnancy',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Started ART during' and value_coded = @intrapartum and obs_datetime between @start_date and @end_date group by person_id) t13) as 'ART Started - Labour & Delivery',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Started ART during' and value_coded = @postnatal and obs_datetime between @start_date and @end_date group by person_id) t14) as 'ART Started - Postnatal',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Who already know their HIV status' and value_coded is not null and obs_datetime between @start_date and @end_date group by person_id) t15) as 'HIV +ve women - Male partner who know their status',
    (select count(*) from (select * from obs_view where concept_full_name like 'Delivery,%' and person_id in 
		(select person_id from obs_view where concept_full_name = 'PMTCT, Women identified HIV Positive during' and value_coded in (@before_pregnancy,@antenatal))
        and obs_datetime between @start_date and @end_date group by person_id, date(obs_datetime)) t16) as 'HIV +ve women - Delivered',
	(select sum(value_numeric) from obs_view where concept_full_name = 'PMTCT, Live Birth' and obs_datetime between @start_date and @end_date) as 'Exposed Baby - Live Births',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Started ARV Prophylaxis for Baby' and value_coded = 1 and obs_datetime between @start_date and @end_date group by person_id) t17) as 'Exposed Baby - Started ARV Prophylaxis',
	(select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Breast feeding options opted by HIV +ve mother' and value_coded = @exclusive and obs_datetime between @start_date and @end_date group by person_id) t18) as 'Breast feeding status - Exclusive',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Breast feeding options opted by HIV +ve mother' and value_coded = @replacement and obs_datetime between @start_date and @end_date group by person_id) t19) as 'Breast feeding status - Replacement',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, Breast feeding options opted by HIV +ve mother' and value_coded = @mixed and obs_datetime between @start_date and @end_date group by person_id) t20) as 'Breast feeding status - Mixed',
    (select count(*) from (select * from obs_view where concept_full_name = 'PMTCT, FP services during' and value_coded = 1 and obs_datetime between @start_date and @end_date group by person_id) t21) as 'HIV +ve postpartum women received FP services'
