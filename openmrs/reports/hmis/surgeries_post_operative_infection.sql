select rag.name,cn.name as SurgeryType,coded_concept_name.name as Diagnosis,va.value_reference,
  SUM(IF(p.gender = 'F', 1, 0)) AS female,
  SUM(IF(p.gender = 'M', 1, 0)) AS male
from visit v
  INNER JOIN encounter diagnosis_encounter on v.visit_id = diagnosis_encounter.visit_id
  INNER JOIN obs diagnosis_obs on diagnosis_encounter.encounter_id = diagnosis_obs.encounter_id
  INNER JOIN concept_name diagnosis_concept_name on diagnosis_concept_name.concept_id = diagnosis_obs.concept_id
  INNER JOIN concept_name coded_concept_name on coded_concept_name.concept_id = diagnosis_obs.value_coded
  INNER JOIN encounter e on v.visit_id = e.visit_id
  INNER JOIN obs obs on e.encounter_id = obs.encounter_id
  INNER JOIN concept_name cn on cn.concept_id = obs.concept_id
  INNER JOIN person p on p.person_id = obs.person_id
  INNER JOIN visit_attribute va on va.visit_id = v.visit_id
  INNER JOIN reporting_age_group rag ON rag.report_group_name = 'All Ages' AND
                                        obs.obs_datetime BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days DAY))
                                        AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
where cn.name in ('Operative Notes, Procedure','Procedure Notes, Procedure') 
      and diagnosis_concept_name.name = 'Coded Diagnosis' and diagnosis_concept_name.concept_name_type = 'FULLY_SPECIFIED'
      and coded_concept_name.name in ('Infection of obstetric surgical wound','Infection and inflammatory reaction due to other internal orthopedic prosthetic devices, implants and grafts, initial encounter','Infection following a procedure') and coded_concept_name.concept_name_type = 'FULLY_SPECIFIED'
GROUP BY rag.name,cn.name,coded_concept_name.name,va.value_reference;