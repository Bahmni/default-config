select
  gender.gender as gender,
  
  IFNULL(result.total_count,0) as total_count
from
  concept_view AS question
  INNER JOIN concept_answer ON question.concept_id = concept_answer.concept_id AND question.concept_full_name IN ('Discharge note, Inpatient outcome')
  INNER JOIN concept_view AS answer ON answer.concept_id = concept_answer.answer_concept
  AND answer.concept_full_name  IN ('Referred out')
  INNER JOIN (SELECT DISTINCT value_reference AS type FROM visit_attribute) visit_type 
  INNER JOIN (SELECT 'M' as gender UNION SELECT 'F' AS gender) as gender
  LEFT OUTER JOIN (
    SELECT
      obs.value_coded as answer_concept_id,
      obs.concept_id as question_concept_id,
      person.gender as gender,
      count(*) as total_count
    FROM
      obs
      INNER JOIN concept_view question on obs.concept_id = question.concept_id and question.concept_full_name IN ('Discharge note, Inpatient outcome')
      INNER JOIN person on obs.person_id = person.person_id
      INNER JOIN encounter on obs.encounter_id = encounter.encounter_id
      INNER  JOIN visit on encounter.visit_id = visit.visit_id
     
   WHERE CAST(visit.date_stopped  as DATE)  BETWEEN DATE('#startDate#') AND DATE('#endDate#')
    group by obs.concept_id, obs.value_coded, person.gender
  ) result on question.concept_id = result.question_concept_id
              and answer.concept_id = result.answer_concept_id
              and gender.gender = result.gender
GROUP BY question.concept_full_name, answer.concept_full_name, gender.gender
ORDER BY answer.concept_full_name,gender.gender;
ORDER BY answer.concept_full_name,gender.gender;