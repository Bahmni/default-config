select  @a:=@a+1 as 'Serial Number' , dateMotherVisitedMaternity as 'Date of visit' , ClientName as 'Mothers Name' , IFNULL(telephonenumber,'N/A') as 'Telephone  number', Age , ifnull(address5,'N/A') as 'Name of village or Address' ,  ancnummber
as 'ANC Number' , maternitynumber as 'Maternity Number' , artnumber as 'ART No' , results as 'Previous HIV test result (recent/ within 6 months)\nTest Result' , 
placetestedhiv  as 'Previous HIV test result (recent/ within 6 months)\nPlace Tested' , datetestedhiv as 'Previous HIV test result (recent/ within 6 months)\nDate Tested' , 
(case when ismothertestedinmaternity = 1 then datetestedinmaternity else 'N/A' end) as 'Date tested in Maternity' , finalresultaftertestinginmaternity  as 'Final Result After testing \nin maternity', 
(case when finalresultaftertestinginmaternity = 'Positive' then artRegimenDuringPregnancyResults else 'N/A' end) as 'ART Regimen During Pregnancy',
(case when finalresultaftertestinginmaternity = 'Positive' then durationinartResults else 'N/A' end)  as 'Duration on ART' ,
 infantriskstatusResults as "Infant's Risk Status" , 
