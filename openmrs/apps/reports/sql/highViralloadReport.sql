SELECT tVlresults.registrationdate as 'Registration Date', tDemographics.artnumber as 'ART Number', tDemographics.ClientName as 'Client Fullnames' , tDemographics.ClientsContact as 'Clients Contacts',tDemographics.sex as 'Sex', tDemographics.Age as 'Age',  
tSampleCollectDate.DateSampleCollected as 'Date Sample Collected' , tSampleReceived.DateSampleReceived, tVlresults.VLResults as 'Results(Copies/ml)' ,
tFirstEACsessionDate.FirstEACSession as 'First EAC Session', tSecondEACDate.SecondEACSession as 'Second EAC Session', 
tThirdEACDate.ThirdEACSession as 'Third EAC Session' , tadherence.Adherence_status as 'Classification of Adherence After EAC' ,
tRepeatViralCollDate.samplecolldaterviral as 'Sample Collection Date (Repeat Viral)' , tResultsarrivaldate.arrivalresultsrepeatviral as 'Results Arrival Date (Repeat Viral)',
tRepeatviralresults.repeatviralresults as 'Results(Repeat Viral) copies/ml' ,  tadherence.Adherence_status as 'Classification of Adherence After EAC',
tadherenceOutcome.Adherence_outcome as 'Adherence Outcome' , tMdtheld.mdtheldQstn as 'MDT HELD?' , tregimenSwitched.regimenSwitched as 'Was Regimen Switched?' , tregimenSwitched.actualRegimenSwitchedDate as 'Actual Regimen Change Date'
FROM
(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', e2.value as 'ClientsContact' ,
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
inner join person_attribute e2 on pa.person_id = e2.person_id
where pa.person_attribute_type_id = 29  and e2.person_attribute_type_id =32 ) tDemographics
inner join 
(select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_numeric as VLResults , o.obs_datetime as 'registrationdate'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'VL Results' and cn.concept_name_type = 'FULLY_SPECIFIED' 
and o.voided = false and o.status = 'final' and o.value_numeric >= 1000 and o.obs_datetime between '#startDate#' and '#endDate#') tVlresults 
on  tVlresults.person_id = tDemographics.person_id 
LEFT JOIN   
(select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as DateSampleCollected
from concept_name cn
left join obs o on cn.concept_id = o.concept_id
where cn.name  = 'Date VL Sample Collected?' and cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tSampleCollectDate
ON tVlresults.person_id=tSampleCollectDate.person_id
LEFT JOIN  
(   
select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as 'DateSampleReceived'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Date Sample Received at Testing Lab' and
 cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tSampleReceived 
on tVlresults.person_id = tSampleReceived.person_id 
LEFT JOIN
(select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as 'FirstEACSession'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'First EAC Session Date' 
and cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tFirstEACsessionDate 
on tVlresults.person_id = tFirstEACsessionDate.person_id 
LEFT JOIN
(select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as 'SecondEACSession'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Second EAC Session Date' and cn.concept_name_type = 'FULLY_SPECIFIED'
and o.voided = false and o.status = 'final') tSecondEACDate
on tVlresults.person_id = tSecondEACDate.person_id 
LEFT JOIN
(select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as 'ThirdEACSession'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Third EAC Session Date' and cn.concept_name_type = 'FULLY_SPECIFIED'
and o.voided = false and o.status = 'final') tThirdEACDate 
on tVlresults.person_id = tThirdEACDate.person_id 
LEFT JOIN
(select o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_coded as 'Adherence' 
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Classification Of Adherence After EAC' 
and cn.concept_name_type = 'FULLY_SPECIFIED'
and o.voided = false and o.status = 'final' ) tAdherence
on tVlresults.person_id = tAdherence.person_id
LEFT JOIN
(
select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as 'samplecolldaterviral'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Repeat Viral,Sample Collection Date'  and
cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tRepeatViralCollDate
on tVlresults.person_id = tRepeatViralCollDate.person_id 
LEFT JOIN
(
select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as 'arrivalresultsrepeatviral'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Repeat Viral,Date of Arrival Of Results'  and
cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tResultsarrivaldate
on tVlresults.person_id = tResultsarrivaldate.person_id 
LEFT JOIN 
(
select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_numeric as 'repeatviralresults'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Viral Load Value , Adherence Failure'  and
cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tRepeatviralresults
on tVlresults.person_id = tRepeatviralresults.person_id 
LEFT JOIN
(
select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_coded as 'repeatviraloutcome'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Repeat Viral,Outcome Action'  and
cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tRepeatviraloutcome
on tVlresults.person_id = tRepeatviraloutcome.person_id 
LEFT JOIN
(
select tadherencestatus.Adherence , ans.name as 'Adherence_status' , tadherencestatus.personid as 'person_id'  from (
select tadherence.name, tadherence.Adherence , tadherence.person_id as 'personid' from (
select o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_coded as 'Adherence' 
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Classification Of Adherence After EAC' 
and cn.concept_name_type = 'FULLY_SPECIFIED'
and o.voided = false and o.status = 'final' ) tadherence
left join 
(select A.concept_id, name  from concept_name A 
where A.concept_id in ( select B.value_coded  from obs B where B.value_coded = B.value_coded 
and A.concept_name_type = 'FULLY_SPECIFIED'
)) tgetAdherence 
on tadherence.concept_id = tgetAdherence.concept_id
) tadherencestatus 
left join 
concept_name ans on tadherencestatus.Adherence = ans.concept_id and ans.concept_name_type = 'SHORT') tadherence
on tVlresults.person_id = tadherence.person_id 
LEFT JOIN
(
select tadherenceAfterEAC.Adherence , ans.name as 'Adherence_outcome' , tadherenceAfterEAC.personid as 'person_id'  from (
select tadherenceOutcome.name, tadherenceOutcome.Adherence , tadherenceOutcome.person_id as 'personid' from (
select o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_coded as 'Adherence' 
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Repeat Viral,Outcome Action' 
and cn.concept_name_type = 'FULLY_SPECIFIED'
and o.voided = false and o.status = 'final' ) tadherenceOutcome
left join 
(select A.concept_id, name  from concept_name A 
where A.concept_id in ( select B.value_coded  from obs B where B.value_coded = B.value_coded 
and A.concept_name_type = 'FULLY_SPECIFIED'
)) tgetAdherence 
on tadherenceOutcome.concept_id = tgetAdherence.concept_id
) tadherenceAfterEAC 
left join 
concept_name ans on tadherenceAfterEAC.Adherence = ans.concept_id and ans.concept_name_type = 'SHORT') tadherenceOutcome
on tVlresults.person_id = tadherenceOutcome.person_id
LEFT JOIN
(
select tadherenceAfterEAC.Adherence , ans.name as 'mdtheldQstn' , tadherenceAfterEAC.personid as 'person_id'  from (
select tMdtheld.name, tMdtheld.Adherence , tMdtheld.person_id as 'personid' from (
select o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_coded as 'Adherence' 
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'MDT Held?' 
and cn.concept_name_type = 'FULLY_SPECIFIED'
and o.voided = false and o.status = 'final' ) tMdtheld
left join 
(select A.concept_id, name  from concept_name A 
where A.concept_id in ( select B.value_coded  from obs B where B.value_coded = B.value_coded 
and A.concept_name_type = 'FULLY_SPECIFIED'
)) tgetAdherence 
on tMdtheld.concept_id = tgetAdherence.concept_id
) tadherenceAfterEAC 
left join 
concept_name ans on tadherenceAfterEAC.Adherence = ans.concept_id and ans.concept_name_type = 'FULLY_SPECIFIED') tMdtheld
on tVlresults.person_id = tMdtheld.person_id
LEFT JOIN  
(   
select  o.person_id, cn.concept_id  , cn.name , cn.concept_name_type , o.value_datetime as 'dateMdtHeld'
from concept_name cn
left join obs o on cn.concept_id = o.concept_id where cn.name  = 'Date MDT Held' and
 cn.concept_name_type = 'FULLY_SPECIFIED' and o.voided = false and o.status = 'final') tDateMDTHeld 
on tVlresults.person_id = tDateMDTHeld.person_id 
LEFT JOIN 
(
select  dr.dosage_form, o.patient_id ,
(case when dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen') then count(distinct(cn.concept_id)) else null end) as 'Count',
(case when ((case when dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen') then count(distinct(cn.concept_id)) else null end)) > 1 then 'True' else 'False' end) as 'regimenSwitched',
(case when ((case when dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen') then count(distinct(cn.concept_id)) else null end)) > 1 then max(o.date_created) else 'N/A' end) as 'actualRegimenSwitchedDate'
from concept_name cn 
left join orders o on cn.concept_id = o.concept_id
left join drug dr on o.concept_id = dr.concept_id
where concept_name_type = 'FULLY_SPECIFIED' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen') group by o.patient_id) tregimenSwitched
on tVlresults.person_id = tregimenSwitched.patient_id 

