Select concat(coalesce(given_name,''),' ', coalesce(middle_name,'') ,' ',coalesce(family_name,'') ) as 'Full Names' ,value as 'Unique ART Number', 
tMaternalOutcome.maternal_outcome as 'Maternal outcome at last follow up', tInfantfinalstatus.infant_final_status as 'Infant Final Status' ,
tDateMotherTranferredtoArt.Date_mother_transferred_to_art as 'Date mother/baby transferred to ART', tInfantsArtNumber.infants_art_number as 'infants_art_number'
 from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created between '#startDate#' and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tUniqueART 
left join 
(
select distinct(person_id) , concept_short_name as 'maternal_outcome' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) b on obs.person_id = b.person_id and obs.encounter_id = b.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where name = 'Maternal Outcome(last  Follow up)' and concept_name_type = 'Fully_specified') and obs.voided = 0
)maternalOutcome
)tMaternalOutcome on tUniqueART.personid = tMaternalOutcome.person_id
left join 
(
select distinct(person_id) , concept_short_name as 'infant_final_status' from(
select obs.person_id , obs.value_coded,concept_view.concept_short_name,obs.obs_id , obs.encounter_id
from obs 
inner join (select person_id , concept_id , max(encounter_id) maxdate from obs group by person_id) c on obs.person_id = c.person_id and obs.encounter_id = c.maxdate 
inner join concept_view on obs.value_coded=concept_view.concept_id inner join concept on obs.concept_id=concept.concept_id
where concept.concept_id= (select concept_id from concept_name where uuid = '547114dd-fa20-4a8b-8df9-4ac17a922423' and concept_name_type = 'Fully_specified') and obs.voided = 0
)infantfinalstatus
)tInfantfinalstatus on tUniqueART.personid = tInfantfinalstatus.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_datetime as 'Date_mother_transferred_to_art' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Date Mother/Baby Transferred to ART' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tDateMotherTranferredtoArt  on tUniqueART.personid = tDateMotherTranferredtoArt.person_id
left join
(
select obs.person_id,obs.concept_id , obs.value_text as 'infants_art_number' 
from obs obs
left join concept_name cn on obs.concept_id = cn.concept_id
where cn.name = 'Infants ART Number(For Confimed Positive Infants)' and cn.concept_name_type = 'fully_specified' and obs.voided = 0 group by obs.person_id
)tInfantsArtNumber on tUniqueART.personid = tInfantsArtNumber.person_id

