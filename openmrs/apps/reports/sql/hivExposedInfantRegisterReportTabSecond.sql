select clientName as 'Infants Name',
DateofTest9Months as 'HIV Rapid Test (9 mo of age or first contact after) -\nDate of Test',
(case when DateofTest9Months > birthdate then TIMESTAMPDIFF(MONTH, birthdate, DateofTest9Months) else 'N/A' end) as 'HIV Rapid Test (9 mo of age or first contact after) -\nAge (months)' ,
(case when 9monthsResults = 'Negative' then 'Neg' when 9monthsResults = 'Positive' then 'Pos' else 'N/A' end ) as 'HIV Rapid Test (9 mo of age or first contact after) -\nRapid Test Result (Pos/Neg)',
 DateofSecondPCR as '2nd DNA PCR Test -\nInitial' , DateofRepeatPCR as '2nd DNA PCR Test -\nRepeat', DateDBSCollected as '2nd DNA PCR Test -\nDate DBS was collected', 
 (case when ReasonForSecondPCR = 'For confirmation of positive first DNA PCR test result' then 1 when ReasonForSecondPCR = 'For Repeat DNA PCR 6 weeks after weaning for children less than 9 months' then 2 when ReasonForSecondPCR = 'For positive HIV rapid test result at 9 months or thereafter' then 3 else 'N/A' end) as '2nd DNA PCR Test-\nReason for 2nd PCR\n1.For confirmation of positive first DNA PCR test result\n2.For Repeat DNA PCR 6 weeks after weaning for children less than 9 months\n3.For positive HIV rapid test result at 9 months or thereafter\n(use codes below:1,2,3)',
 ageSecondPCR as '2nd DNA PCR Test -\nAge at 2nd DBS (Months)' , InfantFeedingStatusSecondPCR as '2nd DNA PCR Test -\nInfant feeding status', SecondPCRresults as '2nd DNA PCR Test -\nTest Result', DateResultsReceivedSecondPCR as '2nd DNA PCR Test -\nDate result received', 
 DateResultGivenToCaregiver as '2nd DNA PCR Test -\nDate result given to caretaker',appointment_date_one as 'Visit Details -\nAppointment 1' ,visit_date_one as 'Visit Details -\nVisit Date 1',TIMESTAMPDIFF(MONTH,birthdate, visit_date_one) as 'Visit Details -\nFirst Visit Age(Months)', visit_date_two as 'Visit Details -\nVisit Date 2', visit_date_three as 'Visit Details -\nVisit Date 3', visit_date_four as 'Visit Details -\nVisit Date 4',visit_date_five as 'Visit Details -\nVisit Date 5',visit_date_six as 'Visit Details -\nVisit Date 6',visit_date_seven as 'Visit Details -\nVisit Date 7',visit_date_eight as 'Visit Details -\nVisit Date 8',visit_date_nine as 'Visit Details -\nVisit Date 9',visit_date_ten as 'Visit Details -\nVisit Date 10',  DateTested18Months as 'Confirmatory HIV Rapid Test (at 18 months or later) -\nDate Tested',
 (case when DateTested18Months > birthdate then TIMESTAMPDIFF(MONTH, birthdate, DateTested18Months) else 'N/A' end)  as 'Confirmatory HIV Rapid Test (at 18 months or later) -\nAge(Months)', 
 (case when RapidResults18Months = 'Negative' then 'Neg' when RapidResults18Months = 'Positive' then 'Pos' else 'N/A' end ) as 'Confirmatory HIV Rapid Test (at 18 months or later) -\nRapid Test Result (Pos=Positive, Neg=Negative)', FinalOutcome as 'Final Outcome', 
 (case when  FinalOutcome = 'Transferred' then FacilityTransferredTo else 'N/A' end) as 'Facility Name Transferred To' from(
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
select person_id , DateofTest9Months from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'DateofTest9Months', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Rapid Test At 9 Months Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Rapid Test At 9 Months Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateofTest9Months on tEnrollementDate.pid = tDateofTest9Months.person_id
left join (
select person_id, (select name from concept_name where concept_id = 9monthsResults and concept_name_type = 'SHORT') as '9monthsResults' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as '9monthsResults', voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (Rapid Test At 9 Months Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (Rapid Test At 9 Months Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)t9MonthsResults on tEnrollementDate.pid = t9MonthsResults.person_id
left join (
select person_id , DateofSecondPCR from ( 
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'DateofSecondPCR', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Second PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Second PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateofSecondPCR on tEnrollementDate.pid = tDateofSecondPCR.person_id
left join (
select person_id , DateofRepeatPCR from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'DateofRepeatPCR', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Repeat PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Repeat PCR Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateofRepeatPCR on tEnrollementDate.pid = tDateofRepeatPCR.person_id
left join (
select person_id , DateDBSCollected from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'DateDBSCollected', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date sample receipt by PHL confirmed(Second PCR Test)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date sample receipt by PHL confirmed(Second PCR Test)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateDBSCollected on tEnrollementDate.pid = tDateDBSCollected.person_id
left join (
select person_id, (select name from concept_name where concept_id = ReasonForSecondPCR and concept_name_type = 'SHORT') as 'ReasonForSecondPCR' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'ReasonForSecondPCR', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Reason For Second PCR' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Reason For Second PCR' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tReasonForSecondPCR on tEnrollementDate.pid = tReasonForSecondPCR.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime , value_numeric as 'ageSecondPCR',encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Second PCR,Age at 2nd DBS (Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Second PCR,Age at 2nd DBS (Months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAgeSecondPCR on tEnrollementDate.pid = tAgeSecondPCR.person_id
left join (
select person_id, (select name from concept_name where concept_id = InfantFeedingStatusSecondPCR and concept_name_type = 'SHORT') as 'InfantFeedingStatusSecondPCR' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'InfantFeedingStatusSecondPCR', voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (Second PCR Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (Second PCR Feeding Method)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tInfantFeedingStatusSecondPCR on tEnrollementDate.pid = tInfantFeedingStatusSecondPCR.person_id
left join (
select person_id, (select name from concept_name where concept_id = SecondPCRresults and concept_name_type = 'SHORT') as 'SecondPCRresults' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'SecondPCRresults', voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (Second PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (Second PCR Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSecondPCRresults on tEnrollementDate.pid = tSecondPCRresults.person_id
left join (
select person_id , DateResultsReceivedSecondPCR from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'DateResultsReceivedSecondPCR', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Second PCR,Date result Received' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Second PCR,Date result Received' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateResultsReceivedSecondPCR on tEnrollementDate.pid = tDateResultsReceivedSecondPCR.person_id
left join (
select person_id , DateResultGivenToCaregiver from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'DateResultGivenToCaregiver', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Second PCR Date Result Given to Caregiver)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (Second PCR Date Result Given to Caregiver)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateResultGivenToCaregiver on tEnrollementDate.pid = tDateResultGivenToCaregiver.person_id
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
select person_id , DateTested18Months from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'DateTested18Months', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (18Months Rapid Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'HEI Testing (18Months Rapid Test Date)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateTested18Months on tEnrollementDate.pid = tDateTested18Months.person_id
left join (
select person_id, (select name from concept_name where concept_id = RapidResults18Months and concept_name_type = 'SHORT') as 'RapidResults18Months' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'RapidResults18Months', voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (18Months Rapid Test  Results)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)t18RapidResults on tEnrollementDate.pid = t18RapidResults.person_id
left join (
select person_id, (select name from concept_name where concept_id = FinalOutcome and concept_name_type = 'SHORT') as 'FinalOutcome' from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'FinalOutcome', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Final Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Final Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tFinalOutcome on tEnrollementDate.pid = tFinalOutcome.person_id
left join (
select person_id , FacilityTransferredTo from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_text as 'FacilityTransferredTo', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Facility Transferred to' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Facility Transferred to' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tFacilityTransferredTo on tEnrollementDate.pid = tFacilityTransferredTo.person_id