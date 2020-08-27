select  @a:=@a+1 as 'Serial Number', dateSampleCollectedFirstPCR as 'Date DBS sample collected' ,HEI_Number as 'EID Number', Sex ,
(case when enrolledatArtClinic = 'TRUE' THEN (TIMESTAMPDIFF(MONTH,birthdate,enrollmentdateatart)) else 'N/A' end) as 'Age at enrolment(Months)',
(case when (TIMESTAMPDIFF(MONTH,birthdate,enrollmentdateatart)) <= 2 then '1' when (TIMESTAMPDIFF(MONTH,birthdate,enrollmentdateatart)) is null then 'N/A' else '0'  end) as 'Age of child at first DBS sample collection (put 1 where the age belongs)\n0-≤2 months of age' ,
(case when (TIMESTAMPDIFF(MONTH,birthdate,enrollmentdateatart)) > 2  and (TIMESTAMPDIFF(MONTH,birthdate,enrollmentdateatart)) <= 12  then '1' when (TIMESTAMPDIFF(MONTH,birthdate,enrollmentdateatart)) is null then 'N/A' else '0'  end) as 'Age of child at first DBS sample collection (put 1 where the age belongs)\n2-12 months of age',
dateResultRecivedinFacility as 'Date result was delivered to the facility'  , 
(case when infantStatus = 'Negative' then '0' when infantStatus = 'Positive' then '1' else '2' end) as 'HIV Status \n(0=Negative 1=Positive ,2=Unknown)' , 
dateResultGivenToCaregiver as 'Date result given to the parent/care giver', 
(case when infantStatus = 'Positive' and finalstatusforhippositives = 'Referred To ART Clinic' then '1' when infantStatus = 'Positive' and finalstatusforhippositives = 'Died' then '2' when infantStatus = 'Positive' and finalstatusforhippositives = 'Lost' then '3' when infantStatus = 'Positive' and finalstatusforhippositives = 'Unknown' then '4' else 'N/A' end) as 'Linkage status for HIV positives/n(1. Linked to ART; 2 Died; 3. TO ;4.Unknown)',
HEI_Number as 'Unique ART' 
from (
select * from (
select  person_id, (SELECT @a:= 0) AS a , concept_id, value_datetime as 'dateSampleCollectedFirstPCR' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'Date Sample Dispatched to PHL(First PCR Test)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Date Sample Dispatched to PHL(First PCR Test)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateSampleCollectedFirstPCR 
inner join(
select pa.person_id , pa.value as 'HEI_Number' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age' , p.birthdate
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'HIVExposedInfant(HEI)No')
and floor(datediff('#endDate#',p.birthdate) / 365) < 1
)tHeiDemographics on tDateSampleCollectedFirstPCR.person_id = tHeiDemographics.person_id
left join (
select person_id as pid ,enrollmentdateatart  from (
select  person_id, concept_id, value_datetime as 'enrollmentdateatart' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tHeiEnrollmentDate on tDateSampleCollectedFirstPCR.person_id = tHeiEnrollmentDate.pid
left join (
select pid , tConceptname.name as 'enrolledatArtClinic' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Clinic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Treatment - Enrolled AT ART Clinic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)isHeiEnrolledInART on tDateSampleCollectedFirstPCR.person_id = isHeiEnrolledInART.pid
left join (
select * from (
select  person_id, concept_id, value_datetime as 'dateResultRecivedinFacility' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'First PCR,Date results delivered to facility' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'First PCR,Date results delivered to facility' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateResultsReceivedFacility on tDateSampleCollectedFirstPCR.person_id = tDateResultsReceivedFacility.person_id
left join (
select distinct(person_b) as 'mother_id' , relationship , person_a as 'hei_id' from relationship where 
relationship = (select relationship_type_id from relationship_type where a_is_to_b = 'Mother' and retired = 0) and voided = 0
)tHeiToMotherRelationship on tDateSampleCollectedFirstPCR.person_id = tHeiToMotherRelationship.hei_id
left join (
select pid , tConceptname.name as 'infantStatus' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = "Infant HIV Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = "Infant HIV Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tInfantStatus on tHeiToMotherRelationship.mother_id = tInfantStatus.pid
left join(
select * from (
select  person_id, concept_id, value_datetime as 'dateResultGivenToCaregiver' , encounter_id , voided from obs where concept_id =
(select concept_id from concept_name where name = 'HEI Testing (First PCR Date Result Given to Caregiver)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'HEI Testing (First PCR Date Result Given to Caregiver)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tResultsGivenToCareGiver on tDateSampleCollectedFirstPCR.person_id = tResultsGivenToCareGiver.person_id
left join(
select pid , tConceptname.name as 'finalstatusforhippositives' from (
select distinct(person_id) as pid, obs_datetime , value_coded 
 from (
select  person_id, concept_id, obs_datetime , encounter_id , value_coded, voided from obs where concept_id =
(select concept_id from concept_name where name = "Final Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime  between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  and voided = 0
)a inner join 
(select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = "Final Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#endDate#'),'%Y-%m-%d 23:59:59')  group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCodedAnswers 
left join 
(
select concept_id , name from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tCodedAnswers.value_coded = tConceptname.concept_id
)tInfantLinkageForHivpositives on tDateSampleCollectedFirstPCR.person_id = tInfantLinkageForHivpositives.pid

