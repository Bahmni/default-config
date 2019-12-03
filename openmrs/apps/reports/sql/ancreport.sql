select tDemographics.person_id ,tDemographics.fullnames as 'Full Names', tDemographics.UniqueARTs as 'Unique ART' , tDemographics.TelephoneNumber as 'Telephone Number', 
tDemographics.Age, tOccupation.Occupation , tRetestingDate.Retesting as 'HIV Retesting for ART initiation?' ,  tARTStartDate.ARTStartDate as 'ART Start Date',
tLNMPDate.LNMP as 'LNMP' , tEDDDate.EDD as 'EDD' , tGestationPeriod.Gestationalage as 'Gestational age in weeks (GA)', tWeight.weight as 'Weight(Kg)', tMUAC.muac as 'Mid-Upper Arm Circumference (MUAC)',
tTBDiagnosd.TBStatus , tWHOStage.whostage as 'WHO Stage' , tCdfour.cdfour as 'CD4 COUNT', tHivResult.partnerResult as 'Partner Result', tCotrimoxazole.Cotrimoxazole as 'CTX=Contrimoxazole  or DAP=Dapsone',
tBrx.tbrx as 'Date Started TBrx', tbRegNumber.tbRegNo as 'TB Reg No.', tDateVLCollected.dateVLSampleCollected as 'Date VL SampleCollected' , tVLResults.VLResults as 'VL result (Value)', 
tHeiNumber.HeiNumber as 'Unique ART No/HEI No', tOriginaFirstlineRegimen.originalfirstlineregimen as 'Original Firstline Regimen' , tOriginalRegimen.substitutionwithinfirstregimen as ' Substitutions within 1st line ', 
tSwitchedSecondlineRegimen.secondlineregimenchanged as '2nd: Substitution drug code'   from
(
select tART.person_id, tART.FullNames as 'fullnames' , tART.UNIQUEART as 'UniqueARTs' ,tMobile.TelephoneNumber as 'TelephoneNumber' ,
 TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age'from ( select distinct(pn.person_id) as pid ,CONCAT(pn.given_name, ' ', pn.middle_name) as 'FullNames',
 pa.value as 'UNIQUEART',p.birthdate , p.person_id
 from person_name pn 
 left join person p on pn.person_id = p.person_id  
 left join person_attribute pa on p.person_id = pa.person_id
 where p.gender = 'F' 
 and pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo')) tART 
 left join 
 (select * from ( select distinct(pn.person_id) as pid ,CONCAT(pn.given_name, ' ', pn.middle_name), 
 pa.value as 'TelephoneNumber' from person_name pn  left join person p on pn.person_id = p.person_id 
 left join person_attribute pa on p.person_id = pa.person_id
 where p.gender = 'F' and pa.person_attribute_type_id = (select person_attribute_type_id 
 from person_attribute_type where name = 'MobileNumber')) tART ) tMobile on tART.pid = tMobile.pid
 )tDemographics
 inner join
 (
select person_id , concept_id ,value_coded ,date_created from obs 
where concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and date_created between '#startDate#' and '#endDate#'
 )tAncPatients on tDemographics.person_id = tAncPatients.person_id
 left join 
 (
select distinct(person_id) , concept_short_name as 'Occupation' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id
from obs inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Occupation' and concept_name_type = 'Fully_specified') and obs.voided = 0
)tOccupa
)tOccupation on tDemographics.person_id = tOccupation.person_id 
left join 
(
select  obs.person_id,obs.concept_id , obs.value_datetime as 'Dateretested' ,
(case when obs.value_datetime is not null then 'Yes' else 'No' end) as 'Retesting' 
 from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date of HIV Retesting Before ART' and cn.concept_name_type = 'fully_specified' group by obs.person_id
)tRetestingDate on tDemographics.person_id = tRetestingDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'ARTStartDate' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'ANC, ART Start Date' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
) tARTStartDate on tDemographics.person_id = tARTStartDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'LNMP' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date of the first Day of LNMP' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tLNMPDate on tDemographics.person_id = tLNMPDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'EDD' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'EDD' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tEDDDate on tDemographics.person_id = tEDDDate.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_numeric as 'Gestationalage' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Gestation(Weeks)' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tGestationPeriod on tDemographics.person_id = tGestationPeriod.person_id
left join
(
select t1.person_id , t1.concept_id , t1.value_numeric  as 'weight',t1.date_created from obs t1
where t1.date_created = 
(select MAX(t2.date_created) from obs t2 where t2.person_id = t1.person_id and t2.concept_id = 
(select concept_id from concept_name where name = 'weight' and concept_name_type = 'fully_specified')) and t1.concept_id = 
(select concept_id from concept_name where name = 'weight' and concept_name_type = 'fully_specified') 
and t1.date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59') 
)tWeight on tDemographics.person_id = tWeight.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_numeric as 'muac' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'MUAC, Pregnancy Visit' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tMUAC on tDemographics.person_id = tMUAC.person_id
left join (
select obs.person_id,obs.concept_id,
(case when  obs.value_coded = 1 then 'Positive' else 'Negative' end) as 'TBStatus'
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'TB Diagnosed?' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
) tTBDiagnosd on tDemographics.person_id = tTBDiagnosd.person_id 
left join
(
select person_id , concept_short_name as 'whostage' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id
from obs inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'WHO Stage' and concept_name_type = 'Fully_specified') and obs.voided = 0 group by person_id
)tOccupation
)tWHOStage on tDemographics.person_id = tWHOStage.person_id 
left join
(
select t1.person_id , t1.concept_id , t1.value_numeric  as 'cdfour',t1.date_created from obs t1
where t1.date_created = 
(select MAX(t2.date_created) from obs t2 where t2.person_id = t1.person_id and t2.concept_id = 
(select concept_id from concept_name where name = 'CD4' and concept_name_type = 'fully_specified')) and t1.concept_id = 
(select concept_id from concept_name where name = 'CD4' and concept_name_type = 'fully_specified') 
and t1.date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59') 
)tCdfour on tDemographics.person_id = tCdfour.person_id
left join
(
select person_id , concept_short_name as 'partnerResult'
 from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id
from obs inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Result' and concept_name_type = 'Fully_specified') and obs.voided = 0 group by person_id
)tOccupation
)tHivResult on tDemographics.person_id = tHivResult.person_id
LEFT JOIN 
(
select obs.person_id,obs.concept_id,
(case when  obs.value_coded = 1 then 'YES' else 'NO' end) as 'Cotrimoxazole'
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Cotrimoxazole/Dapsone' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
) tCotrimoxazole on tDemographics.person_id = tCotrimoxazole.person_id
left join 
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'tbrx' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date Started TB RX' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tBrx on tDemographics.person_id = tBrx.person_id 
left join
(
select obs.person_id,obs.concept_id , obs.value_text as 'tbRegNo' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'TB Unit Number' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tbRegNumber on tDemographics.person_id = tbRegNumber.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'dateVLSampleCollected' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date VL Sample Collected? ' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tDateVLCollected on tDemographics.person_id = tDateVLCollected.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_numeric as 'VLResults' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'VL Results' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tVLResults on tDemographics.person_id = tVLResults.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_text as 'HeiNumber' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Unique ART No/HEI No' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tHeiNumber on tDemographics.person_id = tHeiNumber.person_id
left join
(
select o.patient_id, o.concept_id  , dr.dosage_form , min(o.date_created) as 'mindate' , cn.name as 'originalfirstlineregimen' from orders  o
left join drug dr on o.concept_id = dr.concept_id
inner join concept_name cn on o.concept_id = cn.concept_id
where cn.name in  ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') and cn.concept_name_type = 'Fully_specified' and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'Fully_specified')
group by o.patient_id having count(o.patient_id) >= 1
)tOriginaFirstlineRegimen on tDemographics.person_id = tOriginaFirstlineRegimen.patient_id
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
)tOriginalRegimen on tDemographics.person_id=  tOriginalRegimen.patient_id 
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
) tSwitchedSecondlineRegimen on tDemographics.person_id = tSwitchedSecondlineRegimen.patient_id
