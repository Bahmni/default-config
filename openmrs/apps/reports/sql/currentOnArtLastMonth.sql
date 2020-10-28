select '<1 YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age < 1  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age < 1  then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age < 1  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '1-4  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 1 and age < 5  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 1 and age < 5 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 1 and age < 5  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '5-9  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >=5  and age < 10  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 5 and age < 10 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 5 and age < 10  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '10-14  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 10 and age < 15  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 10 and age < 15 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 10 and age < 15  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '15-19  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 19 and age < 20  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 19 and age < 20 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 19 and age < 20  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '20-24  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 20 and age < 25  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 20 and age < 25 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 20 and age < 25  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '25-29  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 25 and age < 30  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 25 and age < 30 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 25 and age < 30  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '30-34  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 30 and age < 35  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 30 and age < 35 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 30 and age < 35  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '35-39  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 35 and age < 40  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 35 and age < 40 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 35 and age < 40  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '40-44  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 40 and age < 45  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 40 and age < 45 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 40 and age < 45  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '45-49  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 45 and age < 50  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 45 and age < 50 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 45 and age < 50  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '50+ YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 50  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 50 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 50 then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select 'Total adults and children on 1st-line regimens' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F'  then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F')  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select null , null , null , null
union all
select "On 2nd-line ARV regimen", null , null , null
union all
select '<1 YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age < 1  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age < 1  then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age < 1  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '1-4  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 1 and age < 5  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 1 and age < 5 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 1 and age < 5  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '5-9  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >=5  and age < 10  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 5 and age < 10 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 5 and age < 10  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '10-14  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 10 and age < 15  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 10 and age < 15 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 10 and age < 15  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '15-19  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 19 and age < 20  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 19 and age < 20 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 19 and age < 20  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '20-24  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 20 and age < 25  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 20 and age < 25 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 20 and age < 25  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '25-29  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 25 and age < 30  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 25 and age < 30 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 25 and age < 30  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '30-34  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 30 and age < 35  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 30 and age < 35 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 30 and age < 35  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '35-39  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 35 and age < 40  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 35 and age < 40 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 35 and age < 40  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '40-44  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 40 and age < 45  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 40 and age < 45 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 40 and age < 45  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '45-49  YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 45 and age < 50  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 45 and age < 50 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 45 and age < 50  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select '50+ YRS' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' and age >= 50  then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F' and age >= 50 then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F') and age >= 50 then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select 'Total adults and children on 2nd-line regimens' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F'  then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F')  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id
union all
select 'Total current on ART\n(Adults and children on 1st & 2nd-line regimens)' as 'ARV regimen at end of Last Month',
count(distinct(case when person_id is not null and sex = 'M' then person_id end)) as 'Male',
count(distinct(case when person_id is not null and sex = 'F'  then person_id end)) as 'Female',
count(distinct(case when person_id is not null and sex in ('M','F')  then person_id end)) as 'Total'
from (
select pa.person_id, pa.value as 'artnumber' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), ' ', coalesce(family_name , '') ) as 'ClientName', 
gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age'
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
where pa.person_attribute_type_id = (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and gender in ('F','M')
)tDemographics inner join (
select patient_id as pat_id from (
select o.patient_id , o.concept_id , o.date_activated , o.voided , o.encounter_id , dr.name , o.date_stopped
from orders o 
inner join drug dr on o.concept_id = dr.concept_id 
where  o.date_stopped is null and order_reason_non_coded is null 
and date_activated  between DATE_FORMAT('#startDate#' - INTERVAL 1 MONTH ,'%Y-%m-01') and (DATE_FORMAT(LAST_DAY('#startDate#' - INTERVAL 1 MONTH),'%Y-%m-%d 23:59:59'))
and name in ('2a=AZT/3TC+DTG','2b=ABC/3TC+DTG','2c=TDF+3TC+LPV/r','2d=TDF/3TC+ATV/r',
'2e=TDF/FTC-LPV/r','2f=TDF/FTC-ATV/r','2g=AZT/3TC+LPV/r','2h=AZT/3TC+ATV/r',
'2i=ABC/3TC+LPV/r','2j=ABC/3TC+ATV/r','2k=TDF/3TC/DTG','5a = AZT/3TC+LPV/r','5b = AZT/3TC +RAL',
'5c = ABC/3TC (120/60) + RAL','5d = AZT/3TC +ATV/r','5e = ABC/3TC + ATV/r','5f = TDF/3TC + ATV/r',
'5g = AZT/3TC +DTG','5h = ABC/3TC + DTG*','5i = ABC/3TC +LPV/r','1a = AZT/3TC+EFV' , '1b = AZT/3TC/NVP', '1c = TDF/3TC/DTG','1d=ABC/3TC (600/300)/DTG',
'1e = AZT/3TC +DTG','1f = TDF/3TC+EFV','1g = TDF/3TC+NVP', '1h = TDF/FTC/EFV', '4a = AZT/3TC+NVP','4b = AZT/3TC +EFV','4c = TDF/3TC (120/60) + LPV/r','4d = ABC/3TC (120/60) +DTG',
'4f = ABC/3TC +NVP','4g = TDF/3TC (120/60) + EFV (200mg)','4h = TDF/FTC/EFV','4i = ABC/3TC +LPV/r','4J = AZT/3TC (60/30)+LPV/r',
'4k = TDF/3TC+NVP','4i = ABC/3TC +AZT','ABC/3TC+LPV/r','ABC/3TC+DTG','TDF/3TC/DTG','AZT+NVP','AZT+3TC+LPV/r','AZT+3TC+NVP','ABC+3TC+LPV/r','ABC+3TC+EFV','AZT+3TC+RAL',
'ABC+3TC+RAL','AZT+3TC+EFV','ABC+3TC+DTG','AZT+ 3TC+EFV','TDF+3TC+DTG','AZT/3TC+EFV','ABC/3TC AZT','ABC/3TC+LPV/r+RTV',
'ABC/3TC+double dose DTG*','ABC/3TC+EFV','ABC/3TC+AZT')
)a  inner join ( select patient_id as pid, concept_id as cid, max(date_activated) maxdate from orders 
where date_stopped is null
group by pid ) c on a.patient_id = c.pid and a.date_activated = c.maxdate group by pat_id
)tCurrentFirstLineRegimen on tDemographics.person_id = tCurrentFirstLineRegimen.pat_id




