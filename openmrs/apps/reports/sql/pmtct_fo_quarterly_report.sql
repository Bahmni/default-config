select  @a:=@a+1 as 'Serial'  , date_of_birth as 'Date Of Birth', artnumber as 'EID Number' , Sex ,  date_eid_sample_collected as 'Date EID sample collected' ,zerototwomonths as 'Age of child at first EID sample collection\n(put 1 where the age belongs):\n0 - 2 months of age' ,
abovetwomonths as 'Age of child at first EID sample collection\n(put 1 where the age belongs):\n2 - 12 months of age' , 
(case when Outcomeat24months = 'HIV Infected' then 1 when Outcomeat24months = 'HIV uninfected' then 2 when Outcomeat24months = 'HIV Final Status Unknown' then 3 when Outcomeat24months = 'Died without status known' then 4 else 'N/A' end ) 
as 'Final outcome at 24 months of age  \n(1. HIV infected; 2- HIV-uninfected; 3-HIV final status unknown;4-Died without status known:' from(
select (SELECT @a:= 0) AS a , pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,p.birthdate as 'date_of_birth' ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'HIVExposedInfant(HEI)No') 
and (datediff(curdate(),p.birthdate) / 365) < 2  and p.birthdate between '#startDate#' and '#endDate#' 
)tDemogrpahics
left join 
(
select * from (
select  person_id, concept_id, value_datetime as 'date_eid_sample_collected' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date EID sample collected' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Date EID sample collected' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateheisamplecollected on tDemogrpahics.person_id = tDateheisamplecollected.person_id
left join
(
select tHeiage.person_id, 
case when (12 * (YEAR(date_of_first_eid) - YEAR(birthdate)) + (MONTH(date_of_first_eid) - MONTH(birthdate))) <= 2 then '1' else '' end as 'zerototwomonths',
case when (12 * (YEAR(date_of_first_eid) - YEAR(birthdate)) + (MONTH(date_of_first_eid) - MONTH(birthdate))) > 2 and 
 (12 * (YEAR(date_of_first_eid) - YEAR(birthdate)) + (MONTH(date_of_first_eid) - MONTH(birthdate))) <= 12  then '1' else '' end as 'abovetwomonths'
from(
select * from (
select person_id, concept_id, obs_datetime , encounter_id , value_datetime as 'date_of_first_eid', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date EID sample collected' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Date EID sample collected' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHeiage left join
(select person_id , birthdate from person
)tbirthdate on tHeiage.person_id = tbirthdate.person_id
)tHeiAgeatEidCollection on tDemogrpahics.person_id = tHeiAgeatEidCollection.person_id
left join
(
select pid , tConceptname.name as 'Outcomeat24months' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'Final outcome at 24 months of age' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Final outcome at 24 months of age' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tOutcomeafter24months on tDemogrpahics.person_id = tOutcomeafter24months.pid  