(case when finalresultaftertestinginmaternity = 'Positive' then concat("1  : ", "  ", artRegimenDuringPregnancyResults) when finalresultaftertestinginmaternity = 'Negative' then 0 else 'N/A' end) as 'ART: Newly Started in Labour:\n(0=No 1= yes 2=N/A):\nIf yes, indicate the regimen in the lower cell' ,
(case when infantpmtctarvsresults = 'NVP' then 1 when  infantpmtctarvsresults = 'AZT+NVP' then 2 else 'N/A' end) as 'Infant ARV Prophylaxis 1=NVP , 2=AZT+NVP:\nARV Code',
(case when infantpmtctarvsresults = 'NVP' then nvpDate when  infantpmtctarvsresults = 'AZT+NVP' then aztnvpDate else 'N/A' end) as 'Infant ARV Prophylaxis 1=NVP , 2=AZT+NVP:\nDate Given',
(case when infantpmtctarvsresults = 'NVP' then 1 when  infantpmtctarvsresults = 'AZT+NVP' then 2 else 'N/A' end) as 'ARV Baby Discharged with :\n1=NVP ,  2=AZT+NVP',
(case when infantdeedingResults = 'EBF' then 1 when  infantdeedingResults = 'RF' then 2 when  infantdeedingResults = 'Mixed Feeding(> 6 Months)' then 3 else 'N/A' end) as 'Infant Feeding practice:\n 1=EBF 2=RF 3=MF',
heinumber as 'Exposed Infant Number'
from (
select  (SELECT @a:= 0) AS a ,person_id as pid, dateMotherVisitedMaternity 
 from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'dateMotherVisitedMaternity', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Maternity card, Date tested in Maternity' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Maternity card, Date tested in Maternity' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tMaternityVisitDate left join
(
select person_b as 'mother_id' , relationship , person_a as 'hei_id' from relationship where 
relationship = (select relationship_type_id from relationship_type where a_is_to_b = 'Mother' and retired = 0) and voided = 0
)texposedInfantNumber on tMaternityVisitDate.pid = texposedInfantNumber.mother_id
left join
(
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender = 'F' and gender is not null
)tDemogrpahics on tMaternityVisitDate.pid = tDemogrpahics.person_id
left join (
select person_id, ancnummber from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_text as 'ancnummber', voided from obs where concept_id =
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_text is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAncNumber on  tMaternityVisitDate.pid = tAncNumber.person_id
left join(
select person_id, maternitynumber from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_text as 'maternitynumber', voided from obs where concept_id =
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_text is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'ANC No' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tMaternityNumber on tMaternityVisitDate.pid = tMaternityNumber.person_id
left join (
select person_id , results from (
select person_id, testResultWithin6months from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'testResultWithin6months', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Previous HIV test result(Within 6 months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Previous HIV test result(Within 6 months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'results' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.testResultWithin6months = tConceptname.concept_id
)tResultswithin6Months on tMaternityVisitDate.pid = tResultswithin6Months.person_id
left join (
select person_id, placetestedhiv from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_text as 'placetestedhiv', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card, Place Test Hiv' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_text is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card, Place Test Hiv' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tplaceTestedHiv on tMaternityVisitDate.pid = tplaceTestedHiv.person_id
left join (
select person_id , datetestedhiv from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'datetestedhiv', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Maternity card, Date Test Hiv' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Maternity card, Date Test Hiv' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateTestedHiv on tMaternityVisitDate.pid = tDateTestedHiv.person_id
left join (
select person_id , ismothertestedinmaternity from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'ismothertestedinmaternity', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card, Mother tested in Maternity' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card, Mother tested in Maternity' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsmothertestedinmaternity on tMaternityVisitDate.pid = tIsmothertestedinmaternity.person_id
left join (
select person_id , datetestedinmaternity from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'datetestedinmaternity', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Maternity card, Date tested in Maternity' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Maternity card, Date tested in Maternity' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tDateTestedinMaternity on tMaternityVisitDate.pid = tDateTestedinMaternity.person_id
left join (
select person_id , finalresultaftertestinginmaternity from (
select person_id, finalmaternityresults from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'finalmaternityresults', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card, Status After Testing HIV' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card, Status After Testing HIV' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'finalresultaftertestinginmaternity' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.finalmaternityresults = tConceptname.concept_id
)tFinalResultAfterTestingInmaternity on tMaternityVisitDate.pid = tFinalResultAfterTestingInmaternity.person_id
left join(
select person_id , artRegimenDuringPregnancyResults from (
select person_id, artregimenduringpregnancy from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'artregimenduringpregnancy', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card, ART Regimen During Pregnacy' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card, ART Regimen During Pregnacy' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'artRegimenDuringPregnancyResults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.artregimenduringpregnancy = tConceptname.concept_id
)tArtRegimenDuringPRegnancy on tMaternityVisitDate.pid = tArtRegimenDuringPRegnancy.person_id
left join (
select person_id , durationinartResults from (
select person_id, durationinart from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'durationinart', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Duration on ART?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Duration on ART?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'durationinartResults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.durationinart = tConceptname.concept_id
)tDurationOnArts on texposedInfantNumber.hei_id = tDurationOnArts.person_id
left join (
select person_id , infantriskstatusResults from (
select person_id, infantriskstatus from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'infantriskstatus', voided from obs where concept_id =
(select concept_id from concept_name where name = "Infant's Risk Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = "Infant's Risk Status" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'infantriskstatusResults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.infantriskstatus = tConceptname.concept_id
)tInfantsRiskStatus on tMaternityVisitDate.pid = tInfantsRiskStatus.person_id
left join (
select person_id , ARTNewlystartedinLabor from (
select person_id, artNewlyStarted from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'artNewlyStarted', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Maternity card,ART Newly Started in Labor' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Maternity card,ART Newly Started in Labor' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'ARTNewlystartedinLabor' from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tresults.artNewlyStarted = tConceptname.concept_id
)tArtStartedInLabour on tMaternityVisitDate.pid = tArtStartedInLabour.person_id
left join (
select person_id , infantpmtctarvsresults from (
select person_id, infantpmtctarvs from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'infantpmtctarvs', voided from obs where concept_id =
(select concept_id from concept_name where name = "Infant's PMTCT ARVS" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = "Infant's PMTCT ARVS" and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'infantpmtctarvsresults' from concept_name where concept_name_type = 'FULLY_SPECIFIED' and voided = 0
)tConceptname on tresults.infantpmtctarvs = tConceptname.concept_id
)tInfantPmtctARV on texposedInfantNumber.hei_id = tInfantPmtctARV.person_id
left join (
select person_id , nvpDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'nvpDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Daily NVP Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Daily NVP Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tNvpDate on texposedInfantNumber.hei_id = tNvpDate.person_id
left join (
select person_id , aztnvpDate from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'aztnvpDate', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'AZT+NVP Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'AZT+NVP Date' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAztnvpDate on texposedInfantNumber.hei_id = tAztnvpDate.person_id
left join (
select person_id , infantdeedingResults from (
select person_id, infantdeeding from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'infantdeeding', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Infant Feeding' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded is not null and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Infant Feeding' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and 
obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tresults left join
(
select concept_id , name as 'infantdeedingResults' from concept_name where concept_name_type = 'SHORT' and voided = 0
)tConceptname on tresults.infantdeeding = tConceptname.concept_id
)tInfantFeeding on texposedInfantNumber.hei_id = tInfantFeeding.person_id
left join (
select mother_id, eid , heinumber from (
select person_b as 'mother_id' , relationship , person_a as 'hei_id' from relationship where 
relationship = (select relationship_type_id from relationship_type where a_is_to_b = 'Mother' and retired = 0) and voided = 0
)heiRelationship
left join(
select pa.person_id as 'eid', pa.value as 'heinumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'HIVExposedInfant(HEI)No') and gender is not null
)tHeiDemographics on heiRelationship.hei_id = tHeiDemographics.eid
)tHeiNumber on tMaternityVisitDate.pid = tHeiNumber.mother_id
left join (
select pa.person_id , pa.value as 'telephonenumber' 
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'MobileNumber')
)tTelephonenumber on tMaternityVisitDate.pid = tTelephonenumber.person_id
left join(
select person_id , address5 , voided from person_address where voided = 0 and address5 is not null
)tVillage on tMaternityVisitDate.pid = tVillage.person_id

