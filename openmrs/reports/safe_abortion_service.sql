-- Parameters
SET @start_date = '2014-10-05';
SET @end_date = '2014-12-01';

-- Constants
SET @report_group_name = 'Safe Abortion Service';

-- Query
SELECT abortion_procedures.age_group AS Age_Group,
	IF(abortion_procedures.procedure_name IS NULL, 0, SUM(IF(abortion_procedures.procedure_name = 'Medical Abortion' || abortion_procedures.procedure_name = 'Medical Induction' || abortion_procedures.procedure_name = 'Other abortion procedures', 1, 0))) as Medical,
    IF(abortion_procedures.procedure_name IS NULL, 0, SUM(IF(abortion_procedures.procedure_name = 'Manual Vacuum Aspiration' || abortion_procedures.procedure_name = 'Electric Vacuum Aspiration' || abortion_procedures.procedure_name = 'Dilation and Evacuation', 1, 0))) as Surgical
FROM  
(SELECT concept_view.concept_full_name as procedure_name,
	   observed_age_group.name AS age_group,
	   observed_age_group.id as age_group_id,
	   observed_age_group.sort_order AS sort_order
FROM obs_view
INNER JOIN person ON person.person_id = obs_view.person_id AND person.gender = 'F' AND obs_view.concept_full_name = 'Abortion procedure'
AND DATE(obs_view.obs_datetime) BETWEEN @start_date AND @end_date
INNER JOIN concept_view ON obs_view.value_coded = concept_view.concept_id
RIGHT OUTER JOIN possible_age_group AS observed_age_group ON
DATE(obs_view.obs_datetime) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY)) 
						AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
WHERE observed_age_group.report_group_name = @report_group_name) AS abortion_procedures
GROUP BY abortion_procedures.age_group
ORDER BY abortion_procedures.sort_order;

SELECT procedures_fp_methods.fp_name AS 'Post Abortion FP Methods',
	IF(procedures_fp_methods.procedure_name IS NULL, 0, SUM(IF(procedures_fp_methods.procedure_name = 'Medical Abortion' || procedures_fp_methods.procedure_name = 'Medical Induction' || procedures_fp_methods.procedure_name = 'Other abortion procedures', 1, 0))) as Medical,
    IF(procedures_fp_methods.procedure_name IS NULL, 0, SUM(IF(procedures_fp_methods.procedure_name = 'Manual Vacuum Aspiration' || procedures_fp_methods.procedure_name = 'Electric Vacuum Aspiration' || procedures_fp_methods.procedure_name = 'Dilation and Evacuation', 1, 0))) as Surgical
FROM  
(SELECT concept_procedure.concept_full_name as procedure_name,
	   concept_fp.concept_full_name as fp_name
FROM obs_view as obs_procedure
INNER JOIN concept_view AS concept_procedure ON obs_procedure.value_coded = concept_procedure.concept_id 
	AND obs_procedure.concept_full_name = 'Abortion procedure'
	AND DATE(obs_procedure.obs_datetime) BETWEEN @start_date AND @end_date
INNER JOIN obs_view AS obs_fp ON obs_procedure.obs_group_id = obs_fp.obs_group_id AND obs_fp.concept_full_name = 'Accepted Family Planning methods'
INNER JOIN concept_view AS concept_fp ON obs_fp.value_coded = concept_fp.concept_id) AS procedures_fp_methods
GROUP BY procedures_fp_methods.fp_name;


SELECT pac.pac_cause AS 'PAC',
	IF(pac.pac_abortion IS NULL, 0, SUM(1)) as Facility,
    IF(pac.pac_abortion IS NULL, SUM(1), 0) as Others
FROM  
(SELECT concept_pac_cause.concept_full_name as pac_cause,
	    obs_abortion.obs_id as pac_abortion
FROM obs_view as obs_pac_cause
INNER JOIN concept_view AS concept_pac_cause ON obs_pac_cause.value_coded = concept_pac_cause.concept_id 
	AND obs_pac_cause.concept_full_name = 'PAC Cause'
	AND DATE(obs_pac_cause.obs_datetime) BETWEEN @start_date AND @end_date
LEFT OUTER JOIN obs_view AS obs_abortion ON obs_abortion.person_id = obs_pac_cause.person_id
	AND obs_abortion.concept_full_name = 'Abortion procedure'
    AND DATE(obs_abortion.obs_datetime) BETWEEN @start_date AND @end_date
)AS pac
GROUP BY pac.pac_cause;
