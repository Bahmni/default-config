SELECT  "" AS 'Testing point',
        CONCAT('Reporting Period : ',quarter.month,' ',year_q.year) 'Age Groups',
        '' AS '\# of pregnant woman  newly attended ANC (ANC 1)',
        '' AS '\# of known HIV positives at entry',
        '' AS '\# tested in the reporting period',
        '' AS '\# with Known HIV status ',
        '' AS '\# of newly tested HIV postive ',
        '' AS 'Total \# of HIV postives  (new + Previuosly known postives )',
        '' AS '\# with unknown HIV status\# not tested for HIV)',
        '' AS '\# of new negatives'
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))) as year
         )year_q

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL , NULL
FROM  DUAL
         
UNION ALL 


SELECT DISTINCT  if(observed_age_group.name = '25-29 yr M', 'PMTCT_STAT (ANC 1)','') AS 'Testing point',
        observed_age_group.report_group_name  AS  'Age Groups',
        format(sum(if(newly_attended.patient_id IS NOT NULL, 1, 0)),0) AS '\# of pregnant woman  newly attended ANC (ANC 1)',
        format(sum(if(known_positives_entry.patient_id IS NOT NULL, 1, 0)),0) AS '\# of known HIV positives at entry',
        format(sum(if(tested_in_period.patient_id IS NOT NULL, 1, 0)),0) AS '\# tested in the reporting period',
        format(sum(if(known_status.patient_id IS NOT NULL, 1, 0)),0) AS '\# with Known HIV status ',
        format(sum(if(newly_tested_positive.patient_id IS NOT NULL, 1, 0)),0) AS '\# of newly tested HIV postive ',
        format(sum(if(total_positive.patient_id IS NOT NULL, 1, 0)),0) AS 'Total \# of HIV postives  (new + Previuosly known postives )',
		format(sum(if(unknown_status.patient_id IS NOT NULL, 1, 0)),0)AS '\# with unknown HIV status\# not tested for HIV)',
        format(sum(if(newly_tested_negative.patient_id IS NOT NULL, 1, 0)),0) AS '\# of new negatives'
FROM 
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
	RIGHT OUTER  JOIN reporting_age_group observed_age_group  
		ON DATE(now()) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
		AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
		AND  CASE WHEN observed_age_group.report_group_name = 'Total All' THEN observed_age_group.sex = ('M' OR 'F') else observed_age_group.sex = p.gender  END
	LEFT JOIN (
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Visit Number')  
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='1 = First Contact')
    )newly_attended ON newly_attended.patient_id = pt.patient_id
    LEFT JOIN (
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Visit Number')  
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='1 = First Contact')
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs pregnant
					ON pregnant.encounter_id = e2.encounter_id
                    AND pregnant.voided=0 
                    AND pregnant.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')  
                    AND DATE(pregnant.value_datetime) < DATE(e.encounter_datetime)
    )known_positives_entry ON known_positives_entry.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded IS NOT NULL
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
    )tested_in_period ON tested_in_period.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +') 
                    AND DATE(tested.value_datetime) < DATE(e.encounter_datetime)
			UNION DISTINCT 
            
            SELECT DISTINCT
			pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs screening
					ON screening.encounter_id = e2.encounter_id
                    AND screening.voided=0 
                    AND screening.concept_id = (select concept_id from  concept_view where concept_full_name ='TB Screening - HIV Status') 
                    AND screening.value_coded = (select concept_id from  concept_view where concept_full_name ='Known') 
					AND e2.encounter_datetime <= e.encounter_datetime
                    
    )known_status ON known_status.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
    )newly_tested_positive ON newly_tested_positive.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
		UNION DISTINCT
        SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +') 
                    AND DATE(tested.value_datetime) < DATE(e.encounter_datetime)
    )total_positive ON total_positive.patient_id = pt.patient_id
    LEFT JOIN (
		SELECT DISTINCT
			pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs screening
					ON screening.encounter_id = e2.encounter_id
                    AND screening.voided=0 
                    AND screening.concept_id = (select concept_id from  concept_view where concept_full_name ='TB Screening - HIV Status') 
                    AND screening.value_coded = (select concept_id from  concept_view where concept_full_name ='Unkown/Not tested') 
					AND e2.encounter_datetime <= e.encounter_datetime
    )unknown_status ON unknown_status.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Negative') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
    )newly_tested_negative ON newly_tested_negative.patient_id = pt.patient_id where observed_age_group.name not in ('<1 yr M','<1 yr F','1-4 yr M','1-4 yr F','5-9 yr F','5-9 yr M','Total M','Total F')
		GROUP BY observed_age_group.id
        
UNION ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL , NULL
FROM  DUAL
UNION ALL         

