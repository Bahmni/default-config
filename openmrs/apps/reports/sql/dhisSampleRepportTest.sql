select count(person_id) as 'Number Of Patients' from (
select (SELECT @a:= 0) AS a , obs_datetime as 'registrationDate', person_id , vlresults from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_numeric as 'vlresults', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'VL Results' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate  and vlresults >= 1000
)tHighVlPatients