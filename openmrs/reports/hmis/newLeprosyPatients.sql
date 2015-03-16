select
@a:=@a+1 as SN,
pa.person_id as 'Person Id',
concat(given_name, " ", family_name) as 'Name of New Cases (Patient)',
cv1.concept_full_name as 'Caste Code',
cast(DATEDIFF(CURRENT_DATE, person.birthdate)/365 as decimal(10, 0)) AS Age,
gender as Gender,
county_district as District,
city_village as 'VDC/Municipality',
paddr.address1 as 'Ward No',
-- work around to resolve the conflict in jasper
substring(cv4.concept_full_name, 1, length(cv4.concept_full_name)) as Type,
substring(cv6.concept_full_name, 1, length(cv6.concept_full_name)) as DG
from (select @a:=0) initvars, person_name
join person on person.person_id = person_name.person_id
join person_address as paddr on paddr.person_id = person.person_id
join person_attribute as pa on pa.person_id = person.person_id
join concept_view cv1 on pa.value = cv1.concept_id

join concept_view cv3 on cv3.concept_full_name ='Leprosy, Leprosy Type'
join obs as lepTypeObs on  pa.person_id = lepTypeObs.person_id and lepTypeObs.concept_id = cv3.concept_id
join concept_view cv4 on cv4.concept_id = lepTypeObs.value_coded

join obs as dgObs on  lepTypeObs.obs_group_id = dgObs.obs_group_id and  lepTypeObs.person_id = dgObs.person_id 
join concept_view cv5 on dgObs.concept_id = cv5.concept_id and cv5.concept_full_name ='Leprosy, Disability Grade'
join concept_view cv6 on dgObs.value_coded=cv6.concept_id

where pa.person_id in (select newPatientObs.person_id  from obs as newPatientObs
	join concept_view cv2 on newPatientObs.value_coded = cv2.concept_id and cv2.concept_full_name='New Patients'
	and cast(newPatientObs.obs_datetime AS DATE) BETWEEN '#startDate#' and '#endDate#');