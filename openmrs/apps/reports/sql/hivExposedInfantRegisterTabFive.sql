select clientName as 'Infants Name', DateTested18Months as 'Confirmatory HIV Rapid Test (at 18 months or later) -\nDate Tested',
 (case when DateTested18Months > birthdate then TIMESTAMPDIFF(MONTH, birthdate, DateTested18Months) else 'N/A' end)  as 'Confirmatory HIV Rapid Test (at 18 months or later) -\nAge(Months)', 
 (case when RapidResults18Months = 'Negative' then 'Neg' when RapidResults18Months = 'Positive' then 'Pos' else 'N/A' end ) as 'Confirmatory HIV Rapid Test (at 18 months or later) -\nRapid Test Result (Pos=Positive, Neg=Negative)', FinalOutcome as 'Final Outcome', 
 (case when  FinalOutcome = 'Transferred' then FacilityTransferredTo else 'N/A' end) as 'Facility Name Transferred To'  from (
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