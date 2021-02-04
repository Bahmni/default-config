select concat(coalesce(given_name,''),' ', coalesce(middle_name,'') ,' ',coalesce(family_name,'') ) as 'Full Names', ancRegistrationDate , results as 'Occupation' , ancNo as 'ANC Number/Surveillance ID', pmtctEntry as 'Entry to PMTCT' , treatmentStatus as 'Treatment Status',
(case when hivRetestingDate is not null then 'Yes' else 'No' end) as 'HIV Retesting for ART initiation?', uartNumber as 'Unique ART No.', artStartDate as 'Date Initiated On ART', Cohort ,Age ,concat("Address : ", (case when Address is null then 'N/A' else mobile end) , "\n", "Mobile : ", mobile) as 'Address',
LNMP , edd as 'EDD' , gestationPeriodWeeks as 'Gestational age in weeks (GA)', weight as 'Weight(Kgs)' , muac as 'Mid-Upper Arm Circumference (MUAC)', TBStatus as 'TB Status', whoResults as 'WHO Stage', cd4 as 'CD4' ,Ctxresults as 'CTX=Contrimoxazole  or DAP=Dapsone' , tbRxDate as 'TB Rx start Date', TbUnitNumber as 'Tb Reg No.',
dateVlCollected as 'Date VL SampleCollected', VlResults as 'VL result (Value)',firstregimen as '1st Line Regimen - Original Regimen', firstsubstitutionregimen as '1st Line Regimen - 1st: Substitution drug code' , secondswitchwithinfirstline as '1st Line Regimen - 2nd: Substitution drug code' , secondlinefirst as '2nd Line Regimen - 2nd Line Regimen switched to',
firstsubstitutionwithinsecond as '2nd Line Regimen - 1st:  Substitution drug code',
secondsubstitutionwithinsecondline as '2nd Line Regimen - 2nd: Substitution drug code', dateOfDelivery as 'Date Of Delivery' , PlaceOfDeliveryresults as 'Place of Delivery', DeliveryOutocomeresults as 'Delivery Outcome', prophylaxisResults as 'Infant Received Prophylaxis?' ,heinumber as 'Exposed Infant Number'
 from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'TypeofPatient') and pa.value  in ((select concept_id from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED'),(select concept_id from concept_name where name = 'ExistingPatient' and concept_name_type = 'FULLY_SPECIFIED'),
(select concept_id from concept_name where name = 'Transfer-In' and concept_name_type = 'FULLY_SPECIFIED')) and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created >= '#startDate#' and  ob.date_created <= (DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')) 
)tDemographics
left join (
select person_id , ancRegistrationDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'ancRegistrationDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'ANC Clinic Registration Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'ANC Clinic Registration Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAncRegistrationDate on tDemographics.personid = tAncRegistrationDate.person_id
left join (
select person_id , results from (
select person_id, occupation from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'occupation', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Occupation' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Occupation' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'results' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.occupation = tConceptname.concept_id
)tResultswithin6Months on tDemographics.personid = tResultswithin6Months.person_id
left join(
select person_id, ancNo from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_text as 'ancNo', voided from obs where concept_id =
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_text is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAncNo on  tDemographics.personid = tAncNo.person_id
left join (
select person_id , results as 'pmtctEntry' from (
select person_id, pmtctEntry from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'pmtctEntry', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Entry to PMTCT' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Entry to PMTCT' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'results' from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tresults.pmtctEntry = tConceptname.concept_id
)tEntryToPmtct on tDemographics.personid = tEntryToPmtct.person_id    
left join (
select person_id , hivRetestingDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'hivRetestingDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHivRetestingDate on tDemographics.personid = tHivRetestingDate.person_id
left join (
select person_id , artStartDate , DATE_FORMAT(artStartDate, '%Y-%m') as 'Cohort' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'artStartDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'ANC, ART Start Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'ANC, ART Start Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tArtStartDate on tDemographics.personid = tArtStartDate.person_id
left join(
select pn.person_id as 'pid', pa.value as 'mobile' from person_name pn
left join person_attribute pa on pn.person_id = pa.person_id where pa.person_attribute_type_id 
=(select person_attribute_type_id from person_attribute_type where name = 'MobileNumber')
)tMobile on tDemographics.personid = tMobile.pid
left join (
select  person_id , concat(coalesce(concat("State: ",address1) , "N/A"), "    " ,coalesce(concat("Boma: ",address4), ""), "     ",coalesce(concat("Village: ",address5) , "")) 
as Address from person_address where preferred = 1
) tpatientAddrress on tDemographics.personid = tpatientAddrress.person_id
left join (
select person_id , LNMP  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'LNMP', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date of the first Day of LNMP' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date of the first Day of LNMP' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tLNMPDate on tDemographics.personid = tLNMPDate .person_id
left join (
select person_id , edd  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'edd', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tEDDDate on tDemographics.personid = tEDDDate.person_id
left join(
select person_id , gestationPeriodWeeks  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'gestationPeriodWeeks', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Gestation(Weeks)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Gestation(Weeks)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tGestationWeeks on tDemographics.personid = tGestationWeeks.person_id
left join(
select person_id , weight  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'weight', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'weight' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'weight' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tWeight on tDemographics.personid = tWeight.person_id
left join(
select person_id , muac  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'muac', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'MUAC, Pregnancy Visit' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'MUAC, Pregnancy Visit' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tMuac on tDemographics.personid = tMuac.person_id
left join (
select person_id , (case when  tbResults = 1 then 'Positive' else 'Negative' end) as 'TBStatus' from (
select person_id, tbDiaognised from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbDiaognised', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Diagnosed?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Diagnosed?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'tbResults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.tbDiaognised = tConceptname.concept_id
)tTBStatus on tDemographics.personid = tTBStatus.person_id
left join (
select person_id , whoResults from (
select person_id, whoStage from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'whoStage', voided from obs where concept_id =
(select concept_id from concept_name where name = 'WHO Stage' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'WHO Stage' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'whoResults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.whoStage = tConceptname.concept_id
)tWHOStage on tDemographics.personid = tWHOStage.person_id
left join(
select person_id , cd4  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'cd4', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCd4 on tDemographics.personid = tCd4.person_id
left join (
select person_id , tbRxDate  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'tbRxDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Started TB RX' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Started TB RX' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTbRxDate on tDemographics.personid = tTbRxDate.person_id
left join (
select person_id , TbUnitNumber  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_text as 'TbUnitNumber', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'TB Unit Number' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'TB Unit Number' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTbUnitNumber on tDemographics.personid = tTbUnitNumber.person_id
left join (
select person_id ,  (case when Ctxresults = 'True' then 'Yes' else 'No' end) as 'Ctxresults' from (
select person_id, ctxDapson from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'ctxDapson', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'Ctxresults' from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tresults.ctxDapson = tConceptname.concept_id
)tCtxDapsone on tDemographics.personid = tCtxDapsone.person_id
left join (
select person_id , dateVlCollected  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'dateVlCollected', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date VL Sample Collected?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date VL Sample Collected?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateVlCollected on tDemographics.personid = tDateVlCollected.person_id
left join (
select person_id , VlResults  from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'VlResults', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tVlResults on tDemographics.personid = tVlResults.person_id
left join(
select distinct(pid), firstregimen from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'firstregimen' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 1
)tfirstlinereg
)tfirstlineregimen on tDemographics.personid =  tfirstlineregimen.pid 
left join (
select distinct(pid), firstsubstitutionregimen from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'firstsubstitutionregimen' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 2
)tSubRegimen
)tFirstSubstitituionregime on tDemographics.personid =  tFirstSubstitituionregime.pid 
left join (
select distinct(pid), secondswitchwithinfirstline from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'secondswitchwithinfirstline' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 3
)tsecoondfirstswithc
)tSecondSubstitutionfirstline on tDemographics.personid =  tSecondSubstitutionfirstline.pid
 left join (
 select distinct(pid), secondlinefirst from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'secondlinefirst' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG')
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 1
)secondlinefirst
)tSecondlineoriginal on tDemographics.personid =  tSecondlineoriginal.pid
left join (
select distinct(pid), firstsubstitutionwithinsecond from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'firstsubstitutionwithinsecond' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG')
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 2
)firstsubstitutionwithinsecond
)tfirstsubstitutionwithinsecondline on tDemographics.personid =  tfirstsubstitutionwithinsecondline.pid
left join (
select distinct(pid), secondsubstitutionwithinsecondline from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'secondsubstitutionwithinsecondline' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG')
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 3
)secondsubstitutionwithinsecondline
)tsecondsubstitutionwithinsecondline on tDemographics.personid =  tsecondsubstitutionwithinsecondline.pid
left join (
select person_id , dateOfDelivery from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'dateOfDelivery', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Post Natal,Date Of Delivery' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Post Natal,Date Of Delivery' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateOfDelivery on tDemographics.personid = tDateOfDelivery.person_id
left join (
select person_id , PlaceOfDeliveryresults from (
select person_id, placeOfDelivery from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'placeOfDelivery', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Post Natal ,Place Delivery' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Post Natal ,Place Delivery' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'PlaceOfDeliveryresults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.placeOfDelivery = tConceptname.concept_id
)tPlaceOfDelivery on tDemographics.personid = tPlaceOfDelivery.person_id
left join (
select person_id , DeliveryOutocomeresults from (
select person_id, deliveryOutcome from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'deliveryOutcome', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card, Delivery Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card, Delivery Outcome' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'DeliveryOutocomeresults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.deliveryOutcome = tConceptname.concept_id
)tDeliveryOutcome on tDemographics.personid = tDeliveryOutcome.person_id
left join (
select person_id , (case when ProphylaxisResults = 'True' then 'Yes' else 'No' end) as 'prophylaxisResults' from (
select person_id, receivedProphylaxis from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'receivedProphylaxis', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Infant Received ARV Prophylaxis at Birth' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Infant Received ARV Prophylaxis at Birth' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'ProphylaxisResults' from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tresults.receivedProphylaxis = tConceptname.concept_id
)tIsProhylaxisStarted on tDemographics.personid = tIsProhylaxisStarted.person_id
left join (
select mother_id, eid , heinumber from (
select person_b as 'mother_id' , relationship , person_a as 'hei_id' from relationship where 
relationship = (select relationship_type_id from relationship_type where a_is_to_b = 'Mother' and retired = 0) and voided = 0
)heiRelationship
left join(
select pa.person_id as 'eid', pa.value as 'heinumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'HIVExposedInfant(HEI)No') and gender is not null
)tHeiDemographics on heiRelationship.hei_id = tHeiDemographics.eid
)tHeiNumber on tDemographics.personid = tHeiNumber.mother_id
left join (
select person_id , (select name from concept_name where concept_id = value and concept_name_type = 'SHORT') as 'treatmentStatus' from person_attribute where person_attribute_type_id = 
(select person_attribute_type_id from person_attribute_type where name = 'TransferInTreatmentStatus')
)tUniqueARTNumber on  tDemographics.personid  = tUniqueARTNumber.person_id
left join (
select person_id , value as 'uartNumber' from person_attribute where person_attribute_type_id = 
(select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo')
)tUniqueArtNumber on tDemographics.personid = tUniqueArtNumber.person_id