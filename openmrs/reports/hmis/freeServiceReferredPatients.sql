SELECT
  cv2.concept_full_name                         AS 'Free Service type',
  sum(if(filtered_obs.person_id IS NULL, 0, 1)) AS 'Referred In Patients'
FROM
  concept_view AS free_view
  JOIN concept_answer AS answer 
    ON free_view.concept_id = answer.concept_id 
       AND free_view.concept_full_name IN ('ER General Notes, Free Health Service Code', 'Out Patient Details, Free Health Service Code')
  JOIN concept_view AS cv2 ON cv2.concept_id = answer.answer_concept AND cv2.concept_full_name NOT IN ('Not Applicable')
  LEFT JOIN (SELECT free_obs.concept_id, free_obs.person_id, free_obs.value_coded 
             FROM obs AS free_obs 
               JOIN obs AS ref_obs 
                 ON ref_obs.person_id = free_obs.person_id 
                    AND DATE(free_obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
                    AND free_obs.voided = 0 
                    AND ref_obs.voided = 0 
               JOIN concept_view AS cv 
                 ON ref_obs.concept_id = cv.concept_id 
                    AND cv.concept_full_name = 'Hospitals, Referred by, Data') AS filtered_obs
      ON free_view.concept_id = filtered_obs.concept_id 
         AND filtered_obs.value_coded = answer.answer_concept
GROUP BY cv2.concept_full_name
ORDER BY cv2.concept_full_name;