select  @a:=@a+1 as 'Serial Number' , registrationDate as 'Date of registration', artnumber as 'ART Number', ClientName as 'Client FullNames' , value as 'Client Contacts',Age,sex as 'Sex (M/F)', dateSampleCollected as 'First Viral Load\nDate of sample collection',dateSampleReceived as 'First Viral Load\nDate of arrival of the result' ,
vlresults as 'First Viral Load\nResult (Copies/ml)', firstEacDate as 'First EAC session - Date' , secondEacDate as 'Second EAC session - Date' , thirdEacDate as 'Third EAC session - Date', adherenceafterEac as 'Classification of adherence after EAC\n(Good, Fair, Poor)', 
repeatViralSampleCollectionDate as 'Repeat Viral Load\nDate of sample collection' , rvDateOfArrival as 'Repeat Viral Load\nDate of arrival of the result', adherencefailure  as 'Repeat Viral Load\nResult (copies/ml)', outcomeAfterRepeat as 'Outcome\nVS:Viral Suppression (<1000copies/ml)\nSTF:Suspecion of Treatment Failure(≥1000copies/ml)',
(case when regimenchangedto is not null then 'Y' else 'N' end) as ' Was regimen switched? (Y/N)',
date_activated as 'Date decision made to\nChange ART regimen' , (case when mdtHeld = 'True' then 'Y' else 'N' end) as 'MDT held? (Y/N)' , mdtChangeDate as 'MDT Held - Date' ,date_activated as 'Actual regimen\n change date (DD/MM/YYYY)',
(case when regimenchangedto is not null and date_activated is not null and date_activated < repeatViralSampleCollectionDate  THEN repeatViralSampleCollectionDate else 'N/A' end) as 'Repeat Viral Load after\nRegimen Change\nDate of sample collection',
(case when regimenchangedto is not null and date_activated is not null and date_activated < rvDateOfArrival  THEN rvDateOfArrival else 'N/A' end) as 'Repeat Viral Load after\nRegimen Change\nDate of arrival of the result',
(case when regimenchangedto is not null and date_activated is not null and date_activated < adherencefailuredate  THEN adherencefailuredate else 'N/A' end) as 'Repeat Viral Load after\nRegimen Change\nResult (copies/ml)',
summary as 'Comments'
from (
select (SELECT @a:= 0) AS a , obs_datetime as 'registrationDate', person_id , vlresults from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'vlresults', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate  and vlresults >= 1000
)tVlloadAbove100
inner join(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M') and gender is not null
)tDemographics on tVlloadAbove100.person_id = tDemographics.person_id
left join(
select pa.person_id, pa.person_attribute_type_id , pa.value from person_attribute pa
left join person_attribute_type pat on pa.person_attribute_type_id = pat.person_attribute_type_id
where pat.name = 'MobileNumber'
)tMobileNumber on tVlloadAbove100.person_id = tMobileNumber.person_id
left join(
select person_id , dateSampleCollected from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'dateSampleCollected', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date VL Sample Collected?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date VL Sample Collected?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateSampleCollected on tVlloadAbove100.person_id = tDateSampleCollected.person_id
left join (
select person_id , dateSampleReceived from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'dateSampleReceived', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Sample Received at Testing Lab' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Sample Received at Testing Lab' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateSampleReceived on tVlloadAbove100.person_id = tDateSampleReceived.person_id
left join(
select person_id , firstEacDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'firstEacDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'First EAC Session Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'First EAC Session Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
group by pid) c on a.person_id = c.pid and a.encounter_id = c.maxdate 
)tFirstEacDate on tVlloadAbove100.person_id = tFirstEacDate.person_id
left join(
select person_id , secondEacDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'secondEacDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Second EAC Session Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Second EAC Session Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
group by pid) c on a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSecondEacDate on tVlloadAbove100.person_id = tSecondEacDate.person_id
left join(
select person_id , thirdEacDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'thirdEacDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Third EAC Session Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Third EAC Session Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
group by pid) c on a.person_id = c.pid and a.encounter_id = c.maxdate 
)tThirdEacDate on tVlloadAbove100.person_id = tThirdEacDate.person_id
left join (
select pid , tConceptname.name as 'adherenceafterEac' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Classification Of Adherence After EAC' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Classification Of Adherence After EAC' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tClassificationOfAdherence on tVlloadAbove100.person_id = tClassificationOfAdherence.pid
left join(
select person_id , repeatViralSampleCollectionDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'repeatViralSampleCollectionDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Repeat Viral,Sample Collection Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Repeat Viral,Sample Collection Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
group by pid) c on a.person_id = c.pid and a.encounter_id = c.maxdate 
)tRvDateOfCollection on tVlloadAbove100.person_id = tRvDateOfCollection.person_id
left join(
select person_id , rvDateOfArrival from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'rvDateOfArrival', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Repeat Viral,Date of Arrival Of Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Repeat Viral,Date of Arrival Of Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
group by pid) c on a.person_id = c.pid and a.encounter_id = c.maxdate 
)tRvDateOfArrival on tVlloadAbove100.person_id = tRvDateOfArrival.person_id
left join(
select person_id , adherencefailure , obs_datetime as 'adherencefailuredate' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'adherencefailure', voided from obs where concept_id = 
(select concept_id from concept_name where name  = "Viral Load Value , Adherence Failure" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = "Viral Load Value , Adherence Failure" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tvlAdherenceFailure on tVlloadAbove100.person_id = tvlAdherenceFailure.person_id
left join (
select pid , tConceptname.name as 'outcomeAfterRepeat' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Repeat Viral,Outcome Action' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Repeat Viral,Outcome Action' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join (
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tOutcomeAfterRepeatVL on tVlloadAbove100.person_id = tOutcomeAfterRepeatVL.pid
left join (
select pid , tConceptname.name as 'mdtHeld' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'MDT Held?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'MDT Held?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join (
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tMdtHeld on tVlloadAbove100.person_id = tMdtHeld.pid 
left join(
select person_id , mdtChangeDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'mdtChangeDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date MDT Held' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date MDT Held' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
group by pid) c on a.person_id = c.pid and a.encounter_id = c.maxdate 
)tMdtChangeDate on tVlloadAbove100.person_id = tMdtChangeDate.person_id
left join (
select distinct(pid), regimenchangedto , date_activated from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'regimenchangedto' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV','2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG')  
order by patient_id, date_activated) b where row_num = 2
)tSubRegimen
)tRegimenSwitchedTo on tRegimenSwitchedTo.pid = tMdtChangeDate.person_id
left join(
select person_id , summary from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_text as 'summary', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Adherence Failure Summary' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Adherence Failure Summary' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
group by pid) c on a.person_id = c.pid and a.encounter_id = c.maxdate 
)tComments on tVlloadAbove100.person_id = tComments.person_id