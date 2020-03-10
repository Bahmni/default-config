
select tDateRegisteredToANC.Date_Registered_into_ANC as 'Date Registered into ANC', concat(coalesce(given_name,''),' ', coalesce(middle_name,'') ,' ',coalesce(family_name,'') ) as 'Full Names',  tOccupation.Occupation ,tANCNumber.ANC_Number as 'ANC Number/Surveillance ID' ,tEntryTopmtct.Entry_to_PMTCT as 'Entry to PMTCT' , tTreatmentStatus.treatment_status as 'Treatment status',
tRetestingDate.Retesting as 'HIV Retesting for ART initiation?' ,value as 'Unique ART No.' ,tARTStartDate.ARTStartDate as 'ART Start Date', tUniqueART.Age as 'Age' , tMobileNumber.mobile as 'Telephone Number' ,
tLNMPDate.LNMP as 'LNMP' , tEDDDate.EDD as 'EDD' , tGestationPeriod.Gestationalage as 'Gestational age in weeks (GA)', tWeight.weight as 'Weight(Kg)', tMUAC.muac as 'Mid-Upper Arm Circumference (MUAC)',
tTBDiagnosd.TBStatus , tWHOStage.whostage as 'WHO Stage' , tCdfour.cdfour as 'CD4 COUNT', tHivResult.partnerResult as 'Partner Result', tCotrimoxazole.Cotrimoxazole as 'CTX=Contrimoxazole  or DAP=Dapsone',
tBrx.tbrx as 'Date Started TBrx', tbRegNumber.tbRegNo as 'TB Reg No.', tDateVLCollected.dateVLSampleCollected as 'Date VL SampleCollected' , tVLResults.VLResults as 'VL result (Value)', 
tHeiNumber.HeiNumber as 'Exposed Infant Number', tOriginaFirstlineRegimen.originalfirstlineregimen as 'Original Firstline Regimen' , tFirstlineRegimenswitchedto.originalfirstlineregimen as 'Substitutions within 1st line', 
tSecondlineOriginalRegimen.originalSecondline as '2nd line regimen switched', tSwitchedSecondlineRegimen.secondlineregimenchanged as '2nd: Substitution drug code', tDateOfDelivery.Date_Of_Delivery as 'Date Of Delivery', tplaceofDelivery.place_of_delivery as 'Place of Delivery',
tdeliveryoutcome.delivery_outcome as 'Delivery Outcome' , tInfantReceivedProphylaxis.InfantReceivedProphylaxis as 'Infant Received Prophylaxis?'
 from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created between '#startDate#' and '#endDate#'
)tUniqueART
left join(
select pid , mobile from (
select pn.person_id as 'pid', pn.given_name, pn.middle_name, pa.value as 'mobile' from person_name pn
left join person_attribute pa on pn.person_id = pa.person_id where pa.person_attribute_type_id 
=(select person_attribute_type_id from person_attribute_type where name = 'MobileNumber')
)tMobile 
)tMobileNumber on tUniqueART.personid = tMobileNumber.pid
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'Date_Registered_into_ANC' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date Transferred in' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tDateRegisteredToANC on tUniqueART.personid = tDateRegisteredToANC.person_id
left join
(
select distinct(person_id) , concept_short_name as 'Occupation' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) b on obs.person_id = b.person_id and obs.encounter_id = b.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Occupation' and concept_name_type = 'Fully_specified') and obs.voided = 0
)tOccupa
)tOccupation on tUniqueART.personid = tOccupation.person_id 
left join(
select obs.person_id,obs.concept_id , obs.value_text as 'ANC_Number' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'ANC No' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
) tANCNumber on tUniqueART.personid = tANCNumber.person_id 
left join 
(
select  obs.person_id,obs.concept_id , obs.value_datetime as 'Dateretested' ,
(case when obs.value_datetime is not null then 'Yes' else 'No' end) as 'Retesting' 
 from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date of HIV Retesting Before ART' and cn.concept_name_type = 'fully_specified' group by obs.person_id
)tRetestingDate on tUniqueART.personid = tRetestingDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'ARTStartDate' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'ANC, ART Start Date' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
) tARTStartDate on tUniqueART.personid = tARTStartDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'LNMP' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date of the first Day of LNMP' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tLNMPDate on tUniqueART.personid = tLNMPDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'EDD' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'EDD' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tEDDDate on tUniqueART.personid = tEDDDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_numeric as 'Gestationalage' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Gestation(Weeks)' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tGestationPeriod on tUniqueART.personid = tGestationPeriod.person_id 
left join
(
select t1.person_id , t1.concept_id , t1.value_numeric  as 'weight',t1.date_created from obs t1
where t1.date_created = 
(select MAX(t2.date_created) from obs t2 where t2.person_id = t1.person_id and t2.concept_id = 
(select concept_id from concept_name where name = 'weight' and concept_name_type = 'fully_specified')) and t1.concept_id = 
(select concept_id from concept_name where name = 'weight' and concept_name_type = 'fully_specified') 
and t1.date_created between DATE_FORMAT('2019-03-10','%Y-%m-01') and DATE_FORMAT(LAST_DAY('2020-03-10'),'%Y-%m-%d 23:59:59') 
)tWeight on tUniqueART.personid = tWeight.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_numeric as 'muac' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'MUAC, Pregnancy Visit' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tMUAC on tUniqueART.personid = tMUAC.person_id
left join (
select obs.person_id,obs.concept_id,
(case when  obs.value_coded = 1 then 'Positive' else 'Negative' end) as 'TBStatus'
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'TB Diagnosed?' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
) tTBDiagnosd on tUniqueART.personid = tTBDiagnosd.person_id 
left join
(
select person_id , concept_short_name as 'whostage' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id
from obs inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'WHO Stage' and concept_name_type = 'Fully_specified') and obs.voided = 0 group by person_id
)tOccupation
)tWHOStage on tUniqueART.personid = tWHOStage.person_id 
left join
(
select t1.person_id , t1.concept_id , t1.value_numeric  as 'cdfour',t1.date_created from obs t1
where t1.date_created = 
(select MAX(t2.date_created) from obs t2 where t2.person_id = t1.person_id and t2.concept_id = 
(select concept_id from concept_name where name = 'CD4' and concept_name_type = 'fully_specified')) and t1.concept_id = 
(select concept_id from concept_name where name = 'CD4' and concept_name_type = 'fully_specified') 
and t1.date_created between DATE_FORMAT('2019-03-10','%Y-%m-01') and DATE_FORMAT(LAST_DAY('2020-03-10'),'%Y-%m-%d 23:59:59') 
)tCdfour on tUniqueART.personid = tCdfour.person_id
left join
(
select person_id , concept_short_name as 'partnerResult'
 from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id
from obs inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Result' and concept_name_type = 'Fully_specified') and obs.voided = 0 group by person_id
)tOccupation
)tHivResult on tUniqueART.personid = tHivResult.person_id
LEFT JOIN 
(
select obs.person_id,obs.concept_id,
(case when  obs.value_coded = 1 then 'YES' else 'NO' end) as 'Cotrimoxazole'
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Cotrimoxazole/Dapsone' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
) tCotrimoxazole on tUniqueART.personid = tCotrimoxazole.person_id
left join 
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'tbrx' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date Started TB RX' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tBrx on tUniqueART.personid = tBrx.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_text as 'tbRegNo' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'TB Unit Number' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tbRegNumber on tUniqueART.personid = tbRegNumber.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'dateVLSampleCollected' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date VL Sample Collected? ' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tDateVLCollected on tUniqueART.personid = tDateVLCollected.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_numeric as 'VLResults' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'VL Results' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tVLResults on tUniqueART.personid = tVLResults.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_text as 'HeiNumber' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Unique ART No/HEI No' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tHeiNumber on tUniqueART.personid = tHeiNumber.person_id
left join(
select obs.person_id,obs.concept_id , obs.value_datetime as 'Date_Of_Delivery' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Post Natal,Date Of Delivery' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tDateOfDelivery on tUniqueART.personid = tDateOfDelivery.person_id
left join
(
select distinct(person_id) , concept_short_name as 'place_of_delivery' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) b on obs.person_id = b.person_id and obs.encounter_id = b.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Post Natal ,Place Delivery' and concept_name_type = 'Fully_specified') and obs.voided = 0
)placeofDelivery
)tplaceofDelivery on tUniqueART.personid = tplaceofDelivery.person_id
left join
(
select distinct(person_id) , concept_short_name as 'delivery_outcome' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) b on obs.person_id = b.person_id and obs.encounter_id = b.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Maternity card, Delivery Outcome' and concept_name_type = 'Fully_specified') and obs.voided = 0
)deliveryoutcome
)tdeliveryoutcome on tUniqueART.personid = tdeliveryoutcome.person_id
left join(
select distinct(person_id), 
(case when value_coded = 1 then 'Yes' else 'No' end) as 'InfantReceivedProphylaxis'
from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) b on obs.person_id = b.person_id and obs.encounter_id = b.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Infant Received ARV Prophylaxis at Birth' and concept_name_type = 'Fully_specified') and obs.voided = 0
)infantReceivedProphylaxis 
)tInfantReceivedProphylaxis on tUniqueART.personid = tInfantReceivedProphylaxis.person_id
left join
(
select pid , originalfirstlineregimen  from (
select o.patient_id as pid, o.concept_id  , o.encounter_id, dr.dosage_form  , cn.name as 'originalfirstlineregimen' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and cn.concept_name_type = 'Fully_specified' 
and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
) firstline
inner join (select patient_id , concept_id , max(encounter_id) maxencounter from orders group by patient_id) b on firstline.pid = b.patient_id and firstline.encounter_id = b.maxencounter
)tFirstlineRegimenswitchedto on tUniqueART.personid = tFirstlineRegimenswitchedto.pid
left join 
(
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' , cn.name as 'originalSecondline' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) >= 1
)tSecondlineOriginalRegimen on tUniqueART.personid = tSecondlineOriginalRegimen.patient_id
left join(
select distinct(person_id) , concept_short_name as 'treatment_status' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) b on obs.person_id = b.person_id and obs.encounter_id = b.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Treatment Status' and concept_name_type = 'Fully_specified') and obs.voided = 0
)treatmentStatus
)tTreatmentStatus on tUniqueART.personid = tTreatmentStatus.person_id
left join(
select distinct(person_id) , concept_short_name as 'Entry_to_PMTCT' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) b on obs.person_id = b.person_id and obs.encounter_id = b.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Entry to PMTCT' and concept_name_type = 'Fully_specified') and obs.voided = 0
)entryTopmtct
)tEntryTopmtct on tUniqueART.personid = tEntryTopmtct.person_id
left join 
(
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' , cn.name as 'originalfirstlineregimen' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) >= 1
)tOriginaFirstlineRegimen on tUniqueART.personid = tOriginaFirstlineRegimen.patient_id
left join
(
select ts.patient_id , ts.name as 'substitutionwithinfirstregimen' from (
select o.patient_id, o.concept_id  , dr.dosage_form  , cn.name , max(o.date_created)
from  orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and cn.concept_name_type = 'Fully_specified' and
 dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
 group by o.patient_id having count(o.patient_id)> 1
 ) tt
 left join
 (
 select o.patient_id , o.concept_id ,o.date_created , cn.name from orders o
 left join drug dr on o.concept_id = dr.concept_id
 left join concept_name cn on o.concept_id = cn.concept_id
 inner join (select patient_id, concept_id , max(date_created) maxdate from orders group by patient_id ) b on o.patient_id = b.patient_id and o.date_created = b.maxdate
 where dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified') 
 and cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and cn.concept_name_type = 'Fully_specified'
) ts on tt.patient_id = ts.patient_id 
)tOriginalRegimen on tUniqueART.personid=  tOriginalRegimen.patient_id 
left join
(
select tst.patient_id , tst.name as 'secondlineregimenchanged' from (
select o.patient_id, o.concept_id  , dr.dosage_form  , cn.name , max(o.date_created)
from  orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and cn.concept_name_type = 'Fully_specified' and
 dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
 group by o.patient_id having count(o.patient_id) > 0
 ) tt
 left join
 (
 select o.patient_id , o.concept_id ,o.date_created , cn.name from orders o
 left join drug dr on o.concept_id = dr.concept_id
 left join concept_name cn on o.concept_id = cn.concept_id
 inner join (select patient_id, concept_id , max(date_created) maxdate from orders group by patient_id ) b on o.patient_id = b.patient_id and o.date_created = b.maxdate
 where dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified') 
 and cn.name in  ('2a=AZT/3TC+DTG' , '2b=ABC/3TC+DTG', '2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r', '2h=AZT/3TC+ATV/r','2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG')
and cn.concept_name_type = 'Fully_specified'
) tst on tt.patient_id = tst.patient_id 
) tSwitchedSecondlineRegimen on tUniqueART.personid = tSwitchedSecondlineRegimen.patient_id







