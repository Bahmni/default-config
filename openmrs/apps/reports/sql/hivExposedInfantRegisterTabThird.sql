select clientName as 'Infants Name', 
appointment_date_one as 'Visit Details -\nAppointment 1' ,visit_date_one as 'Visit Details -\nVisit Date 1',TIMESTAMPDIFF(MONTH,birthdate, visit_date_one) as 'Visit Details -\nFirst Visit Age(Months)',Feeding_Code1 as 'Feeding Code -\nVisit 1',Immunization_Code1 as 'Immunization Code -\nVisit 1',ctx_visit1 as 'Visit 1 -\nCTX/ARV prophylaxis (Y/N)',appointment_date_two as 'Visit Details -\nAppointment 2',
 visit_date_two as 'Visit Details -\nVisit Date 2', TIMESTAMPDIFF(MONTH,birthdate, visit_date_two) as 'Visit Details -\nSecond Visit Age(Months)', Feeding_Code2 as 'Feeding Code -\nVisit 2',Immunization_Code2 as 'Immunization Code -\nVisit 2',ctx_visit2 as 'Visit 2 -\nCTX/ARV prophylaxis (Y/N)',appointment_date_three as 'Visit Details -\nAppointment 3', visit_date_three as 'Visit Details -\nVisit Date 3',
 TIMESTAMPDIFF(MONTH,birthdate, visit_date_three) as 'Visit Details -\nThird Visit Age(Months)',Feeding_Code3 as 'Feeding Code -\nVisit 3',Immunization_Code3 as 'Immunization Code -\nVisit 3',ctx_visit3 as 'Visit 3 -\nCTX/ARV prophylaxis (Y/N)',
 appointment_date_four as 'Visit Details -\nAppointment 4' ,visit_date_four as 'Visit Details -\nVisit Date 4',TIMESTAMPDIFF(MONTH,birthdate, visit_date_four) as 'Visit Details -\nFourth Visit Age(Months)', Feeding_Code4 as 'Feeding Code -\nVisit 4',Immunization_Code4 as 'Immunization Code -\nVisit 4',ctx_visit4 as 'Visit 4 -\nCTX/ARV prophylaxis (Y/N)',
  appointment_date_five as 'Visit Details -\nAppointment 5', visit_date_five as 'Visit Details -\nVisit Date 5',TIMESTAMPDIFF(MONTH,birthdate, visit_date_five) as 'Visit Details -\nFifth Visit Age(Months)', Feeding_Code5 as 'Feeding Code -\nVisit 5', Immunization_Code5 as 'Immunization Code -\nVisit 5', ctx_visit5 as 'Visit 5 -\nCTX/ARV prophylaxis (Y/N)'
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
select pid, appointment_date_one ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_one' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =1 order by pid 
)tAppointmentOne on tEnrollementDate.pid = tAppointmentOne.pid
left join (
select pid, appointment_date_two ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_two' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =2 order by pid 
)tAppointmentTwo on tEnrollementDate.pid = tAppointmentTwo.pid
left join (
select pid, appointment_date_three ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_three' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =3 order by pid 
)tAppointmentThree on tEnrollementDate.pid = tAppointmentThree.pid
left join (
select pid, appointment_date_four ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_four' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =4 order by pid 
)tAppointmentFour on tEnrollementDate.pid = tAppointmentFour.pid
left join (
select pid, appointment_date_five ,row_num from (
select  pa.person_id as pid, @row_num :=IF(@prev_value=pa.person_id,@row_num+1, 1)  AS row_num,  @prev_value:=pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , pt_app.start_date_time as 'appointment_date_five' , pt_app.voided 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
LEFT JOIN patient_appointment as pt_app on pt.patient_id = pt_app.patient_id
where pa.person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient') and 
pa.value in (select concept_id from concept_name where name in ('HeiRelationship',"ExistingHeiRelationship") and concept_name_type = 'FULLY_SPECIFIED') and pt_app.voided = 0 and pt_app.status != 'Cancelled'
and (datediff(curdate(),p.birthdate) / 365) < 2
)tAppointmentOne where row_num =5 order by pid 
)tAppointmentFive on tEnrollementDate.pid = tAppointmentFive.pid

