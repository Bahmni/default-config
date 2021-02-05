-- ANC Partner Index contact HIV Counseling and testing

SELECT
  'Couples Pre-test counseled jointly' as 'Title',
  '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

select 
'Partners who had HIV testing' as 'Title',
count(distinct(case when pidd is not null and sexual_partner_age is null and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as 'Unknown age',
count(distinct(case when pidd is not null and sexual_partner_age >= 10 and sexual_partner_age < 15 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '10 - 14 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 15 and sexual_partner_age < 20 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '15 - 19 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 20 and sexual_partner_age < 25 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female') then pidd end)) as '20 - 24 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 25 and sexual_partner_age < 30 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '25 - 29 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 30 and sexual_partner_age < 35 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '30 - 34 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 35 and sexual_partner_age < 40 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '35 - 39 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 40 and sexual_partner_age < 45 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '40 - 44 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 45 and sexual_partner_age < 50 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '45 - 49 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 50 and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as '50+ YRS',
count(distinct(case when pidd is not null and partnerResult in ('Positive','Negative') and sexual_partner_sex in ('Male','Female')  then pidd end)) as 'Total'
from (
select pidd, (case when hiv_result is null and hts_result is null then 'N/A' else case when hiv_result is not null and hts_result is not null then hts_result else case when hiv_result is not null and hts_result is null 
then hiv_result else case when hiv_result is null and hts_result is not null then hts_result end end end end) as 'partnerResult' ,sexual_partner_age, sexual_partner_sex  from (
select person_id as pidd, spouse, obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'spouse', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner Relationship' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = (
select concept_id from concept_name where name = 'Spouse' and concept_name_type = 'FULLY_SPECIFIED') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(obs_group_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner Relationship' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.obs_group_id = c.maxdate 
)tIsSpouse
left join (
select person_id, (select name from concept_name where concept_id = HivKnownStatus and concept_name_type = 'SHORT') as 'hiv_result', obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'HivKnownStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSpouseHivResult on tIsSpouse.obs_group_id = tSpouseHivResult.obs_group_id 
left join (
select person_id, (select name from concept_name where concept_id = NewTestedResult and concept_name_type = 'SHORT') as 'hts_result', obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'NewTestedResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSpouseHivResultAfterTesting on tIsSpouse.obs_group_id = tSpouseHivResultAfterTesting.obs_group_id
left join (
select person_id, gender, birthdate ,(TIMESTAMPDIFF(YEAR, birthdate, '#endDate#')) as 'Age'from person 
)tDemographics on tIsSpouse.pidd = tDemographics.person_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tIsSpouse.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(select name from concept_name where concept_id = value_coded and concept_name_type = 'FULLY_SPECIFIED') as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tIsSpouse.obs_group_id = tSexualPartnerGender.obs_group_id
)p

UNION ALL

select 
'Partners testing HIV positive' as 'Title',
count(distinct(case when pidd is not null and sexual_partner_age is null and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as 'Unknown age',
count(distinct(case when pidd is not null and sexual_partner_age >= 10 and sexual_partner_age < 15 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '10 - 14 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 15 and sexual_partner_age < 20 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '15 - 19 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 20 and sexual_partner_age < 25 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female') then pidd end)) as '20 - 24 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 25 and sexual_partner_age < 30 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '25 - 29 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 30 and sexual_partner_age < 35 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '30 - 34 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 35 and sexual_partner_age < 40 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '35 - 39 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 40 and sexual_partner_age < 45 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '40 - 44 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 45 and sexual_partner_age < 50 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '45 - 49 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 50 and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '50+ YRS',
count(distinct(case when pidd is not null and partnerResult  =  'Positive' and sexual_partner_sex in ('Male','Female')  then pidd end)) as 'Total'
from (
select pidd, (case when hiv_result is null and hts_result is null then 'N/A' else case when hiv_result is not null and hts_result is not null then hts_result else case when hiv_result is not null and hts_result is null 
then hiv_result else case when hiv_result is null and hts_result is not null then hts_result end end end end) as 'partnerResult' ,sexual_partner_age, sexual_partner_sex  from (
select person_id as pidd, spouse, obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'spouse', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner Relationship' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = (
select concept_id from concept_name where name = 'Spouse' and concept_name_type = 'FULLY_SPECIFIED') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(obs_group_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner Relationship' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.obs_group_id = c.maxdate 
)tIsSpouse
left join (
select person_id, (select name from concept_name where concept_id = HivKnownStatus and concept_name_type = 'SHORT') as 'hiv_result', obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'HivKnownStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSpouseHivResult on tIsSpouse.obs_group_id = tSpouseHivResult.obs_group_id 
left join (
select person_id, (select name from concept_name where concept_id = NewTestedResult and concept_name_type = 'SHORT') as 'hts_result', obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'NewTestedResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSpouseHivResultAfterTesting on tIsSpouse.obs_group_id = tSpouseHivResultAfterTesting.obs_group_id
left join (
select person_id, gender, birthdate ,(TIMESTAMPDIFF(YEAR, birthdate, '#endDate#')) as 'Age'from person 
)tDemographics on tIsSpouse.pidd = tDemographics.person_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tIsSpouse.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(select name from concept_name where concept_id = value_coded and concept_name_type = 'FULLY_SPECIFIED') as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tIsSpouse.obs_group_id = tSexualPartnerGender.obs_group_id
)p

UNION ALL

select 
'Partners with discordant results' as 'Title',
count(distinct(case when pidd is not null and sexual_partner_age is null and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as 'Unknown age',
count(distinct(case when pidd is not null and sexual_partner_age >= 10 and sexual_partner_age < 15 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '10 - 14 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 15 and sexual_partner_age < 20 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '15 - 19 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 20 and sexual_partner_age < 25 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female') then pidd end)) as '20 - 24 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 25 and sexual_partner_age < 30 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '25 - 29 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 30 and sexual_partner_age < 35 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '30 - 34 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 35 and sexual_partner_age < 40 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '35 - 39 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 40 and sexual_partner_age < 45 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '40 - 44 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 45 and sexual_partner_age < 50 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '45 - 49 YRS',
count(distinct(case when pidd is not null and sexual_partner_age >= 50 and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as '50+ YRS',
count(distinct(case when pidd is not null and partnerResult  =  'Negative' and sexual_partner_sex in ('Male','Female')  then pidd end)) as 'Total'
from (
select pidd, (case when hiv_result is null and hts_result is null then 'N/A' else case when hiv_result is not null and hts_result is not null then hts_result else case when hiv_result is not null and hts_result is null 
then hiv_result else case when hiv_result is null and hts_result is not null then hts_result end end end end) as 'partnerResult' ,sexual_partner_age, sexual_partner_sex  from (
select person_id as pidd, spouse, obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'spouse', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner Relationship' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = (
select concept_id from concept_name where name = 'Spouse' and concept_name_type = 'FULLY_SPECIFIED') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(obs_group_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner Relationship' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.obs_group_id = c.maxdate 
)tIsSpouse
left join (
select person_id, (select name from concept_name where concept_id = HivKnownStatus and concept_name_type = 'SHORT') as 'hiv_result', obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'HivKnownStatus', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner - HIV Result' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSpouseHivResult on tIsSpouse.obs_group_id = tSpouseHivResult.obs_group_id 
left join (
select person_id, (select name from concept_name where concept_id = NewTestedResult and concept_name_type = 'SHORT') as 'hts_result', obs_group_id from (  
select person_id, concept_id, obs_datetime  , obs_group_id, encounter_id , value_coded as 'NewTestedResult', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Sexual Partner - Result of HTS' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tSpouseHivResultAfterTesting on tIsSpouse.obs_group_id = tSpouseHivResultAfterTesting.obs_group_id
left join (
select person_id, gender, birthdate ,(TIMESTAMPDIFF(YEAR, birthdate, '#endDate#')) as 'Age'from person 
)tDemographics on tIsSpouse.pidd = tDemographics.person_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
value_numeric as 'sexual_partner_age'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Age' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerAge on tIsSpouse.obs_group_id = tSexualPartnerAge.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(select name from concept_name where concept_id = value_coded and concept_name_type = 'FULLY_SPECIFIED') as 'sexual_partner_sex'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Sexual Partner - Sex' and concept_name_type = 'FULLY_SPECIFIED')
and voided = 0 and obs_datetime 
between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tSexualPartnerGender on tIsSpouse.obs_group_id = tSexualPartnerGender.obs_group_id
)p
  
UNION ALL

 select 
'Index Case Contact Tested' as 'Title',
count(distinct(case when Names is not null and ContactsAge is null and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as 'Unknown age',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '10 - 14 YRS',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '15 - 19 YRS',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES' and PatnerGender in ('M','F') then Names end)) as '20 - 24 YRS',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '25 - 29 YRS',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '30 - 34 YRS',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '35 - 39 YRS',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '40 - 44 YRS',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '45 - 49 YRS',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as '50+ YRS',
count(distinct(case when Names is not null and ContactsAge >= 10 and wasContactTested = 'YES' and PatnerGender in ('M','F')  then Names end)) as 'Total'

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
) then 'Positive' else 'Negative' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'sexual_partner_hts_result'
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
) then 'Positive' else 'Negative' end ) as 'sexual_partner_known_positives'
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

UNION ALL

select 
'Index Case contacts positive'as'Title',
count(distinct(case when Names is not null and ContactsAge is null and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as 'Unknown age',
count(distinct(case when Names is not null and ContactsAge >= 10 and ContactsAge < 15 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '10 - 14 YRS',
count(distinct(case when Names is not null and ContactsAge >= 15 and ContactsAge < 20 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '15 - 19 YRS',
count(distinct(case when Names is not null and ContactsAge >= 20 and ContactsAge < 25 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F') then Names end)) as '20 - 24 YRS',
count(distinct(case when Names is not null and ContactsAge >= 25 and ContactsAge < 30 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '25 - 29 YRS',
count(distinct(case when Names is not null and ContactsAge >= 30 and ContactsAge < 35 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '30 - 34 YRS',
count(distinct(case when Names is not null and ContactsAge >= 35 and ContactsAge < 40 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '35 - 39 YRS',
count(distinct(case when Names is not null and ContactsAge >= 40 and ContactsAge < 45 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '40 - 44 YRS',
count(distinct(case when Names is not null and ContactsAge >= 45 and ContactsAge < 50 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '45 - 49 YRS',
count(distinct(case when Names is not null and ContactsAge >= 50 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as '50+ YRS',
count(distinct(case when Names is not null and ContactsAge >= 10 and wasContactTested = 'YES' and (newHivResults is not null or KnownPositiveResults is not null) and PatnerGender in ('M','F')  then Names end)) as 'Total'

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
) then 'Positive' else 'Negative' end ) as 'family_member_hts_result'
from obs o 
where concept_id = (select concept_id from concept_name where name = 'Result of HTS' and concept_name_type = 'FULLY_SPECIFIED')
 and voided = 0 and obs_datetime 
 between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tFamilyResultsHTS on tSexualRelationship.obs_group_id = tFamilyResultsHTS.obs_group_id
left join (
select person_id , encounter_id , obs_datetime , obs_group_id ,
(case when value_coded = (select concept_id from concept_name where name = 'Positive' and concept_name_type = 'FULLY_SPECIFIED'
) then 'Positive' else 'Negative' end ) as 'sexual_partner_hts_result'
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
) then 'Positive' else 'Negative' end ) as 'sexual_partner_known_positives'
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