select 'less than 15 Years' as 'Age Group' ,sex,
count(distinct(case when pid is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'Newly started on ART',
count(distinct(case when tbscreeningCurrentCough is not null or tbscreeningfever is not null or tbscreeningweightloss is not null or tbscreeningNightsweats is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'Screened for TB symptoms',
count(distinct(case when tbscreeningCurrentCough = 1 and tbscreeningfever  = 1 and tbscreeningweightloss = 1 and tbscreeningNightsweats = 1 and age < 15 and sex in ('F', 'M') then pid end)) as 'TB Suspect/Presumptive TB',
count(distinct(case when afbMicroscropicdateresultreceived is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'Specimen Sent to Lab - AFB Microscopy',
count(distinct(case when geneXpertdateresultreceived is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'Specimen Sent to Lab - GeneXpert',
count(distinct(case when crxdateresultreceived is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'Specimen Sent to Lab - Other: X-Ray',
count(distinct(case when istbdiagnosed is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'TB Case',
count(distinct(case when onTBTreatment is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'Treated for TB',
count(distinct(case when scheduledipt is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'No. of ART patients who are scheduled to complete  6 months of IPT/TPT',
count(distinct(case when iptCompleted is not null and age < 15 and sex in ('F', 'M') then pid end)) as 'No. of ART patients  who completed 6 months of IPT/TPT'
from (
select person_id, arvreceivedbefore from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'arvreceivedbefore', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tArvsReceivedBefore
left join(
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M')
)tDemographics on tArvsReceivedBefore.person_id = tDemographics.pid
left join (
select person_id, tbscreeningCurrentCough from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningCurrentCough', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Current Cough' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1, 2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Current Cough' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTBscreeningCurrentCough on tArvsReceivedBefore.person_id = tTBscreeningCurrentCough.person_id
left join(
select person_id, tbscreeningfever from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningfever', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening , Fever' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1,2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening , Fever' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTbScreeningfever on  tArvsReceivedBefore.person_id = tTbScreeningfever.person_id
left join(
select person_id, tbscreeningweightloss from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningweightloss', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening ,Weight loss' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1 , 2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening ,Weight loss' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTBScreeningWeightloss on  tArvsReceivedBefore.person_id = tTBScreeningWeightloss.person_id
left join(
select person_id, tbscreeningNightsweats from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningNightsweats', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening , Night Sweats' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1 , 2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening , Night Sweats' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTBScreeningNightSweats on tArvsReceivedBefore.person_id = tTBScreeningNightSweats.person_id
left join (
select person_id, afbMicroscropicdateresultreceived from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'afbMicroscropicdateresultreceived', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Microscopic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Microscopic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAfbDateresultsreceivedinlab on tArvsReceivedBefore.person_id = tAfbDateresultsreceivedinlab.person_id
left join (
select person_id, geneXpertdateresultreceived from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'geneXpertdateresultreceived', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received, GeneXpert' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received, GeneXpert' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tGenexpertdatereceivedinlab on tArvsReceivedBefore.person_id = tGenexpertdatereceivedinlab.person_id
left join(
select person_id, crxdateresultreceived from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'crxdateresultreceived', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Crx' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Crx' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCrxdateresultreceived on tArvsReceivedBefore.person_id = tCrxdateresultreceived.person_id
left join (
select person_id, istbdiagnosed from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'istbdiagnosed', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Diagnosed?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Diagnosed?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsTBDiagnosed on tArvsReceivedBefore.person_id = tIsTBDiagnosed.person_id
left join (
select person_id, onTBTreatment from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'onTBTreatment', voided from obs where concept_id =
(select concept_id from concept_name where name = 'On TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'On TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tOnTBTreatment on tArvsReceivedBefore.person_id = tOnTBTreatment.person_id
left join(
select person_id, scheduledipt from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'scheduledipt', voided from obs where concept_id =
(select concept_id from concept_name where name = 'IPT Schedule(6months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'IPT Schedule(6months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tscheduledIPT on tArvsReceivedBefore.person_id = tscheduledIPT.person_id
left join(
select person_id, iptCompleted from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'iptCompleted', voided from obs where concept_id =
(select concept_id from concept_name where name = 'IPT Status - TB Screening' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'IPT - Completed' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'IPT Status - TB Screening' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIptCompleted on tArvsReceivedBefore.person_id = tIptCompleted.person_id  group by sex
union all
select '15 Years And Above' as 'Age Group' ,sex,
count(distinct(case when pid is not null and age >= 15 then pid end)) as 'Newly started on ART',
count(distinct(case when tbscreeningCurrentCough is not null or tbscreeningfever is not null or tbscreeningweightloss is not null or tbscreeningNightsweats is not null and age >= 15 then pid end)) as 'Screened for TB symptoms',
count(distinct(case when tbscreeningCurrentCough = 1 and tbscreeningfever  = 1 and tbscreeningweightloss = 1 and tbscreeningNightsweats = 1 and age >= 15 then pid end)) as 'TB Suspect/Presumptive TB',
count(distinct(case when afbMicroscropicdateresultreceived is not null and age >= 15 then pid end)) as 'Specimen Sent to Lab - AFB Microscopy',
count(distinct(case when geneXpertdateresultreceived is not null and age >= 15 then pid end)) as 'Specimen Sent to Lab - GeneXpert',
count(distinct(case when crxdateresultreceived is not null and age >= 15 then pid end)) as 'Specimen Sent to Lab - Other: X-Ray',
count(distinct(case when istbdiagnosed is not null and age >= 15 and sex in ('F', 'M') then pid end)) as 'TB Case',
count(distinct(case when onTBTreatment is not null and age >= 15 and sex in ('F', 'M') then pid end)) as 'Treated for TB',
count(distinct(case when scheduledipt is not null and age >= 15 then pid end)) as 'No. of ART patients who are scheduled to complete  6 months of IPT/TPT',
count(distinct(case when iptCompleted is not null and age >= 15 then pid end)) as 'No. of ART patients  who completed 6 months of IPT/TPT'
from (
select person_id, arvreceivedbefore from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'arvreceivedbefore', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Were ARVS Received?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tArvsReceivedBefore
left join(
select pa.person_id as pid, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex , (datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F', 'M')
)tDemographics on tArvsReceivedBefore.person_id = tDemographics.pid
left join (
select person_id, tbscreeningCurrentCough from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningCurrentCough', voided from obs where concept_id =
(select concept_id from concept_name where name = 'Current Cough' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1, 2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'Current Cough' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTBscreeningCurrentCough on tArvsReceivedBefore.person_id = tTBscreeningCurrentCough.person_id
left join(
select person_id, tbscreeningfever from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningfever', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening , Fever' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1,2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening , Fever' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTbScreeningfever on  tArvsReceivedBefore.person_id = tTbScreeningfever.person_id
left join(
select person_id, tbscreeningweightloss from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningweightloss', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening ,Weight loss' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1 , 2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening ,Weight loss' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTBScreeningWeightloss on  tArvsReceivedBefore.person_id = tTBScreeningWeightloss.person_id
left join(
select person_id, tbscreeningNightsweats from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'tbscreeningNightsweats', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Screening , Night Sweats' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded in (1 , 2) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Screening , Night Sweats' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tTBScreeningNightSweats on tArvsReceivedBefore.person_id = tTBScreeningNightSweats.person_id
left join (
select person_id, afbMicroscropicdateresultreceived from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'afbMicroscropicdateresultreceived', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Microscopic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Microscopic' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tAfbDateresultsreceivedinlab on tArvsReceivedBefore.person_id = tAfbDateresultsreceivedinlab.person_id
left join (
select person_id, geneXpertdateresultreceived from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'geneXpertdateresultreceived', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received, GeneXpert' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received, GeneXpert' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tGenexpertdatereceivedinlab on tArvsReceivedBefore.person_id = tGenexpertdatereceivedinlab.person_id
left join(
select person_id, crxdateresultreceived from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_datetime as 'crxdateresultreceived', voided from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Crx' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
 and voided = 0 )a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name  = 'Date Results Received,  Crx' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0)
 and obs_datetime > '#startDate#' and obs_datetime <= DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tCrxdateresultreceived on tArvsReceivedBefore.person_id = tCrxdateresultreceived.person_id
left join (
select person_id, istbdiagnosed from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'istbdiagnosed', voided from obs where concept_id =
(select concept_id from concept_name where name = 'TB Diagnosed?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'TB Diagnosed?' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIsTBDiagnosed on tArvsReceivedBefore.person_id = tIsTBDiagnosed.person_id
left join (
select person_id, onTBTreatment from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'onTBTreatment', voided from obs where concept_id =
(select concept_id from concept_name where name = 'On TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'On TB Treatment' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tOnTBTreatment on tArvsReceivedBefore.person_id = tOnTBTreatment.person_id
left join(
select person_id, scheduledipt from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'scheduledipt', voided from obs where concept_id =
(select concept_id from concept_name where name = 'IPT Schedule(6months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 1 and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'IPT Schedule(6months)' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tscheduledIPT on tArvsReceivedBefore.person_id = tscheduledIPT.person_id
left join(
select person_id, iptCompleted from (  
select person_id, concept_id, obs_datetime  , encounter_id , value_coded as 'iptCompleted', voided from obs where concept_id =
(select concept_id from concept_name where name = 'IPT Status - TB Screening' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) 
and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')  and value_coded = 
(select concept_id from concept_name where name = 'IPT - Completed' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and voided = 0
)a inner join (select person_id as pid , concept_id as cid, max(encounter_id) maxdate from obs where concept_id = 
(select concept_id from concept_name where name = 'IPT Status - TB Screening' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0) and obs_datetime between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59') group by pid) c on 
a.person_id = c.pid and a.encounter_id = c.maxdate 
)tIptCompleted on tArvsReceivedBefore.person_id = tIptCompleted.person_id group by sex