left join (
select patient_id , date_started as visit_date_one, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 2 
)tVisitOne on tEnrollementDate.pid = tVisitOne.patient_id
left join (
select patient_id , date_started as visit_date_two, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 3 
)tVisitTwo on tEnrollementDate.pid = tVisitTwo.patient_id
left join (
select patient_id , date_started as visit_date_three, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 4
)tVisitThree on tEnrollementDate.pid = tVisitThree.patient_id
left join (
select patient_id , date_started as visit_date_four, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 5
)tVisitFour on tEnrollementDate.pid = tVisitFour.patient_id
left join (
select patient_id , date_started as visit_date_five, date_stopped from (
select patient_id ,@row_num := IF(@prev_value = patient_id,@row_num+1,1) AS row_num,@prev_value:= patient_id, date_started, date_stopped ,
visit_id, voided from visit 
order by patient_id
)tVisitOne where row_num = 6
)tVisitFive on tEnrollementDate.pid = tVisitFive.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code1' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 2
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitOneFeedingCode on tEnrollementDate.pid = tVisitOneFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code2' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 3
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitTwoFeedingCode on tEnrollementDate.pid = tVisitTwoFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code3' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 4
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitThreeFeedingCode on tEnrollementDate.pid = tVisitThreeFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code4' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 5
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitFourFeedingCode on tEnrollementDate.pid = tVisitFourFeedingCode.patient_id
left join (
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Feeding_Code5' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 6
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Infant Feeding' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tVisitFiveFeedingCode on tEnrollementDate.pid = tVisitFiveFeedingCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code1' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 2
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tFirstImmunizationCode on tEnrollementDate.pid = tFirstImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code2' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 3
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tSecondImmunizationCode on tEnrollementDate.pid = tSecondImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code3' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 4
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tThirdImmunizationCode on tEnrollementDate.pid = tThirdImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code4' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 5
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tFourthImmunizationCode on tEnrollementDate.pid = tFourthImmunizationCode.patient_id
left join(
select patient_id, (select name from concept_name where concept_id = value_coded and concept_name_type = 'SHORT') as 'Immunization_Code5' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 6
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Immunization Code' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tFifthImmunizationCode on tEnrollementDate.pid = tFifthImmunizationCode.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit1' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 2
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit1 on tEnrollementDate.pid = tctxVisit1.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit2' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 3
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit2 on tEnrollementDate.pid = tctxVisit2.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit3' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 4
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit3 on tEnrollementDate.pid = tctxVisit3.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit4' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 5
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit4 on tEnrollementDate.pid = tctxVisit4.patient_id
left join(
select patient_id, (case when value_coded = 1 then 'Y' else 'N' end) as 'ctx_visit5' from (
select patient_id , date_started as visit_date_one, date_stopped from (
select v.patient_id ,@row_num := IF(@prev_value = v.patient_id,@row_num+1,1) AS row_num,@prev_value:= v.patient_id, v.date_started, v.date_stopped ,
v.visit_id, v.voided from visit v order by v.patient_id )tVisitOne where row_num = 6
)firstvisit inner join (select person_id as pid, obs_datetime , voided ,value_coded from obs where concept_id = (select concept_id from concept_name where name = 'Cotrimoxazole/Dapsone' and 
concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0) c 
on firstvisit.patient_id = c.pid and DATE_FORMAT(c.obs_datetime, "%Y-%m-%d") = DATE_FORMAT(firstvisit.visit_date_one, "%Y-%m-%d") 
)tctxVisit5 on tEnrollementDate.pid = tctxVisit5.patient_id






