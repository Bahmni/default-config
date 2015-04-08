select rag.name,cn.name as SurgeryType, diagnosis.name as Diagnosis, va.value_reference,
  SUM(IF(p.gender = 'F', 1, 0)) AS female,
  SUM(IF(p.gender = 'M', 1, 0)) AS male
from visit diagnosis_visit
  INNER JOIN confirmed_diagnosis_view diagnosis on diagnosis.visit_id = diagnosis_visit.visit_id
        and diagnosis.name in ('Infection of obstetric surgical wound','Infection and inflammatory reaction due to other internal orthopedic prosthetic devices, implants and grafts, initial encounter','Infection following a procedure')
        AND DATE(diagnosis_visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
  INNER JOIN encounter diagnosis_encounter on diagnosis_encounter.visit_id = diagnosis.visit_id
  INNER JOIN obs all_obs on diagnosis_encounter.encounter_id = all_obs.encounter_id and all_obs.voided is FALSE
  INNER JOIN concept_name cn on cn.concept_id = all_obs.concept_id and cn.name in ('Operative Notes, Procedure','Procedure Notes, Procedure')
  INNER JOIN person p on p.person_id = all_obs.person_id
  INNER JOIN visit_attribute va on va.visit_id = diagnosis_visit.visit_id
  INNER JOIN visit_attribute_type vat on vat.visit_attribute_type_id = va.attribute_type_id AND vat.name = 'Visit Status'
  INNER JOIN reporting_age_group rag ON rag.report_group_name = 'All Ages'
        AND all_obs.obs_datetime BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag.min_days DAY))
        AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
GROUP BY rag.name, cn.name, diagnosis.name, va.value_reference;