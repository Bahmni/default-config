SELECT p.gender `Gender`,
pa.county_district as `District`, 
pa.city_village as `Muncipality`, 
e.encounter_datetime `Encounter datetime`, 
timestampdiff(YEAR, p.birthdate, e.encounter_datetime) as `Age at visit`,
max(case when o.concept_id in (4565, 5854) then o.value_text end) as `Diagnosis`,
max(case when o.concept_id in (4567, 5857) then o.value_text end) as `Anesthetist`,
max(case when o.concept_id in (4570, 5859) then o.value_text end) as `Anesthesia`,
max(case when o.concept_id in (4566, 5856) then o.value_text end) as `Surgeons`,
(select name from concept_name where concept_id = max(case when o.concept_id in (4568, 354) then o.value_coded end) and concept_name_type = "FULLY_SPECIFIED" and locale='en') as `Procedure`
FROM person p
INNER JOIN person_address pa ON pa.person_id = p.person_id AND pa.voided = 0
INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND o.concept_id in (4565, 4567, 4570, 4566, 4568, 5854, 5857, 5859, 5856, 354)
WHERE p.voided = 0
AND e.encounter_datetime between '#startDate#' and '#endDate#'
group by e.encounter_id
having (`Anesthetist` is not null or `Anesthesia` is not null)