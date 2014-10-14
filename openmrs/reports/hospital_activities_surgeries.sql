-- Parameters
SET @start_date = '2014-09-01';
SET @end_date = '2014-11-01';

-- Constants
SET @admission_encounter_type = 'ADMISSION';
SET @general_visit_type = 'General';
SET @emergency_visit_type = 'Emergency';
SET @major_surgery_concept = 'Major Surgery TBD';
SET @true_concept_id = (SELECT concept_id FROM concept_name where name = 'True');


-- Query 
 
   SELECT
   IF( prime_obs.concept_full_name = @major_surgery_concept, 'Major',
   IF( outer_encounter.visit_type_name = @emergency_visit_type AND prime_obs.concept_full_name = 'Operative Procedure', 'Minor Emergency',
   IF( outer_encounter.visit_type_name = @general_visit_type AND prime_obs.concept_full_name = 'Operative Procedure' 
		AND NOT EXISTS(SELECT * from encounter_view AS encounters WHERE encounter_type_name = 'ADMISSION' AND encounters.visit_id = outer_encounter.visit_id), 'Minor Outpatients',
   IF( outer_encounter.visit_type_name = @general_visit_type AND prime_obs.concept_full_name = 'Operative Procedure'
        AND EXISTS (SELECT * from encounter_view AS encounters WHERE encounter_type_name = 'ADMISSION' AND encounters.visit_id = outer_encounter.visit_id), 'Minor Inpatients',0)))) as Type,
    
   SUM(CASE WHEN (prime_obs.concept_full_name = 'Operative Procedure' OR prime_obs.concept_full_name = @major_surgery_concept) AND person.gender = 'F' THEN 1 ELSE 0 END) AS female,
   SUM(CASE WHEN (prime_obs.concept_full_name = 'Operative Procedure' OR prime_obs.concept_full_name = @major_surgery_concept) AND person.gender = 'M' THEN 1 ELSE 0 END) AS male,
   SUM(CASE WHEN (assoc_obs.concept_full_name = 'Post-OP Infection' AND assoc_obs.value_coded = @true_concept_id)  THEN 1 ELSE 0 END) AS 'Post OP Infection'
   FROM obs_view AS prime_obs
   RIGHT OUTER JOIN encounter_view as outer_encounter
   ON prime_obs.encounter_id = outer_encounter.encounter_id
   INNER JOIN person
   ON outer_encounter.patient_id = person.person_id
   LEFT OUTER JOIN obs_view AS assoc_obs
   ON prime_obs.obs_group_id = assoc_obs.obs_group_id AND assoc_obs.concept_full_name = 'Post-OP Infection'
   WHERE prime_obs.concept_full_name  IN ('Operative Procedure', @major_surgery_concept)
   AND outer_encounter.visit_date_started BETWEEN @start_date AND @end_date
   GROUP BY Type;
   