select artnumber as 'Unique ART Number' , datestartedart as 'ART Start Date',
(case when HIV_Retesting_for_ART_initiation is not null then '1' else '0' end) as 'HIV Retesting for ART initiation. 0=No 1=Yes',
 ClientName as 'Name in Full' , mobile as "Client's Address - Mobile" ,  occupation as 'Occupation', '' as 'Key Population', muac as 'Mid Upper Arm Conference', Age as 'Age (years)', sex as 'Sex (M or F)',
WEIGHT as 'Weight (kg)' , HEIGHT as 'Height /Length  for Child < 2 years  (cm)', BMI as 'Body Mass Index (BMI) (kg/mSq)', whostage as 'WHO clinical stage', 
CD4  as 'CD4 count or (if child <5 years indicate  CD4%)', dateStartedCTXorDapsone as 'CTX  or Dapsone start month/year' ,
isoniazidStartDate1 as 'INH Prophylaxis - Date\n 1', isoniazidStartDate2 as 'INH Prophylaxis - Date\n 2' , isoniazidStartDate3 as 'INH Prophylaxis - Date\n 3' , isoniazidStartDate4 as 'INH Prophylaxis - Date\n 4',isoniazidStartDate5 as 'INH Prophylaxis - Date\n 5', isoniazidStartDate6 as 'INH Prophylaxis - Date\n 6' , 
date_started_tbrx as 'TB RX start Month/year and TB reg No.', Pregnancy1 as 'Pregnancy\n1' , Pregnancy2  as 'Pregnancy\n2',Pregnancy3  as 'Pregnancy\n3' , Pregnancy4  as 'Pregnancy\n4' ,
(case when currently_breastfeeding = 'YES' then '1' else '0' end) as 'Breastfeeding (0=No; 1=Yes; 2=N/A)',
firstregimen as '1st Line Regimen - Original Regimen', firstsubstitutionregimen as '1st Line Regimen - 1st: Substitution drug code' , secondswitchwithinfirstline as '1st Line Regimen - 2nd: Substitution drug code' , secondlinefirst as '2nd Line Regimen - 2nd Line Regimen switched to',
firstsubstitutionwithinsecond as '2nd Line Regimen - 1st:  Substitution drug code',
secondsubstitutionwithinsecondline as '2nd Line Regimen - 2nd: Substitution drug code' , tchildfirstregimen as 'Child 1st Line Regimens' , tChildSecondLine as 'Child 2nd Line Regimens' 
 from (
select patient_id, min(date_created) as datestartedart
from (
select o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)a group by patient_id
)tDateStartedArt inner join
(
select * from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type 
where name = 'TypeofPatient'
)  and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)tNewPatient
inner join (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo')
)tDemographics on tNewPatient.pid = tDemographics.person_id
)tNewPatientDemographics on tDateStartedArt.patient_id = tNewPatientDemographics.pid
left join (
select pn.person_id as 'pid', pn.given_name, pn.middle_name, pa.value as 'mobile' from person_name pn
left join person_attribute pa on pn.person_id = pa.person_id where pa.person_attribute_type_id 
=(select person_attribute_type_id from person_attribute_type where name = 'MobileNumber')
)tMobile on tNewPatientDemographics.pid =  tMobile.pid
left join (
select * from (
select  person_id, concept_id, value_datetime as 'HIV_Retesting_for_ART_initiation' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Date of HIV Retesting Before ART' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateRestedHivbeforeARTinit on tNewPatientDemographics.pid =  tDateRestedHivbeforeARTinit.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'HEIGHT',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEIGHT' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEIGHT' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHeight on tNewPatientDemographics.pid =  tHeight.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'WEIGHT',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'WEIGHT' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'WEIGHT' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 	
)tWeight on tNewPatientDemographics.pid =  tWeight.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'BMI',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'BMI' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'BMI' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 	
)tBMI on tNewPatientDemographics.pid =  tBMI.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'CD4',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'CD4' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'CD4' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCDFour on tNewPatientDemographics.pid =  tCDFour.person_id 
left join(
select * from (
select  person_id, concept_id, value_datetime as 'date_started_tbrx' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date Started TB RX' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id =
 (select concept_id from concept_name where name = 'Date Started TB RX' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
 and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDatestartedtbrx on tNewPatientDemographics.pid =  tDatestartedtbrx.person_id
left join(
select pid , tConceptname.name as 'whostage' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'WHO Stage' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'WHO Stage' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tWhoStage on tNewPatientDemographics.pid =  tWhoStage.pid
left join(
select pid, min(date_created) as dateStartedCTXorDapsone
from (
select o.patient_id as pid, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form in (
(select concept_id from concept_name where name = 'CTX Drug' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0),
(select concept_id from concept_name where name = 'Dapsone Drugs' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
)
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)a group by pid
)tDateStartedCTxorDapsone on  tNewPatientDemographics.pid =  tDateStartedCTxorDapsone.pid
left join (
select person_id ,
(case when value_coded = 1 then 'Yes' else 'No' end) as 'currently_breastfeeding'
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Currently Breastfeeding?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCurrentlyBreastfeeeding on tNewPatientDemographics.pid =  tCurrentlyBreastfeeeding.person_id
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
)tfirstlineregimen on tNewPatientDemographics.pid =  tfirstlineregimen.pid 
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
)tFirstSubstitituionregime on tNewPatientDemographics.pid =  tFirstSubstitituionregime.pid 
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
)tSecondSubstitutionfirstline on tNewPatientDemographics.pid =  tSecondSubstitutionfirstline.pid
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
)tSecondlineoriginal on tNewPatientDemographics.pid =  tSecondlineoriginal.pid
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
)tfirstsubstitutionwithinsecondline on tNewPatientDemographics.pid =  tfirstsubstitutionwithinsecondline.pid
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
)tsecondsubstitutionwithinsecondline on tNewPatientDemographics.pid =  tsecondsubstitutionwithinsecondline.pid
left join (
select distinct(pid), tchildfirstregimen from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'tchildfirstregimen' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 1
)childfirstregimen
)tChildfirstregimen on tNewPatientDemographics.pid =  tChildfirstregimen.pid
left join (
select distinct(pid), tChildSecondLine from (
select distinct(patient_id) as pid,row_num,  date_activated , name  as 'tChildSecondLine' from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , o.date_activated , o.date_created
from orders o 
left join drug dr on o.concept_id = dr.concept_id
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and dr.name in ('5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL','5c = ABC/3TC (120/60) + RAL' , '5d = AZT/3TC +ATV/r' , '5e = ABC/3TC + ATV/r' , '5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*' , '5i = ABC/3TC +LPV/r')
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b where row_num = 1
)tChildSecondLine
)tChildSecondLineRegimen on tNewPatientDemographics.pid =  tChildSecondLineRegimen.pid
left join (
select @row_num := 0 , row_num, patient_id ,date_activated as 'isoniazidStartDate1'  from (
select  @row_num :=IF(@prev_value=patient_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , date_activated , 
date_created , patient_id , @prev_value:=patient_id, @prev_drugId:= concept_id from orders 
where concept_id = (select concept_id from concept_name where name = 'Isoniazid' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
and date_activated  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tIoniziad  where row_num = 1 
)tIsoniazidDate1 on tNewPatientDemographics.pid =  tIsoniazidDate1.patient_id
left join (
select @row_num := 0 , row_num, patient_id ,date_activated as 'isoniazidStartDate2'  from (
select  @row_num :=IF(@prev_value=patient_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , date_activated , 
date_created , patient_id , @prev_value:=patient_id, @prev_drugId:= concept_id from orders 
where concept_id = (select concept_id from concept_name where name = 'Isoniazid' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
and date_activated  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tIoniziad  where row_num = 2
)tIsoniazidDate2 on tNewPatientDemographics.pid =  tIsoniazidDate2.patient_id
left join (
select @row_num := 0 , row_num, patient_id ,date_activated as 'isoniazidStartDate3'  from (
select  @row_num :=IF(@prev_value=patient_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , date_activated , 
date_created , patient_id , @prev_value:=patient_id, @prev_drugId:= concept_id from orders 
where concept_id = (select concept_id from concept_name where name = 'Isoniazid' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
and date_activated  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tIoniziad  where row_num = 3
)tIsoniazidDate3 on tNewPatientDemographics.pid =  tIsoniazidDate3.patient_id
left join (
select @row_num := 0 , row_num, patient_id ,date_activated as 'isoniazidStartDate4'  from (
select  @row_num :=IF(@prev_value=patient_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , date_activated , 
date_created , patient_id , @prev_value:=patient_id, @prev_drugId:= concept_id from orders 
where concept_id = (select concept_id from concept_name where name = 'Isoniazid' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
and date_activated  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tIoniziad  where row_num = 4
)tIsoniazidDate4 on tNewPatientDemographics.pid =  tIsoniazidDate4.patient_id
left join (
select @row_num := 0 , row_num, patient_id ,date_activated as 'isoniazidStartDate5'  from (
select  @row_num :=IF(@prev_value=patient_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , date_activated , 
date_created , patient_id , @prev_value:=patient_id, @prev_drugId:= concept_id from orders 
where concept_id = (select concept_id from concept_name where name = 'Isoniazid' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
and date_activated  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tIoniziad  where row_num = 5
)tIsoniazidDate5 on tNewPatientDemographics.pid =  tIsoniazidDate5.patient_id
left join (
select @row_num := 0 , row_num, patient_id ,date_activated as 'isoniazidStartDate6'  from (
select  @row_num :=IF(@prev_value=patient_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , date_activated , 
date_created , patient_id , @prev_value:=patient_id, @prev_drugId:= concept_id from orders 
where concept_id = (select concept_id from concept_name where name = 'Isoniazid' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
and date_activated  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tIoniziad  where row_num = 6
)tIsoniazidDate6 on tNewPatientDemographics.pid =  tIsoniazidDate6.patient_id
left join(
select pid , tConceptname.name as 'occupation' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Occupation' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Occupation' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tOccupation on tNewPatientDemographics.pid =  tOccupation.pid
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'muac',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'MUAC, Pregnancy Visit' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'MUAC, Pregnancy Visit' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tMuac on tNewPatientDemographics.pid =  tMuac.person_id
left join(
select person_id, isPregnant from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'isPregnant', voided from obs where concept_id =
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIpregnant on tNewPatientDemographics.pid = tIpregnant.person_id
left join (
select pidd , 
(case when TIMESTAMPDIFF(MONTH, date_activated, PregnancyOneEdd) <= 9 then 'YM' else 'N/A' end) as 'Pregnancy1'  from (
select distinct(patient_id) as pidd,row_num,  date_activated , name  as 'firstregimen' , PregnancyOneEdd from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , 
o.date_activated , o.date_created , PregnancyOneEdd
from orders o 
left join drug dr on o.concept_id = dr.concept_id
left join (
select  person_id as pid ,
(case when row_num = 1 then pregnancyOneEdd else 'N/A' end ) as 'PregnancyOneEdd'  from (
select  @row_num := 0 , row_num, person_id ,obs_datetime as 'obscreateddate' , obs_group_id , obs_group1 ,pregnancyOneEdd   from (
select @row_num :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id from obs 
where concept_id = (select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tPregnancies 
inner join (
select @row_nm := 0 , row_nm, person_id as pid ,obs_datetime as 'obsdatetime' , obs_group_id as 'obs_group1' , 
value_datetime as 'pregnancyOneEdd' from (
select  @row_nm :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_nm+1, 1)  AS row_nm,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id , value_datetime from obs 
where concept_id = (select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)EDD 
)tPregnancyEDD on tPregnancies.obs_group_id = tPregnancyEDD.obs_group1 
)tt where row_num = 1
)ss on o.patient_id = ss.pid
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b 
)tfirstlinereg  where date_activated < PregnancyOneEdd and TIMESTAMPDIFF(MONTH, date_activated, PregnancyOneEdd) <= 9 group by pidd
)tPregrancyOne on tNewPatientDemographics.pid =  tPregrancyOne.pidd
left join (

select pidd , 
(case when TIMESTAMPDIFF(MONTH, date_activated, PregnancyTwoEdd) <= 9 then 'YM' else 'N/A' end) as 'Pregnancy2'  from (
select distinct(patient_id) as pidd,row_num,  date_activated , name  as 'firstregimen' , PregnancyTwoEdd from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , 
o.date_activated , o.date_created , PregnancyTwoEdd
from orders o 
left join drug dr on o.concept_id = dr.concept_id
left join (
select  person_id as pid ,
(case when row_num = 2 then pregnancyTwoEdd else 'N/A' end ) as 'PregnancyTwoEdd'  from (
select  @row_num := 0 , row_num, person_id ,obs_datetime as 'obscreateddate' , obs_group_id , obs_group1 ,pregnancyTwoEdd   from (
select @row_num :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id from obs 
where concept_id = (select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tPregnancies 
inner join (
select @row_nm := 0 , row_nm, person_id as pid ,obs_datetime as 'obsdatetime' , obs_group_id as 'obs_group1' , 
value_datetime as 'pregnancyTwoEdd' from (
select  @row_nm :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_nm+1, 1)  AS row_nm,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id , value_datetime from obs 
where concept_id = (select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)EDD 
)tPregnancyEDD on tPregnancies.obs_group_id = tPregnancyEDD.obs_group1 
)tt where row_num = 2
)ss on o.patient_id = ss.pid
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b 
)tfirstlinereg  where date_activated < PregnancyTwoEdd and TIMESTAMPDIFF(MONTH, date_activated, PregnancyTwoEdd) <= 9 group by pidd
)tPregnancyTwo on tNewPatientDemographics.pid =  tPregnancyTwo.pidd
left join (

select pidd , 
(case when TIMESTAMPDIFF(MONTH, date_activated, PregnancyThreeEdd) <= 9 then 'YM' else 'N/A' end) as 'Pregnancy3'  from (
select distinct(patient_id) as pidd,row_num,  date_activated , name  as 'firstregimen' , PregnancyThreeEdd from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , 
o.date_activated , o.date_created , PregnancyThreeEdd
from orders o 
left join drug dr on o.concept_id = dr.concept_id
left join (
select  person_id as pid ,
(case when row_num = 3 then PregnancyThreeEdd else 'N/A' end ) as 'PregnancyThreeEdd'  from (
select  @row_num := 0 , row_num, person_id ,obs_datetime as 'obscreateddate' , obs_group_id , obs_group1 ,PregnancyThreeEdd   from (
select @row_num :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id from obs 
where concept_id = (select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tPregnancies 
inner join (
select @row_nm := 0 , row_nm, person_id as pid ,obs_datetime as 'obsdatetime' , obs_group_id as 'obs_group1' , 
value_datetime as 'PregnancyThreeEdd' from (
select  @row_nm :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_nm+1, 1)  AS row_nm,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id , value_datetime from obs 
where concept_id = (select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)EDD 
)tPregnancyEDD on tPregnancies.obs_group_id = tPregnancyEDD.obs_group1 
)tt where row_num = 3
)ss on o.patient_id = ss.pid
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b 
)tfirstlinereg  where date_activated < PregnancyThreeEdd and TIMESTAMPDIFF(MONTH, date_activated, PregnancyThreeEdd) <= 9 group by pidd
)tPregnancyThree on tNewPatientDemographics.pid =  tPregnancyThree.pidd
left join (

select pidd , 
(case when TIMESTAMPDIFF(MONTH, date_activated, PregnancyFourEdd) <= 9 then 'YM' else 'N/A' end) as 'Pregnancy4'  from (
select distinct(patient_id) as pidd,row_num,  date_activated , name  as 'firstregimen' , PregnancyFourEdd from(
select @row_num :=IF(@prev_value=patient_id and @prev_drugId <> o.concept_id ,@row_num+1, 1)  AS row_num, 
@prev_value:=patient_id, @prev_drugId:= o.concept_id, o.patient_id, o.concept_id , dr.name ,  o.encounter_id , o.voided , 
o.date_activated , o.date_created , PregnancyFourEdd
from orders o 
left join drug dr on o.concept_id = dr.concept_id
left join (
select  person_id as pid ,
(case when row_num = 4 then PregnancyFourEdd else 'N/A' end ) as 'PregnancyFourEdd'  from (
select  @row_num := 0 , row_num, person_id ,obs_datetime as 'obscreateddate' , obs_group_id , obs_group1 ,PregnancyFourEdd   from (
select @row_num :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_num+1, 1)  AS row_num,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id from obs 
where concept_id = (select concept_id from concept_name where name = 'FP Pregnant' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)tPregnancies 
inner join (
select @row_nm := 0 , row_nm, person_id as pid ,obs_datetime as 'obsdatetime' , obs_group_id as 'obs_group1' , 
value_datetime as 'PregnancyFourEdd' from (
select  @row_nm :=IF(@prev_value=person_id and @prev_drugId = concept_id ,@row_nm+1, 1)  AS row_nm,
concept_id , voided , person_id , obs_datetime ,
date_created ,  @prev_value:=person_id, @prev_drugId:= concept_id , obs_group_id , value_datetime from obs 
where concept_id = (select concept_id from concept_name where name = 'EDD' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
and voided = 0 and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
)EDD 
)tPregnancyEDD on tPregnancies.obs_group_id = tPregnancyEDD.obs_group1 
)tt where row_num = 4
)ss on o.patient_id = ss.pid
where o.voided = 0 and dr.dosage_form = (select concept_id from concept_name where name = 'HIVTC, ART Regimen' and
 concept_name_type = 'FULLY_SPECIFIED' and voided = 0 ) 
and dr.name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV') 
and o.date_created <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') 
order by patient_id, date_activated) b 
)tfirstlinereg  where date_activated < PregnancyFourEdd and TIMESTAMPDIFF(MONTH, date_activated, PregnancyFourEdd) <= 9 group by pidd
)tPregnancyFour on tNewPatientDemographics.pid =  tPregnancyFour.pidd

















