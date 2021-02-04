select tDateRegisteredToANC.Date_Registered_into_ANC as 'Date Registered into ANC', concat(coalesce(given_name,''),' ', coalesce(middle_name,'') ,' ',coalesce(family_name,'') ) as 'Full Names',  tOccupation.Occupation ,tANCNumber.ANC_Number as 'ANC Number/Surveillance ID' ,tEntryTopmtct.Entry_to_PMTCT as 'Entry to PMTCT' , tTreatmentStatus.treatment_status as 'Treatment status',
tRetestingDate.Retesting as 'HIV Retesting for ART initiation?' ,value as 'Unique ART No.' ,tARTStartDate.ARTStartDate as 'Date Initiated On ART', tCohort.Cohort as 'Cohort Months' ,tUniqueART.Age as 'Age' , concat(tpatientAddrress.Address," ","\n",concat("Mobile Number: ",tMobileNumber.mobile)) as 'Address',
tLNMPDate.LNMP as 'LNMP' , tEDDDate.EDD as 'EDD' , tGestationPeriod.Gestationalage as 'Gestational age in weeks (GA)', tWeight.weight as 'Weight(Kg)', tMUAC.muac as 'Mid-Upper Arm Circumference (MUAC)',
tTBDiagnosd.TBStatus , tWHOStage.whostage as 'WHO Stage' , tCdfour.cdfour as 'CD4 COUNT', tHivResult.partnerResult as 'Partner Result', tCotrimoxazole.Cotrimoxazole as 'CTX=Contrimoxazole  or DAP=Dapsone',
tBrx.tbrx as 'TB Rx start', tbRegNumber.tbRegNo as 'TB Reg No.', tDateVLCollected.dateVLSampleCollected as 'Date VL SampleCollected' , tVLResults.VLResults as 'VL result (Value)', 
firstregimen as '1st Line Regimen - Original Regimen', firstsubstitutionregimen as '1st Line Regimen - 1st: Substitution drug code' , secondswitchwithinfirstline as '1st Line Regimen - 2nd: Substitution drug code' , secondlinefirst as '2nd Line Regimen - 2nd Line Regimen switched to',
firstsubstitutionwithinsecond as '2nd Line Regimen - 1st:  Substitution drug code',
secondsubstitutionwithinsecondline as '2nd Line Regimen - 2nd: Substitution drug code' , 
tDateOfDelivery.Date_Of_Delivery as 'Date Of Delivery', tplaceofDelivery.place_of_delivery as 'Place of Delivery',
tdeliveryoutcome.delivery_outcome as 'Delivery Outcome' , tInfantReceivedProphylaxis.InfantReceivedProphylaxis as 'Infant Received Prophylaxis?' ,  tHeiNumber.HeiNumber as 'Exposed Infant Number'
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
and ob.date_created >= '#startDate#' and  ob.date_created <= (DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')) 
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
where cn.name = 'ANC Clinic Registration Date' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tDateRegisteredToANC on tUniqueART.personid = tDateRegisteredToANC.person_id
left join 
(
select obs.person_id,obs.concept_id , TIMESTAMPDIFF(MONTH,obs.value_datetime , curdate()) as 'Cohort'
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'ANC, ART Start Date' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tCohort on tUniqueART.personid = tCohort.person_id 
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
and t1.date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59') 
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
and t1.date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59') 
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
where cn.name = 'Date VL Sample Collected?' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
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
left join (
select  person_id , concat(coalesce(concat("State: ",address1) , "N/A"), "    " ,coalesce(concat("Boma: ",address4), ""), "     ",coalesce(concat("Village: ",address5) , "")) 
as Address from person_address where preferred = 1
) tpatientAddrress on tUniqueART.personid = tpatientAddrress.person_id
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
)tfirstlineregimen on tUniqueART.personid =  tfirstlineregimen.pid 
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
)tFirstSubstitituionregime on tUniqueART.personid =  tFirstSubstitituionregime.pid 
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
)tSecondSubstitutionfirstline on tUniqueART.personid =  tSecondSubstitutionfirstline.pid
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
)tSecondlineoriginal on tUniqueART.personid =  tSecondlineoriginal.pid
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
)tfirstsubstitutionwithinsecondline on tUniqueART.personid =  tfirstsubstitutionwithinsecondline.pid
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
)tsecondsubstitutionwithinsecondline on tUniqueART.personid =  tsecondsubstitutionwithinsecondline.pid

