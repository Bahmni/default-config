
SELECT
  hiv_cases.caste_ethnicity AS 'Caste/Ethnicity',
  hiv_female AS 'New HIV+ Cases-Female',
  hiv_male AS 'New HIV+ Cases-Male',
  leprosy_female AS 'New Leprosy Cases-Female',
  leprosy_male AS 'New Leprosy Cases-Male',
  tb_female AS 'New TB Cases-Female',
  tb_male AS 'New TB Cases-Male',
  gender_violence_female AS 'Gender based violence - Female',
  gender_violence_male AS 'Gender based violence - Male'
FROM
-- New HIV+ cases
  (SELECT
     caste_list.answer_concept_name AS caste_ethnicity,
     SUM(IF(person.gender = 'F', 1, 0)) AS hiv_female,
     SUM(IF(person.gender = 'M', 1, 0)) AS hiv_male
   FROM visit
     INNER JOIN person ON visit.patient_id = person.person_id
                          AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
     INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
     INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
                                         AND person_attribute_type.name = 'Caste'
     INNER JOIN confirmed_diagnosis_view diagnosis on diagnosis.visit_id = visit.visit_id and diagnosis.person_id=person.person_id and diagnosis.name='HIV Infection'
     RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
   GROUP BY caste_list.answer_concept_name) AS hiv_cases
  INNER JOIN

-- New leprosy cases
  (SELECT
     caste_list.answer_concept_name AS caste_ethnicity,
     SUM(IF(person.gender = 'F', 1, 0)) AS leprosy_female,
     SUM(IF(person.gender = 'M', 1, 0)) AS leprosy_male
   FROM visit
     INNER JOIN person ON visit.patient_id = person.person_id
                          AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
     INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
     INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
                                         AND person_attribute_type.name = 'Caste'
     INNER JOIN confirmed_diagnosis_view diagnosis on diagnosis.visit_id = visit.visit_id and diagnosis.person_id=person.person_id and diagnosis.name='Leprosy'
     RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
   GROUP BY caste_list.answer_concept_name) AS leprosy_cases ON leprosy_cases.caste_ethnicity = hiv_cases.caste_ethnicity
  INNER JOIN

-- New TB cases
  (SELECT
     caste_list.answer_concept_name AS caste_ethnicity,
     SUM(IF(person.gender = 'F', 1, 0)) AS tb_female,
     SUM(IF(person.gender = 'M', 1, 0)) AS tb_male
   FROM visit
     INNER JOIN person ON visit.patient_id = person.person_id
                          AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
     INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
     INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
                                         AND person_attribute_type.name = 'Caste'
     INNER JOIN confirmed_diagnosis_view diagnosis on diagnosis.visit_id = visit.visit_id and diagnosis.person_id=person.person_id and diagnosis.name in ('Tuberculosis', 'Multi Drug Resistant Tuberculosis', 'Extremely Drug Resistant Tuberculosis')
     RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
   GROUP BY caste_list.answer_concept_name) AS tb_cases ON tb_cases.caste_ethnicity = hiv_cases.caste_ethnicity
  INNER JOIN

-- Gender based violence
  (SELECT
     caste_list.answer_concept_name AS caste_ethnicity,
     SUM(IF(person.gender = 'F', 1, 0)) AS gender_violence_female,
     SUM(IF(person.gender = 'M', 1, 0)) AS gender_violence_male
   FROM visit
     INNER JOIN person ON visit.patient_id = person.person_id
                          AND DATE(visit.date_stopped) BETWEEN '#startDate#' AND '#endDate#'
     INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
     INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
                                         AND person_attribute_type.name = 'Caste'
     INNER JOIN encounter ON visit.visit_id = encounter.visit_id
     INNER JOIN coded_obs_view ON encounter.encounter_id = coded_obs_view.encounter_id
                                  AND coded_obs_view.concept_full_name IN ('Out Patient Details, Free Health Service Code', 'ER General Notes, Free Health Service Code')
                                  AND coded_obs_view.value_concept_full_name = 'Gender based violence'
     RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
   GROUP BY caste_list.answer_concept_name) AS gender_violence ON gender_violence.caste_ethnicity = tb_cases.caste_ethnicity;

