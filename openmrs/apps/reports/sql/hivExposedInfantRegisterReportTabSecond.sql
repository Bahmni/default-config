select clientName as 'Infants Name',
DateofTest9Months as 'HIV Rapid Test (9 mo of age or first contact after) -\nDate of Test',
(case when DateofTest9Months > birthdate then TIMESTAMPDIFF(MONTH, birthdate, DateofTest9Months) else 'N/A' end) as 'HIV Rapid Test (9 mo of age or first contact after) -\nAge (months)' ,
(case when 9monthsResults = 'Negative' then 'Neg' when 9monthsResults = 'Positive' then 'Pos' else 'N/A' end ) as 'HIV Rapid Test (9 mo of age or first contact after) -\nRapid Test Result (Pos/Neg)',
 DateofSecondPCR as '2nd DNA PCR Test -\nInitial' , DateofRepeatPCR as '2nd DNA PCR Test -\nRepeat', DateDBSCollected as '2nd DNA PCR Test -\nDate DBS was collected', 
 (case when ReasonForSecondPCR = 'For confirmation of positive first DNA PCR test result' then 1 when ReasonForSecondPCR = 'For Repeat DNA PCR 6 weeks after weaning for children less than 9 months' then 2 when ReasonForSecondPCR = 'For positive HIV rapid test result at 9 months or thereafter' then 3 else 'N/A' end) as '2nd DNA PCR Test-\nReason for 2nd PCR\n1.For confirmation of positive first DNA PCR test result\n2.For Repeat DNA PCR 6 weeks after weaning for children less than 9 months\n3.For positive HIV rapid test result at 9 months or thereafter\n(use codes below:1,2,3)',
 ageSecondPCR as '2nd DNA PCR Test -\nAge at 2nd DBS (Months)' , InfantFeedingStatusSecondPCR as '2nd DNA PCR Test -\nInfant feeding status', SecondPCRresults as '2nd DNA PCR Test -\nTest Result', DateResultsReceivedSecondPCR as '2nd DNA PCR Test -\nDate result received', 
 DateResultGivenToCaregiver as '2nd DNA PCR Test -\nDate result given to caretaker', DateTested18Months as 'Confirmatory HIV Rapid Test (at 18 months or later) -\nDate Tested',
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