select
  answer.concept_full_name as answer_concept_name,
  gender.gender as gender,
  reporting_age_group.name as age_group,
  
  IFNULL(result.total_count,0) as total_count
from
  concept_view AS question
  INNER JOIN concept_answer ON question.concept_id = concept_answer.concept_id AND question.concept_full_name IN ('Discharge note, Inpatient outcome')
  INNER JOIN concept_view AS answer ON answer.concept_id = concept_answer.answer_concept
  INNER JOIN (SELECT DISTINCT value_reference AS type FROM visit_attribute) visit_type 
  INNER JOIN reporting_age_group ON reporting_age_group.report_group_name = 'Inpatient'
  INNER JOIN (SELECT 'M' as gender UNION SELECT 'F' AS gender UNION SELECT 'O' AS gender) as gender
  LEFT OUTER JOIN (
    SELECT
      obs.value_coded as answer_concept_id,
      obs.concept_id as question_concept_id,
      person.gender as gender,
      reporting_age_group.name as age_group,
      count(*) as total_count
    FROM
      obs
      INNER JOIN concept_view question on obs.concept_id = question.concept_id and question.concept_full_name IN ('Discharge note, Inpatient outcome')
      INNER JOIN person on obs.person_id = person.person_id
      INNER JOIN encounter on obs.encounter_id = encounter.encounter_id
      INNER  JOIN visit on encounter.visit_id = visit.visit_id
      INNER JOIN reporting_age_group on cast(obs.obs_datetime AS DATE) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.min_years YEAR), INTERVAL reporting_age_group.min_days DAY))
                                        AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL reporting_age_group.max_years YEAR), INTERVAL reporting_age_group.max_days DAY))
                                        AND reporting_age_group.report_group_name = "Inpatient"
   -- WHERE CAST(visit.date_stopped  as DATE) BETWEEN "2016-02-01" and "2017-02-20"
   WHERE CAST(visit.date_stopped  as DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
    group by obs.concept_id, obs.value_coded, reporting_age_group.name, person.gender
  ) result on question.concept_id = result.question_concept_id
              and answer.concept_id = result.answer_concept_id
              and gender.gender = result.gender
              and result.age_group = reporting_age_group.name
GROUP BY question.concept_full_name, answer.concept_full_name, gender.gender, reporting_age_group.name
ORDER BY answer.concept_full_name,reporting_age_group.sort_order;