SELECT  "" AS 'Testing point',
        CONCAT('Reporting Period : ',quarter.month,' ',year_q.year) 'Age Groups',
        '' AS '\# of pregnant woman  newly attended ANC (ANC 1)',
        '' AS '\# of known HIV positives at entry',
        '' AS '\# tested in the reporting period',
        '' AS '\# with Known HIV status ',
        '' AS '\# of newly tested HIV postive ',
        '' AS 'Total \# of HIV postives  (new + Previuosly known postives )',
        '' AS '\# with unknown HIV status\# not tested for HIV)',
        '' AS '\# of new negatives'
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))) as year
         )year_q
         
UNION ALL 
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL , NULL
FROM  DUAL
UNION ALL         

SELECT DISTINCT  if(observed_age_group.name = '25-29 yr M', 'PMTCT_STAT (ANC 1)','') AS 'Testing point',
        observed_age_group.report_group_name  AS  'Age Groups',
        format(sum(if(newly_attended.patient_id IS NOT NULL, 1, 0)),0) AS '\# of pregnant woman  newly attended ANC (ANC 1)',
        format(sum(if(known_positives_entry.patient_id IS NOT NULL, 1, 0)),0) AS '\# of known HIV positives at entry',
        format(sum(if(tested_in_period.patient_id IS NOT NULL, 1, 0)),0) AS '\# tested in the reporting period',
        format(sum(if(known_status.patient_id IS NOT NULL, 1, 0)),0) AS '\# with Known HIV status ',
        format(sum(if(newly_tested_positive.patient_id IS NOT NULL, 1, 0)),0) AS '\# of newly tested HIV postive ',
        format(sum(if(total_positive.patient_id IS NOT NULL, 1, 0)),0) AS 'Total \# of HIV postives  (new + Previuosly known postives )',
		format(sum(if(unknown_status.patient_id IS NOT NULL, 1, 0)),0)AS '\# with unknown HIV status\# not tested for HIV)',
        format(sum(if(newly_tested_negative.patient_id IS NOT NULL, 1, 0)),0) AS '\# of new negatives'
FROM 
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
	RIGHT OUTER  JOIN reporting_age_group observed_age_group  
		ON DATE(now()) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
		AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
		AND  CASE WHEN observed_age_group.report_group_name = 'Total All' THEN observed_age_group.sex = ('M' OR 'F') else observed_age_group.sex = p.gender  END
	LEFT JOIN (
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Visit Number')  
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='1 = First Contact')
    )newly_attended ON newly_attended.patient_id = pt.patient_id
    LEFT JOIN (
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Visit Number')  
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='1 = First Contact')
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs pregnant
					ON pregnant.encounter_id = e2.encounter_id
                    AND pregnant.voided=0 
                    AND pregnant.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')  
                    AND DATE(pregnant.value_datetime) < DATE(e.encounter_datetime)
    )known_positives_entry ON known_positives_entry.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded IS NOT NULL
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
    )tested_in_period ON tested_in_period.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +') 
                    AND DATE(tested.value_datetime) < DATE(e.encounter_datetime)
			UNION DISTINCT 
            
            SELECT DISTINCT
			pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs screening
					ON screening.encounter_id = e2.encounter_id
                    AND screening.voided=0 
                    AND screening.concept_id = (select concept_id from  concept_view where concept_full_name ='TB Screening - HIV Status') 
                    AND screening.value_coded = (select concept_id from  concept_view where concept_full_name ='Known') 
					AND e2.encounter_datetime <= e.encounter_datetime
                    
    )known_status ON known_status.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
    )newly_tested_positive ON newly_tested_positive.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
		UNION DISTINCT
        SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +') 
                    AND DATE(tested.value_datetime) < DATE(e.encounter_datetime)
    )total_positive ON total_positive.patient_id = pt.patient_id
    LEFT JOIN (
		SELECT DISTINCT
			pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs screening
					ON screening.encounter_id = e2.encounter_id
                    AND screening.voided=0 
                    AND screening.concept_id = (select concept_id from  concept_view where concept_full_name ='TB Screening - HIV Status') 
                    AND screening.value_coded = (select concept_id from  concept_view where concept_full_name ='Unkown/Not tested') 
					AND e2.encounter_datetime <= e.encounter_datetime
    )unknown_status ON unknown_status.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Negative') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
    )newly_tested_negative ON newly_tested_negative.patient_id = pt.patient_id
        where observed_age_group.name not in  ('<1 yr M','<1 yr F','1-4 yr M','1-4 yr F','5-9 yr F','5-9 yr M','Total M','Total F')
        GROUP BY observed_age_group.id
        
UNION ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL , NULL
FROM  DUAL
UNION ALL         

SELECT  "" AS 'Testing point',
        CONCAT('Reporting Period : ',quarter.month,' ',year_q.year) 'Age Groups',
        '' AS '\# of pregnant woman  newly attended ANC (ANC 1)',
        '' AS '\# of known HIV positives at entry',
        '' AS '\# tested in the reporting period',
        '' AS '\# with Known HIV status ',
        '' AS '\# of newly tested HIV postive ',
        '' AS 'Total \# of HIV postives  (new + Previuosly known postives )',
        '' AS '\# with unknown HIV status\# not tested for HIV)',
        '' AS '\# of new negatives'
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as year
         )year_q
         
