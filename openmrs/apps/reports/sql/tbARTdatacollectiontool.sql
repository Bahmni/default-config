select @a:=@a+1 Serial, date_tB_treatment_initiated as 'Date TB treatment  initiated' , Age , sex  , IFNULL(tHivStatus.hivstatus,'N/A') as 'HIV Status' , IFNULL(client_on_arts,'N/A') as 'Client On ART?' , artnumber as 'Unique ART Number' from (
select * from (  
select (SELECT @a:= 0) AS a , person_id, concept_id, obs_datetime as 'On TB Treatment' , encounter_id , value_coded , voided from obs where concept_id =
(select concept_id from concept_name where name = 'On TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'On TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tOnTBTreatment 
left join
(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo')
)tdemographics
on tOnTBTreatment.person_id = tdemographics.person_id
left join (
select * from (
select  person_id, concept_id, obs_datetime as 'date_tB_treatment_initiated' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date Started TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = (select concept_id from concept_name where name = 'Date Started TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateStartedTBtreatment on tOnTBTreatment.person_id = tDateStartedTBtreatment.person_id
left join 
(
select pid , tConceptname.name as 'hivstatus' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening - HIV Status' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tHivStatus on tOnTBTreatment.person_id = tHivStatus.pid
left join 
(
select person_id ,
(case when value_coded = 1 then 'Yes' else 'No' end) as 'client_on_arts'
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tOnArtTreatment on tOnTBTreatment.person_id = tOnArtTreatment.person_id