select 'less than a year' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age < 1 then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age < 1  then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age < 1 then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age < 1 then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age < 1 then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age < 1 then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age < 1 then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age < 1 then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age < 1 then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age < 1 then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '1 to 4 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 1 and age < 5  then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 1 and age < 5   then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 1 and age < 5  then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age >= 1 and age < 5  then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 1 and age < 5  then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 1 and age < 5  then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 1 and age < 5  then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 1 and age < 5  then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 1 and age < 5 then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 1 and age < 5  then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '5 to 9 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 5 and age < 10  then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 5 and age < 10    then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 5 and age < 10   then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age >= 5 and age < 10   then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 5 and age < 10  then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 5 and age < 10   then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 5 and age < 10   then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 5 and age < 10  then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 5 and age < 10  then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 5 and age < 10  then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '10 to 14 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 10 and age < 15  then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 10 and age < 15    then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 10 and age < 15   then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age > 10 and age < 15   then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 10 and age < 15  then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 10 and age < 15   then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 10 and age < 15   then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 10 and age < 15  then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 10 and age < 15  then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 10 and age < 15  then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '15 to 19 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 15 and age < 20  then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 15 and age < 20    then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 15 and age < 20   then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age > 15 and age < 20   then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 15 and age < 20  then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 15 and age < 20   then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 15 and age < 20   then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 15 and age < 20  then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 15 and age < 20  then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 15 and age < 20  then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '20 to 24 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 20 and age < 25  then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 20 and age < 25    then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 20 and age < 25   then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age > 20 and age < 25   then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 20 and age < 25  then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 20 and age < 25   then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 20 and age < 25   then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 20 and age < 25  then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 20 and age < 25  then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 20 and age < 25  then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '25 to 29 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 25 and age < 30  then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 25 and age < 30    then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 25 and age < 30   then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age >= 25 and age < 30   then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 25 and age < 30  then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 25 and age < 30   then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 25 and age < 30   then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 25 and age < 30  then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 25 and age < 30  then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 25 and age < 30  then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '30 to 34 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 30 and age < 35 then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 30 and age < 35   then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 30 and age < 35  then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age >= 30 and age < 35  then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 30 and age < 35 then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 30 and age < 35  then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 30 and age < 35  then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 30 and age < 35 then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 30 and age < 35 then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 30 and age < 35 then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '35 to 39 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 35 and age < 40 then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 35 and age < 40   then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 35 and age < 40  then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age >= 35 and age < 40  then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 35 and age < 40 then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 35 and age < 40  then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 35 and age < 40  then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 35 and age < 40 then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 35 and age < 40 then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 35 and age < 40 then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '40 to 44 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 40 and age < 45 then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 40 and age < 45   then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 40 and age < 45  then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age >= 40 and age < 45  then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 40 and age < 45 then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 40 and age < 45  then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 40 and age < 45  then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 40 and age < 45 then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 40 and age < 45 then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 40 and age < 45 then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '45 to 49 Years' as 'Age groups' ,sex,
count(distinct(case when pid is not null and age >= 45 and age < 50 then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and age >= 45 and age < 50   then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and age >= 45 and age < 50  then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and age > 45 and age < 50  then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and age >= 45 and age < 50 then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and age >= 45 and age < 50  then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and age >= 45 and age < 50  then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and age >= 45 and age < 50 then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and age >= 45 and age < 50 then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and age >= 45 and age < 50 then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex
union all
select '50 Years and Above' as 'Age groups' ,sex,
count(distinct(case when pid is not null and Age  >= 50 then pid end)) as 'ART patients with no clinical contact since their last expected contact',
count(distinct(case when outcomedied is not null and Age  >= 50   then pid end)) as 'Patient outcome - Died',
count(distinct(case when outcomeselftransfer is not null and Age  >= 50  then pid end)) as 'Patient outcome - Self transfer (silent transfer)',
count(distinct(case when tracedpatientunabletolocate is not null and Age  >= 50  then pid end)) as 'Patient outcome - Traced patient (unable to locate)', 
count(distinct(case when didnottrace is not null and Age  >= 50 then pid end)) as 'Patient outcome - Did not attempt to trace patient',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathTB is not null and Age  >= 50  then pid end)) as 'Cause of death - TB',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathCancer is not null and Age  >= 50  then pid end)) as 'Cause of death - Cancer',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathOtherinfecetious is not null and Age  >= 50 then pid end)) as 'Cause of death - Other infectious and parasitic disease',
count(distinct(case when endoffollowupduetodeath is not null and causeofdeathNonNaturalCauses is not null and Age  >= 50 then pid end)) as 'Cause of death - Non-natural causes (accident/war)',
count(distinct(case when endoffollowupduetodeath is not null and causeofUnknowCause is not null and Age  >= 50 then pid end)) as 'Cause of death - Unknown Cause'
 from (
select distinct(patient_id) as pid, end_date_time , status, voided from patient_appointment where status  in ('LostToFollowUp', 'Missed') and voided = 0 and end_date_time
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tLostTofollowup
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tLostTofollowup.pid = tDemographics.person_id 
left join (
select person_id, outcomeselftransfer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomeselftransfer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Self transfer(Silent Transfer)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSelfTransfer on tLostTofollowup.pid = tSelfTransfer.person_id 
left join (
select person_id, tracedpatientunabletolocate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tracedpatientunabletolocate', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Traced patient (Unable to locate)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTracedPatientUnabletolocate on tLostTofollowup.pid = tTracedPatientUnabletolocate.person_id 
left join(
select person_id, didnottrace from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'didnottrace', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Did not attempt to trace patient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDidnotattempttotrace on tLostTofollowup.pid = tDidnotattempttotrace.person_id 
left join(
select person_id, endoffollowupduetodeath from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'endoffollowupduetodeath', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Death during treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End Of Follow Up Reason' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEndoffollowupDeath on tLostTofollowup.pid = tEndoffollowupDeath.person_id 
left join (
select person_id, causeofdeathTB from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathTB', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, TB' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCauseByTB on tLostTofollowup.pid = tDeathCauseByTB.person_id 
left join(
select person_id, causeofdeathCancer from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathCancer', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Cancer' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedCancer on tLostTofollowup.pid = tDeathCausedCancer.person_id 
left join(
select person_id, causeofdeathOtherinfecetious from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathOtherinfecetious', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Other Other infectious  and parasitic disease' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedOtherInfectious on tLostTofollowup.pid = tDeathCausedOtherInfectious.person_id 
left join(
select person_id, causeofdeathNonNaturalCauses from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofdeathNonNaturalCauses', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death, Non-natural causes (accident/war)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByNonNaturalCauses on tLostTofollowup.pid = tDeathCausedByNonNaturalCauses.person_id
left join(
select person_id, causeofUnknowCause from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'causeofUnknowCause', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and 
value_coded = (select concept_id from concept_name where name = 'Cause Of Death,Unknown Cause' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow-up,Cause Of Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDeathCausedByUnknownCauses on tLostTofollowup.pid = tDeathCausedByUnknownCauses.person_id
left join(
select person_id, outcomedied from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'outcomedied', voided from obs where concept_id =
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'Patient outcome, Death' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'End of Follow up,Patient Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') 
and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tPatientDied on  tLostTofollowup.pid = tPatientDied.person_id group by sex