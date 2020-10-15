select ClientName as 'Index Name' , artnumber as 'ART Number' , Names as 'Contact Name' ,PhoneNumber as 'Contact Phone Number' , wasContacted as 'Contacted ?' , wasContactTested as 'Tested ?' from (
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
sexual_partner as 'Sexual Partner',
(case when sexual_partner = 'YES' then sexual_partner_phone_number else family_member_phonenumber end) as 'PhoneNumber', 
(case when sexual_partner = 'YES' then sexualPartnerContacted else familyMemberContacted end) as 'wasContacted',
(case when sexual_partner = 'YES' then sexualPartnerTested else familyMemberTested end) as 'wasContactTested'
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
value_text as 'family_member_phonenumber'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Family Member,Phone Number' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberMobile on tSexualRelationship.obs_group_id = tFamilyMemberMobile.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_text as 'sexual_partner_phone_number'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner, Phone Number' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerPhoneNumber on tSexualRelationship.obs_group_id = tSexualPartnerPhoneNumber.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'sexualPartnerContacted'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Sexual Partner Contacted?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerContacted on tSexualRelationship.obs_group_id = tSexualPartnerContacted.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = 1 then 'YES' else 'NO' end ) as 'familyMemberContacted'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Was Family Member Contact Contacted?' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyMemberContacted on tSexualRelationship.obs_group_id = tFamilyMemberContacted.obs_group_id
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




