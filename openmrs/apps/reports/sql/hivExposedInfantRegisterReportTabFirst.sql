
select @a:=@a+1 as 'Serial Number',  enrollmentdateatart as 'Date of enrolment', HEI_Number as 'Exposed Infant Number' , ClientName as "Infant's Name", birthdate as 'Date of Birth' , Age ,  sex as 'Sex (M/F)', 
Clinic_Referred_from as 'Clinic Referred from', arvProphylaxisStartageMonths as 'Age at ARV prophylaxis Initiation (Months)', ctxStartAgeMonth as 'Age at Cotrimaxazole initiation (months)', firstpcrdate , 
 mothersname as "Mother/Caregiver's  Name" , telephonenumber as "Mother/Caregiver's : Telephone number", motherancnumber as "Mother’s ANC No" , artnumber as 'Mother ART Number' ,
 artRegimenDuringPregnancy as "Mother’s ART for PMTCT - Antenatal ", artRegimenduringDelivery as "Mother’s ART for PMTCT - Delivery",
arvMotherDishargedwith as "Mother’s ART for PMTCT - Post natal", infantriskstatus as "Infant's risk status (Low or High)" , (case when infantpmtctArvs = 'Daily NVP' then 1 when infantpmtctArvs = 'AZT+NVP' then 0  else 'N/A' end) as 'Infant’s ARVs for PMTCT: (1=NVP; 2=NVP+AZT; 3=None)',
firstPcrTestDate as 'Initial Sample - Date', pcrRepeatTest as 'Repeat - Date' , datefirstpcrresultreceived as '1st DNA PCR Test:\nDate DBS was collected', ageFirstDBSMonths as "Age at 1st DBS (Weeks/Month)",firstfeedingmethodMethod as "1st DNA PCR Test:\nInfant Feeding Status" ,
firstPcrResults as '1st DNA PCR Test:\nTest Result' , datefirstpcrresultreceived as '1st DNA PCR Test:\nDate result Received' , dateResultGivenToCaregiver as '1st DNA PCR Test:\nDate result given to caregiver'
from (
select person_id as pid , (SELECT @a:= 0) AS a ,enrollmentdateatart  from (
select  person_id, concept_id, value_datetime as 'enrollmentdateatart' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEnrollementDate
inner join(
select pa.person_id , pa.value as 'HEI_Number' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , p.birthdate
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'HIVExposedInfant(HEI)No')
and floor(datediff('#endDate#',p.birthdate) / 365) < 2
)HeiDemographics on tEnrollementDate.pid = HeiDemographics.person_id
left join (
select * from (
select  person_id, concept_id, value_datetime as 'firstpcrdate' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tFirstPcrDate on tEnrollementDate.pid = tFirstPcrDate.person_id
left join (
select * from (
select  person_id, concept_id, value_datetime as 'datefirstpcrresultreceived' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'First PCR,Date results received' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'First PCR,Date results received' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDatefirstpcrresultreceived on tEnrollementDate.pid = tDatefirstpcrresultreceived.person_id
left join (
select pid , tConceptname.name as 'Clinic_Referred_from' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Entry Point(Enrollement)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Entry Point(Enrollement)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tEntryPoint on tEnrollementDate.pid = tEntryPoint.pid
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'arvProphylaxisStartageMonths',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'ARV prophylaxis Initiation Age (Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ARV prophylaxis Initiation Age (Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime
  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tArvProphylaxisStartAge on tEnrollementDate.pid = tArvProphylaxisStartAge.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'ctxStartAgeMonth',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Cotrimoxazole initiation Age(Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Cotrimoxazole initiation Age(Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime
  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCtxStartAgeMonth on tEnrollementDate.pid = tCtxStartAgeMonth.person_id
left join (
select * from (
select distinct(person_b) as 'mother_id' , relationship , person_a as 'hei_id' from relationship where 
relationship = (select relationship_type_id from relationship_type where a_is_to_b = 'Mother' and retired = 0) and voided = 0
)tHeiToMotherRelationship
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'mothersname', 
 floor(datediff(curdate(),p.birthdate) / 365) as 'Mother_Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender = 'F' and gender is not null
)tDemographics on tHeiToMotherRelationship.mother_id = tDemographics.person_id
)tMothersDemographics on tEnrollementDate.pid = tMothersDemographics.hei_id
left join (
select pa.person_id , pa.value as 'telephonenumber' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'MobileNumber')
)tMothersTel on tMothersDemographics.person_id = tMothersTel.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_text as 'motherancnumber',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime
  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tMotherAnc on tMothersDemographics.mother_id = tMotherAnc.person_id
left join(
select pid , tConceptname.name as 'artRegimenDuringPregnancy' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card, ART Regimen During Pregnacy' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card, ART Regimen During Pregnacy' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tArtRegimenDuringPregnancy on tMothersDemographics.mother_id = tArtRegimenDuringPregnancy.pid
left join(
select pid , tConceptname.name as 'artRegimenduringDelivery' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card, ART Regimen During Delivery' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card, ART Regimen During Delivery' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tArtRegimenDuringDelivery on tMothersDemographics.mother_id = tArtRegimenDuringDelivery.pid
left join (
select pid , tConceptname.name as 'arvMotherDishargedwith' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'ARV Mother Discharged With' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ARV Mother Discharged With' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tarvMotherDishargedwith on tMothersDemographics.mother_id = tarvMotherDishargedwith.pid
left join(
select pid , tConceptname.name as 'infantriskstatus' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = "Infant's Risk Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = "Infant's Risk Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tInfantsRiskstatus on tEnrollementDate.pid = tInfantsRiskstatus.pid
left join (
select pid , tConceptname.name as 'infantpmtctArvs' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = "Infant's PMTCT ARVS" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = "Infant's PMTCT ARVS" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tInfantsPmtctArvs on tEnrollementDate.pid = tInfantsPmtctArvs.pid
left join ( 
select person_id as pid , firstPcrTestDate  from (
select  person_id, concept_id, value_datetime as 'firstPcrTestDate' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tFirstPCRTestDate on tEnrollementDate.pid = tFirstPCRTestDate.pid
left join (
select person_id as pid , pcrRepeatTest  from (
select  person_id, concept_id, value_datetime as 'pcrRepeatTest' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (Repeat PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (Repeat PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tRepeatPCRDate on tEnrollementDate.pid = tRepeatPCRDate.pid
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'ageFirstDBSMonths',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Age at 1st DBS(Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Age at 1st DBS(Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime
  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAgeAtFirstDBSMoths on tEnrollementDate.pid = tAgeAtFirstDBSMoths.person_id
left join(
select pid , tConceptname.name as 'firstfeedingmethodMethod' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tInfantFeedingStatusFirstPCR on tEnrollementDate.pid = tInfantFeedingStatusFirstPCR.pid
left join (
select pid , tConceptname.name as 'firstPcrResults' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tFirstPcrResults on tEnrollementDate.pid = tFirstPcrResults.pid
left join (
select * from (
select  person_id, concept_id, value_datetime as 'dateResultGivenToCaregiver' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Date Result Given to Caregiver)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Date Result Given to Caregiver)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateResultsGivenToCareGiver on tEnrollementDate.pid = tDateResultsGivenToCareGiver.person_id