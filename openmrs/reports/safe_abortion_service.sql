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


   