UNION ALL 
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL , NULL
FROM  DUAL
UNION ALL         

SELECT DISTINCT  if(observed_age_group.name = '25-29 yr M', 'PMTCT_STAT (ANC 1)','') AS 'Testing point',
        observed_age_group.report_group_name  AS  'Age Groups',
        format(sum(if(newly_attended.patient_id IS NOT NULL, 1, 0)),0) AS '\# of pregnant woman  newly attended ANC (ANC 1)',
        format(sum(if(known_positives_entry.patient_id IS NOT NULL, 1, 0)),0) AS '\# of known HIV positives at entry',
        format(sum(if(tested_in_period.patient_id IS NOT NULL, 1, 0)),0) AS '\# tested in the reporting period',
        format(sum(if(known_status.patient_id IS NOT NULL, 1, 0)),0) AS '\# with Known HIV status ',
        format(sum(if(newly_tested_positive.patient_id IS NOT NULL, 1, 0)),0) AS '\# of newly tested HIV postive ',
        format(sum(if(total_positive.patient_id IS NOT NULL, 1, 0)),0) AS 'Total \# of HIV postives  (new + Previuosly known postives )',
		format(sum(if(unknown_status.patient_id IS NOT NULL, 1, 0)),0)AS '\# with unknown HIV status\# not tested for HIV)',
        format(sum(if(newly_tested_negative.patient_id IS NOT NULL, 1, 0)),0) AS '\# of new negatives'
FROM 
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
	RIGHT OUTER  JOIN reporting_age_group observed_age_group  
		ON DATE(now()) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
		AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
		AND  CASE WHEN observed_age_group.report_group_name = 'Total All' THEN observed_age_group.sex = ('M' OR 'F') else observed_age_group.sex = p.gender  END
	LEFT JOIN (
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Visit Number')  
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='1 = First Contact')
    )newly_attended ON newly_attended.patient_id = pt.patient_id
    LEFT JOIN (
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Visit Number')  
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='1 = First Contact')
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs pregnant
					ON pregnant.encounter_id = e2.encounter_id
                    AND pregnant.voided=0 
                    AND pregnant.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')  
                    AND DATE(pregnant.value_datetime) < DATE(e.encounter_datetime)
    )known_positives_entry ON known_positives_entry.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded IS NOT NULL
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
    )tested_in_period ON tested_in_period.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +') 
                    AND DATE(tested.value_datetime) < DATE(e.encounter_datetime)
			UNION DISTINCT 
            
            SELECT DISTINCT
			pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs screening
					ON screening.encounter_id = e2.encounter_id
                    AND screening.voided=0 
                    AND screening.concept_id = (select concept_id from  concept_view where concept_full_name ='TB Screening - HIV Status') 
                    AND screening.value_coded = (select concept_id from  concept_view where concept_full_name ='Known') 
					AND e2.encounter_datetime <= e.encounter_datetime
                    
    )known_status ON known_status.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
    )newly_tested_positive ON newly_tested_positive.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
		UNION DISTINCT
        SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +') 
                    AND DATE(tested.value_datetime) < DATE(e.encounter_datetime)
    )total_positive ON total_positive.patient_id = pt.patient_id
    LEFT JOIN (
		SELECT DISTINCT
			pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
                    AND MONTH(obs.obs_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(obs.obs_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs screening
					ON screening.encounter_id = e2.encounter_id
                    AND screening.voided=0 
                    AND screening.concept_id = (select concept_id from  concept_view where concept_full_name ='TB Screening - HIV Status') 
                    AND screening.value_coded = (select concept_id from  concept_view where concept_full_name ='Unkown/Not tested') 
					AND e2.encounter_datetime <= e.encounter_datetime
    )unknown_status ON unknown_status.patient_id = pt.patient_id
    LEFT JOIN(
		SELECT DISTINCT
        pt.patient_id AS patient_id
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN encounter e
					ON e.patient_id = pt.patient_id
				INNER JOIN obs 
					ON obs.encounter_id = e.encounter_id 
					AND obs.voided=0 
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='ANC No')  
                    AND obs.value_text IS NOT NULL
				INNER JOIN encounter e2
					ON e2.patient_id = pt.patient_id
				INNER JOIN obs tested
					ON tested.encounter_id = e2.encounter_id
                    AND tested.voided=0 
                    AND tested.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV Sample') 
                    AND tested.value_coded = (select concept_id from  concept_view where concept_full_name ='Negative') 
                    AND MONTH(e2.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    AND YEAR(e2.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
    )newly_tested_negative ON newly_tested_negative.patient_id = pt.patient_id
        where observed_age_group.name not in  ('<1 yr M','<1 yr F','1-4 yr M','1-4 yr F','5-9 yr F','5-9 yr M','Total M','Total F')
        GROUP BY observed_age_group.id
