
select tDemographics.fullnames as 'Full Names', tDemographics.UniqueARTs as 'Unique ART' , tDemographics.TelephoneNumber as 'Telephone Number', 
tDemographics.Age, tOccupation.Occupation , tRetestingDate.Retesting as 'HIV Retesting for ART initiation?' ,  tARTStartDate.ARTStartDate as 'ART Start Date',
tLNMPDate.LNMP as 'LNMP' , tEDDDate.EDD as 'EDD' , tGestationPeriod.Gestationalage as 'Gestational age in weeks (GA)', tWeight.weight as 'Weight(Kg)', tMUAC.muac as 'Mid-Upper Arm Circumference (MUAC)',
tTBDiagnosd.TBStatus , tWHOStage.whostage as 'WHO Stage' , tCdfour.cdfour as 'CD4 COUNT', tHivResult.partnerResult as 'Partner Result', tCotrimoxazole.Cotrimoxazole as 'CTX=Contrimoxazole  or DAP=Dapsone',
tBrx.tbrx as 'Date Started TBrx', tbRegNumber.tbRegNo as 'TB Reg No.', tDateVLCollected.dateVLSampleCollected as 'Date VL SampleCollected' , tVLResults.VLResults as 'VL result (Value)', 
tHeiNumber.HeiNumber as 'Unique ART No/HEI No', tOriginaFirstlineRegimen.originalfirstlineregimen as 'Original Firstline Regimen' , tOriginalRegimen.substitutionwithinfirstregimen as ' Substitutions within 1st line ', 
tSwitchedSecondlineRegimen.secondlineregimenchanged as '2nd: Substitution drug code', concat('weight(kgs)',"\n",'---------------',"\n",'   CD4/VL') as month3,
concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month4) as '4',concat(tttweight.weightMonth5,"\n",'------',"\n",' ',ttcd44.cd4month5) as '5',
concat(tttweight.weightMonth6,"\n",'------',"\n",' ',ttcd44.cd4month6) as '6',concat(tttweight.weightMonth7,"\n",'------',"\n",' ',ttcd44.cd4month7) as '7',
concat(tttweight.weightMonth8,"\n",'------',"\n",' ',ttcd44.cd4month8) as '8',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month9) as '9',
concat(tttweight.weightMonth10,"\n",'------',"\n",' ',ttcd44.cd4month10) as '10',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month11) as '11',
concat(tttweight.weightMonth12,"\n",'------',"\n",' ',ttcd44.cd4month12) as '12',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month13) as '13',
concat(tttweight.weightMonth14,"\n",'------',"\n",' ',ttcd44.cd4month14) as '14',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month15) as '15',
concat(tttweight.weightMonth16,"\n",'------',"\n",' ',ttcd44.cd4month16) as '16',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month17) as '17',
concat(tttweight.weightMonth18,"\n",'------',"\n",' ',ttcd44.cd4month18) as '18',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month19) as '19',
concat(tttweight.weightMonth20,"\n",'------',"\n",' ',ttcd44.cd4month20) as '20',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month21) as '21',
concat(tttweight.weightMonth22,"\n",'------',"\n",' ',ttcd44.cd4month22) as '22',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month23) as '23',
concat(tttweight.weightMonth24,"\n",'------',"\n",' ',ttcd44.cd4month24) as '24',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month25) as '25',
concat(tttweight.weightMonth26,"\n",'------',"\n",' ',ttcd44.cd4month26) as '26',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month27) as '27',
concat(tttweight.weightMonth28,"\n",'------',"\n",' ',ttcd44.cd4month28) as '28',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month29) as '29',
concat(tttweight.weightMonth30,"\n",'------',"\n",' ',ttcd44.cd4month30) as '30',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month31) as '31',
concat(tttweight.weightMonth32,"\n",'------',"\n",' ',ttcd44.cd4month32) as '32',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month33) as '33',
concat(tttweight.weightMonth34,"\n",'------',"\n",' ',ttcd44.cd4month34) as '34',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month35) as '35',
concat(tttweight.weightMonth36,"\n",'------',"\n",' ',ttcd44.cd4month34) as '36',concat(tttweight.weightMonth4,"\n",'------',"\n",' ',ttcd44.cd4month34) as '37',
concat(tttweight.weightMonth38,"\n",'------',"\n",' ',ttcd44.cd4month34) as '38'
from (
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
left join 
(
select * from (
select tcd4month0.person_id , month0,cd4month4 ,cd4month5 ,cd4month6 ,cd4month7 ,cd4month8,cd4month9,cd4month10,cd4month11,cd4month12,
cd4month13 ,cd4month14 ,cd4month15 ,cd4month16,cd4month17,cd4month18,cd4month19,cd4month20,cd4month21 ,cd4month22 ,cd4month23 ,
cd4month24,cd4month25,cd4month26,cd4month27,cd4month28 ,cd4month29,cd4month30,cd4month31,cd4month32,cd4month33,cd4month34,cd4month35 from (
select person_id, 
(case when date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then value_numeric else 0 end) as 'month0'
from obs where  concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') group by person_id
)tcd4month0
left join (
select person_id, value_numeric as 'cd4month4'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 4 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 4 MONTH)  group by person_id
)ttcd4month4 on tcd4month0.person_id = ttcd4month4.person_id
left join (
select person_id, value_numeric as 'cd4month5'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 5 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 5 MONTH)  group by person_id
)ttcd4month5 on tcd4month0.person_id = ttcd4month5.person_id
left join (
select person_id, value_numeric as 'cd4month6'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 6 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 6 MONTH)  group by person_id
)ttcd4month6 on tcd4month0.person_id = ttcd4month6.person_id
left join (
select person_id, value_numeric as 'cd4month7'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 7 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 7 MONTH)  group by person_id
)ttcd4month7 on tcd4month0.person_id = ttcd4month7.person_id
left join (
select person_id, value_numeric as 'cd4month8'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 8 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 8 MONTH)  group by person_id
)ttcd4month8 on tcd4month0.person_id = ttcd4month8.person_id
left join (
select person_id, value_numeric as 'cd4month9'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 9 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 9 MONTH)  group by person_id
)ttcd4month9 on tcd4month0.person_id = ttcd4month9.person_id
left join (
select person_id, value_numeric as 'cd4month10'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 10 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 10 MONTH)  group by person_id
)ttcd4month10 on tcd4month0.person_id = ttcd4month10.person_id
left join (
select person_id, value_numeric as 'cd4month11'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 11 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 11 MONTH)  group by person_id
)ttcd4month11 on tcd4month0.person_id = ttcd4month11.person_id
left join (
select person_id, value_numeric as 'cd4month12'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 12 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 12 MONTH)  group by person_id
)ttcd4month12 on tcd4month0.person_id = ttcd4month12.person_id
left join (
select person_id, value_numeric as 'cd4month13'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 13 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 13 MONTH)  group by person_id
)ttcd4month13 on tcd4month0.person_id = ttcd4month13.person_id
left join (
select person_id, value_numeric as 'cd4month14'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 14 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 14 MONTH)  group by person_id
)ttcd4month14 on tcd4month0.person_id = ttcd4month14.person_id
left join (
select person_id, value_numeric as 'cd4month15'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 15 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 15 MONTH)  group by person_id
)ttcd4month15 on tcd4month0.person_id = ttcd4month15.person_id
left join (
select person_id, value_numeric as 'cd4month16'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 16 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 16 MONTH)  group by person_id
)ttcd4month16 on tcd4month0.person_id = ttcd4month16.person_id
left join (
select person_id, value_numeric as 'cd4month17'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 17 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 17 MONTH)  group by person_id
)ttcd4month17 on tcd4month0.person_id = ttcd4month17.person_id
left join (
select person_id, value_numeric as 'cd4month18'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 18 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 18 MONTH)  group by person_id
)ttcd4month18 on tcd4month0.person_id = ttcd4month18.person_id
left join (
select person_id, value_numeric as 'cd4month19'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 19 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 19 MONTH)  group by person_id
)ttcd4month19 on tcd4month0.person_id = ttcd4month19.person_id
left join (
select person_id, value_numeric as 'cd4month20'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 20 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 20 MONTH)  group by person_id
)ttcd4month20 on tcd4month0.person_id = ttcd4month20.person_id
left join (
select person_id, value_numeric as 'cd4month21'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 21 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 21 MONTH)  group by person_id
)ttcd4month21 on tcd4month0.person_id = ttcd4month21.person_id
left join (
select person_id, value_numeric as 'cd4month22'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 22 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 22 MONTH)  group by person_id
)ttcd4month22 on tcd4month0.person_id = ttcd4month22.person_id
left join (
select person_id, value_numeric as 'cd4month23'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 23 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 23 MONTH)  group by person_id
)ttcd4month23 on tcd4month0.person_id = ttcd4month23.person_id
left join (
select person_id, value_numeric as 'cd4month24'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 24 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 24 MONTH)  group by person_id
)ttcd4month24 on tcd4month0.person_id = ttcd4month24.person_id
left join (
select person_id, value_numeric as 'cd4month25'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 25 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 25 MONTH)  group by person_id
)ttcd4month25 on tcd4month0.person_id = ttcd4month25.person_id
left join (
select person_id, value_numeric as 'cd4month26'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 26 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 26 MONTH)  group by person_id
)ttcd4month26 on tcd4month0.person_id = ttcd4month26.person_id
left join (
select person_id, value_numeric as 'cd4month27'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 27 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 27 MONTH)  group by person_id
)ttcd4month27 on tcd4month0.person_id = ttcd4month27.person_id
left join (
select person_id, value_numeric as 'cd4month28'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 28 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 28 MONTH)  group by person_id
)ttcd4month28 on tcd4month0.person_id = ttcd4month28.person_id
left join (
select person_id, value_numeric as 'cd4month29'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 29 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 29 MONTH)  group by person_id
)ttcd4month29 on tcd4month0.person_id = ttcd4month29.person_id
left join (
select person_id, value_numeric as 'cd4month30'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 30 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 30 MONTH)  group by person_id
)ttcd4month30 on tcd4month0.person_id = ttcd4month30.person_id
left join (
select person_id, value_numeric as 'cd4month31'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 31 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 31 MONTH)  group by person_id
)ttcd4month31 on tcd4month0.person_id = ttcd4month31.person_id
left join (
select person_id, value_numeric as 'cd4month32'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 32 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 32 MONTH)  group by person_id
)ttcd4month32 on tcd4month0.person_id = ttcd4month32.person_id
left join (
select person_id, value_numeric as 'cd4month33'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 33 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 33 MONTH)  group by person_id
)ttcd4month33 on tcd4month0.person_id = ttcd4month33.person_id
left join (
select person_id, value_numeric as 'cd4month34'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 34 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 34 MONTH)  group by person_id
)ttcd4month34 on tcd4month0.person_id = ttcd4month34.person_id
left join (
select person_id, value_numeric as 'cd4month35'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 35 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 35 MONTH)  group by person_id
)ttcd4month35 on tcd4month0.person_id = ttcd4month35.person_id
left join (
select person_id, value_numeric as 'cd4month36'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 36 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 36 MONTH)  group by person_id
)ttcd4month36 on tcd4month0.person_id = ttcd4month36.person_id
left join (
select person_id, value_numeric as 'cd4month37'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 37 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 37 MONTH)  group by person_id
)ttcd4month37 on tcd4month0.person_id = ttcd4month37.person_id
left join (
select person_id, value_numeric as 'cd4month38'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 38 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 38 MONTH)  group by person_id
)ttcd4month38 on tcd4month0.person_id = ttcd4month38.person_id
)ttcd4
)ttcd44 on tDemographics.person_id = ttcd44.person_id 
left join 
(
select * from (
select tWeightmonth0.person_id , weightMonth4 ,  weightMonth5, weightMonth6, weightMonth7,weightMonth8 ,  weightMonth9, weightMonth10, weightMonth11,weightMonth12 ,  weightMonth13, weightMonth14, weightMonth15,
weightMonth16 ,  weightMonth17, weightMonth18, weightMonth19,weightMonth20 ,  weightMonth21, weightMonth22, weightMonth23,weightMonth24 ,  weightMonth25, weightMonth26, weightMonth27,
weightMonth28 ,  weightMonth29, weightMonth30, weightMonth31,weightMonth32 ,  weightMonth33, weightMonth34, weightMonth35 , weightMonth36, weightMonth37, weightMonth38 from (
select person_id, 
(case when date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then value_numeric else 0 end) as 'month0'
from obs where  concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') group by person_id
)tWeightmonth0
left join (
select person_id, value_numeric as 'weightMonth4'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 4 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 4 MONTH)  group by person_id
)tWeightmonth4 on tWeightmonth0.person_id = tWeightmonth4.person_id
left join (
select person_id, value_numeric as 'weightMonth5'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 5 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 5 MONTH)  group by person_id
)tWeightmonth5 on tWeightmonth0.person_id = tWeightmonth5.person_id
left join (
select person_id, value_numeric as 'weightMonth6'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 6 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 6 MONTH)  group by person_id
)tWeightmonth6 on tWeightmonth0.person_id = tWeightmonth6.person_id
left join (
select person_id, value_numeric as 'weightMonth7'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 7 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 7 MONTH)  group by person_id
)tWeightmonth7 on tWeightmonth0.person_id = tWeightmonth7.person_id
left join (
select person_id, value_numeric as 'weightMonth8'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 8 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 8 MONTH)  group by person_id
)tWeightmonth8 on tWeightmonth0.person_id = tWeightmonth8.person_id
left join (
select person_id, value_numeric as 'weightMonth9'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 9 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 9 MONTH)  group by person_id
)tWeightmonth9 on tWeightmonth0.person_id = tWeightmonth9.person_id
left join (
select person_id, value_numeric as 'weightMonth10'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 10 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 10 MONTH)  group by person_id
)tWeightmonth10 on tWeightmonth0.person_id = tWeightmonth10.person_id
left join (
select person_id, value_numeric as 'weightMonth11'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 11 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 11 MONTH)  group by person_id
)tWeightmonth11 on tWeightmonth0.person_id = tWeightmonth11.person_id
left join (
select person_id, value_numeric as 'weightMonth12'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 12 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 12 MONTH)  group by person_id
)tWeightmonth12 on tWeightmonth0.person_id = tWeightmonth12.person_id
left join (
select person_id, value_numeric as 'weightMonth13'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 13 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 13 MONTH)  group by person_id
)tWeightmonth13 on tWeightmonth0.person_id = tWeightmonth13.person_id
left join (
select person_id, value_numeric as 'weightMonth14'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 14 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 14 MONTH)  group by person_id
)tWeightmonth14 on tWeightmonth0.person_id = tWeightmonth14.person_id
left join (
select person_id, value_numeric as 'weightMonth15'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 15 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 15 MONTH)  group by person_id
)tWeightmonth15 on tWeightmonth0.person_id = tWeightmonth15.person_id
left join (
select person_id, value_numeric as 'weightMonth16'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 16 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 16 MONTH)  group by person_id
)tWeightmonth16 on tWeightmonth0.person_id = tWeightmonth16.person_id
left join (
select person_id, value_numeric as 'weightMonth17'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 17 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 17 MONTH)  group by person_id
)tWeightmonth17 on tWeightmonth0.person_id = tWeightmonth17.person_id
left join (
select person_id, value_numeric as 'weightMonth18'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 18 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 18 MONTH)  group by person_id
)tWeightmonth18 on tWeightmonth0.person_id = tWeightmonth18.person_id
left join (
select person_id, value_numeric as 'weightMonth19'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 19 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 19 MONTH)  group by person_id
)tWeightmonth19 on tWeightmonth0.person_id = tWeightmonth19.person_id
left join (
select person_id, value_numeric as 'weightMonth20'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 20 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 20 MONTH)  group by person_id
)tWeightmonth20 on tWeightmonth0.person_id = tWeightmonth20.person_id
left join (
select person_id, value_numeric as 'weightMonth21'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 21 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 21 MONTH)  group by person_id
)tWeightmonth21 on tWeightmonth0.person_id = tWeightmonth21.person_id
left join (
select person_id, value_numeric as 'weightMonth22'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 22 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 22 MONTH)  group by person_id
)tWeightmonth22 on tWeightmonth0.person_id = tWeightmonth22.person_id
left join (
select person_id, value_numeric as 'weightMonth23'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 23 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 23 MONTH)  group by person_id
)tWeightmonth23 on tWeightmonth0.person_id = tWeightmonth23.person_id
left join (
select person_id, value_numeric as 'weightMonth24'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 24 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 24 MONTH)  group by person_id
)tWeightmonth24 on tWeightmonth0.person_id = tWeightmonth24.person_id
left join (
select person_id, value_numeric as 'weightMonth25'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 25 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 25 MONTH)  group by person_id
)tWeightmonth25 on tWeightmonth0.person_id = tWeightmonth25.person_id
left join (
select person_id, value_numeric as 'weightMonth26'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 26 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 26 MONTH)  group by person_id
)tWeightmonth26 on tWeightmonth0.person_id = tWeightmonth26.person_id
left join (
select person_id, value_numeric as 'weightMonth27'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 27 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 27 MONTH)  group by person_id
)tWeightmonth27 on tWeightmonth0.person_id = tWeightmonth27.person_id
left join (
select person_id, value_numeric as 'weightMonth28'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 28 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 28 MONTH)  group by person_id
)tWeightmonth28 on tWeightmonth0.person_id = tWeightmonth28.person_id
left join (
select person_id, value_numeric as 'weightMonth29'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 29 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 29 MONTH)  group by person_id
)tWeightmonth29 on tWeightmonth0.person_id = tWeightmonth29.person_id
left join (
select person_id, value_numeric as 'weightMonth30'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 30 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 30 MONTH)  group by person_id
)tWeightmonth30 on tWeightmonth0.person_id = tWeightmonth30.person_id
left join (
select person_id, value_numeric as 'weightMonth31'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 31 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 31 MONTH)  group by person_id
)tWeightmonth31 on tWeightmonth0.person_id = tWeightmonth31.person_id
left join (
select person_id, value_numeric as 'weightMonth32'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 32 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 32 MONTH)  group by person_id
)tWeightmonth32 on tWeightmonth0.person_id = tWeightmonth32.person_id
left join (
select person_id, value_numeric as 'weightMonth33'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 33 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 33 MONTH)  group by person_id
)tWeightmonth33 on tWeightmonth0.person_id = tWeightmonth33.person_id
left join (
select person_id, value_numeric as 'weightMonth34'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 34 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 34 MONTH)  group by person_id
)tWeightmonth34 on tWeightmonth0.person_id = tWeightmonth34.person_id
left join (
select person_id, value_numeric as 'weightMonth35'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 35 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 35 MONTH)  group by person_id
)tWeightmonth35 on tWeightmonth0.person_id = tWeightmonth35.person_id
left join (
select person_id, value_numeric as 'weightMonth36'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 36 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 36 MONTH)  group by person_id
)tWeightmonth36 on tWeightmonth0.person_id = tWeightmonth36.person_id
left join (
select person_id, value_numeric as 'weightMonth37'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 37 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 37 MONTH)  group by person_id
)tWeightmonth37 on tWeightmonth0.person_id = tWeightmonth37.person_id
left join (
select person_id, value_numeric as 'weightMonth38'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 38 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 38 MONTH)  group by person_id
)tWeightmonth38 on tWeightmonth0.person_id = tWeightmonth38.person_id
)ttweight
)tttweight on tDemographics.person_id = tttweight.person_id


