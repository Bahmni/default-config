 select clientName as 'Infants Name', appointment_date_six as 'Visit Details -\nAppointment 6' , visit_date_six as 'Visit Details -\nVisit Date 6',TIMESTAMPDIFF(MONTH,birthdate, visit_date_six) as 'Visit Details -\nSixth Visit Age(Months)',Feeding_Code6 as 'Feeding Code -\nVisit 6',Immunization_Code6 as 'Immunization Code -\nVisit 6',ctx_visit6 as 'Visit 6 -\nCTX/ARV prophylaxis (Y/N)', appointment_date_seven as 'Visit Details -\nAppointment 7', 
 visit_date_seven as 'Visit Details -\nVisit Date 7',TIMESTAMPDIFF(MONTH,birthdate, visit_date_seven) as 'Seventh Details -\nFirst Visit Age(Months)',Feeding_Code7 as 'Feeding Code -\nVisit 7', Immunization_Code7 as 'Immunization Code -\nVisit 7' ,ctx_visit7 as 'Visit 7 -\nCTX/ARV prophylaxis (Y/N)',appointment_date_eight as 'Visit Details -\nAppointment 8', visit_date_eight as 'Visit Details -\nVisit Date 8',TIMESTAMPDIFF(MONTH,birthdate, visit_date_eight) as 'Visit Details -\nEighth Visit Age(Months)',Feeding_Code8 as 'Feeding Code -\nVisit 8',
 Immunization_Code8 as 'Immunization Code -\nVisit 8',ctx_visit8 as 'Visit 8 -\nCTX/ARV prophylaxis (Y/N)', appointment_date_nine as 'Visit Details -\nAppointment 9', visit_date_nine as 'Visit Details -\nVisit Date 9',TIMESTAMPDIFF(MONTH,birthdate, visit_date_nine) as 'Visit Details -\nNineth Visit Age(Months)',Feeding_Code9 as 'Feeding Code -\nVisit 9',Immunization_Code9 as 'Immunization Code -\nVisit 9',ctx_visit9 as 'Visit 9 -\nCTX/ARV prophylaxis (Y/N)',
 appointment_date_ten as 'Visit Details -\nAppointment 10', visit_date_ten as 'Visit Details -\nVisit Date 10' , TIMESTAMPDIFF(MONTH,birthdate, visit_date_ten) as 'Visit Details -\nTenth Visit Age(Months)',Feeding_Code10 as 'Feeding Code -\nVisit 10',Immunization_Code10 as 'Immunization Code -\nVisit 10',ctx_visit10 as 'Visit 10 -\nCTX/ARV prophylaxis (Y/N)' from (
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
gender as sex ,(datediff(curdate(),p.birthdate) / 365) as 'Age' , p.birthdate
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'HIVExposedInfant(HEI)No')
and floor(datediff('#endDate#',p.birthdate) / 365) < 2
)HeiDemographics on tEnrollementDate.pid = HeiDemographics.person_id
left join (
select pid, appointment_date_six ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_six' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =6 order by pid 
)tAppointmentSix on tEnrollementDate.pid = tAppointmentSix.pid
left join (
select pid, appointment_date_seven ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_seven' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =7 order by pid 
)tAppointmentSeven on tEnrollementDate.pid = tAppointmentSeven.pid
left join (
select pid, appointment_date_eight ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_eight' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =8 order by pid 
)tAppointmentEight on tEnrollementDate.pid = tAppointmentEight.pid
left join (
select pid, appointment_date_nine ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_nine' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num = 9 order by pid 
)tAppointmentNine on tEnrollementDate.pid = tAppointmentNine.pid
left join (
select pid, appointment_date_ten ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_ten' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num = 10 order by pid 
)tAppointmentTen on tEnrollementDate.pid = tAppointmentTen.pid

left join (
select patient_id , date_started as visit_date_six, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 7
)tVisitSix on tEnrollementDate.pid = tVisitSix.patient_id
left join (
select patient_id , date_started as visit_date_seven, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 8
)tVisitSeven on tEnrollementDate.pid = tVisitSeven.patient_id
left join (
select patient_id , date_started as visit_date_eight, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 9
)tVisitEight on tEnrollementDate.pid = tVisitEight.patient_id
left join (
select patient_id , date_started as visit_date_nine, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 10
)tVisitNine on tEnrollementDate.pid = tVisitNine.patient_id
left join (
select patient_id , date_started as visit_date_ten, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 11
)tVisitTen on tEnrollementDate.pid = tVisitTen.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code6' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 7
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitSixFeedingCode on tEnrollementDate.pid = tVisitSixFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code7' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 8
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitSevenFeedingCode on tEnrollementDate.pid = tVisitSevenFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code8' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 9
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitEightFeedingCode on tEnrollementDate.pid = tVisitEightFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code9' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 10
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitNineFeedingCode on tEnrollementDate.pid = tVisitNineFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code10' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 11
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitTenFeedingCode on tEnrollementDate.pid = tVisitTenFeedingCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code6' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 6
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tSixImmunizationCode on tEnrollementDate.pid = tSixImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code7' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 7
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tSevenImmunizationCode on tEnrollementDate.pid = tSevenImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code8' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 8
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tEightImmunizationCode on tEnrollementDate.pid = tEightImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code9' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 9
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tNineImmunizationCode on tEnrollementDate.pid = tNineImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code10' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 10
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tTenImmunizationCode on tEnrollementDate.pid = tTenImmunizationCode.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit6' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 7
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit6 on tEnrollementDate.pid = tctxVisit6.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit7' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 8
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit7 on tEnrollementDate.pid = tctxVisit7.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit8' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 9
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit8 on tEnrollementDate.pid = tctxVisit8.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit9' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 10
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit9 on tEnrollementDate.pid = tctxVisit9.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit10' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 11
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit10 on tEnrollementDate.pid = tctxVisit10.patient_id