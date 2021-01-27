select 'Less than 1 Year' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge < 1 then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge < 1 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge < 1 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge < 1 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge < 1 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge < 1 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge < 1 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender

union all 

select '1 - 4 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 1 and ContactsAge < 5 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender


union all 

select '5 - 9 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 5 and ContactsAge < 10 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender

union all 

select '10 - 14 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender

union all 

select '15 - 19 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender

union all 

select '20 - 24 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender


union all 

select '25 - 29 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender



union all 

select '30 - 34 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender



union all 

select '35 - 39 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender


union all 

select '40 - 44 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender

union all 

select '45 - 49 Years' as 'Age group',PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50  then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender

union all 

select '50 Years and Above' as 'Age group', PatnerGender as 'Sex',
count(distinct(case when Names is not null and ContactsAge >= 50 then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null and ContactsAge >= 50 then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null and ContactsAge >= 50 and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and ContactsAge >= 50 and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null and ContactsAge >= 50 and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null and ContactsAge >= 50 and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender


union all 

select 'Totals' as 'Age group', PatnerGender as 'Sex',
count(distinct(case when Names is not null then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null  and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null  then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null  and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null  and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null  and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b group by PatnerGender


union all 

select 'Total All' as 'Age group', PatnerGender as 'Sex',
count(distinct(case when Names is not null then Names end)) as 'Number of Index cases offered index testing services',
count(distinct(case when Names is not null  and wasContactTested = 'YES' then Names end)) as 'Number of index cases that accepted index testing services',
count(distinct(case when Names is not null  then Names end)) as 'Number of contacts elicited (brought)',
count(distinct(case when Names is not null  and newHivResults = 'Negative' then Names end)) as 'New Negative',
count(distinct(case when Names is not null and newHivResults = 'Positive' then Names end)) as 'New Positive',
count(distinct(case when Names is not null  and KnownPositiveResults = 'Positive' then Names end)) as 'Known Positive',
count(distinct(case when Names is not null  and (wasContactTested = 'NO' or wasContactTested is null)  then Names end)) as 'Not Tested'
from (
select ClientName as 'IndexName' , artnumber , ContactsAge , Age , sex , Names ,wasContactTested,
(case when PatnerGender = (select concept_id from concept_name where name = 'Male' and concept_name_type = 'FULLY_SPECIFIED') then 'M' else 'F' end) as 'PatnerGender' 
, isHivStatusKnown , newHivResults , KnownPositiveResults
  from (
select person_id as 'pid' , value as 'newpatientid' from person_attribute where person_attribute_type_id = (SELECT person_attribute_type_id FROM openmrs.person_attribute_type where name = 'TypeofPatient'
)and value =(select concept_id  from concept_name where name = 'NewPatient' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
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
inner join (
select pid , 
(case when sexual_partner = 'YES' then sexual_partner_names else family_member_names end) as 'Names',
(case when sexual_partner = 'YES' then sexual_partner_age else family_partner_age end) as 'ContactsAge',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested',
(case when sexual_partner = 'YES' then sexual_partner_sex else family_partner_sex end) as 'PatnerGender',
(case when sexual_partner = 'YES' then sexualPartnerKnownHiv else familyMemberKnownHiv end) as 'isHivStatusKnown',
(case when sexual_partner = 'YES' then sexual_partner_hts_result else family_member_hts_result end) as 'newHivResults',
(case when sexual_partner = 'YES' then sexual_partner_known_positives else family_known_positives end) as 'KnownPositiveResults'
from (
select person_id as pid , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = '1' then 'YES' else 'No' end) as 'sexual_partner'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualRelationship 
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual partner names' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerNames on tSexualRelationship.obs_group_id = tSexualPartnerNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'family_member_names'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member names' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberNames on tSexualRelationship.obs_group_id = tFamilyMemberNames.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tSexualRelationship.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'family_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyPartnerAge on tSexualRelationship.obs_group_id = tFamilyPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'family_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - Sex' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberSex on tSexualRelationship.obs_group_id = tFamilyMemberSex.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_coded as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tSexualRelationship.obs_group_id = tSexualPartnerGender.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'NO' end ) as 'familyMemberKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnowStatus on tSexualRelationship.obs_group_id = tFamilyMemberKnowStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED')
 then 'Known' else 'NO' end ) as 'sexualPartnerKnownHiv'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownHivStatus on tSexualRelationship.obs_group_id = tSexualPartnerKnownHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Known' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Known' else 'UnKnown' end ) as 'familyMemberKnowHivStatus'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member - HIV Status' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberHivStatus on tSexualRelationship.obs_group_id = tFamilyMemberHivStatus.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerHTS on tSexualRelationship.obs_group_id = tSexualPartnerHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'family_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberKnownPostive on tSexualRelationship.obs_group_id = tFamilyMemberKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'NO' end ) as 'sexual_partner_known_positives'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerKnownPostive on tSexualRelationship.obs_group_id = tSexualPartnerKnownPostive.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Tested?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerTested on tSexualRelationship.obs_group_id = tSexualPartnerTested.obs_group_id
left join ( 
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberTested'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Tested?' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberTested on tSexualRelationship.obs_group_id = tFamilyMemberTested.obs_group_id
)tContacts on tDemographics.person_id = tContacts.pid
)b 




































