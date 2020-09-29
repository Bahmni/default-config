SELECT  NULL AS 'Reporting Point',
		NULL AS 'Age Groups', 
		NULL AS 'Total', 
        NULL AS ' Newly initiated on ART during the current pregnancy ', 
        NULL AS 'Already on ART at the beginning of the current pregnancy '
FROM  DUAL

UNION ALL 

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Reporting Point', 
		year_q.year AS 'Age Groups', 
        NULL AS 'Total', 
        NULL AS ' Newly initiated on ART during the current pregnancy ', 
        NULL AS 'Already on ART at the beginning of the current pregnancy ' 
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))) as year
         )year_q
UNION ALL


SELECT  NULL AS 'Reporting Point',
		NULL AS 'Age Groups', 
		NULL AS 'Total', 
        'Maternal Regimen Type' AS ' Newly initiated on ART during the current pregnancy ', 
        NULL AS 'Already on ART at the beginning of the current pregnancy '
FROM  DUAL

UNION ALL 


SELECT 
		NULL AS 'Reporting Point',
		observed_age_group.report_group_name  AS 'Age Groups', 
		format(sum(if(total.patient_id IS NOT NULL, 1, 0)),0)  AS 'Total', 
        format(sum(if(pregnant_newly_started_art.patient_id IS NOT NULL, 1, 0)),0) AS ' Newly initiated on ART during the current pregnancy ', 
        format(sum(if(already_art_before_pregnncy.patient_id IS NOT NULL, 1, 0)),0)  AS 'Already on ART at the beginning of the current pregnancy '

FROM 
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
	RIGHT OUTER  JOIN reporting_age_group observed_age_group  
		ON DATE(now()) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
		AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
		AND  observed_age_group.sex ='M'
        AND observed_age_group.report_group_name != 'Total M' AND observed_age_group.report_group_name !=  'Total F'
	LEFT JOIN (
		-- IN PMTCT (Has ANC number) and is on ART(started AT + current on ART)
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
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
					AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                    
				INNER JOIN  (
					-- New patient started ART
					SELECT DISTINCT pt.patient_id
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						AND MONTH(od.date_created) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
						AND YEAR(od.date_created) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                        
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id 
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND MONTH(obs2.value_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
							AND YEAR(obs2.value_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                            
					UNION distinct
                    -- New patient currently on ART
                    SELECT DISTINCT pt.patient_id
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
					INNER JOIN (
							SELECT max(orders.order_id), max(orders.date_created) as date_created, orders.patient_id FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE DATE(orders.date_created) <= DATE(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
							AND date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)max_order 
						ON max_order.patient_id = pt.patient_id 
                        
					UNION DISTINCT 
                    -- Existing patient current on ART
                    SELECT DISTINCT pt.patient_id 
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND DATE(obs2.value_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
							AND obs2.voided = 0
                )on_art ON on_art.patient_id = pt.patient_id 
    )total ON total.patient_id = pt.patient_id
    LEFT JOIN (
		-- Pregnant women newly started ART and in PMTCT(Has ANC number)
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
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='EDD') 
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
                    AND obs2.concept_id = (select concept_id from  concept_view where concept_full_name ='Present Pregnancy') 
				INNER JOIN (
                    -- New patient started ART
					SELECT DISTINCT pt.patient_id, od.date_created as date_started
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						AND MONTH(od.date_created) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
						AND YEAR(od.date_created) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                        
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id , obs2.value_datetime as date_started
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND MONTH(obs2.value_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
							AND YEAR(obs2.value_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                )started_art ON started_art.patient_id = pt.patient_id AND started_art.date_started > DATE_SUB(obs.value_datetime, INTERVAL 9 MONTH)
    )pregnant_newly_started_art ON pregnant_newly_started_art.patient_id = pt.patient_id
    
    LEFT JOIN (
		-- IN PMTCT (Has ANC number) and is enrolled at ART before start of current pregnancy)
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
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
					AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				INNER JOIN encounter pregnant
					ON pregnant.patient_id = pt.patient_id
				INNER JOIN obs edd
					ON edd.encounter_id = e.encounter_id 
					AND edd.voided=0 
                    AND edd.concept_id = (select concept_id from  concept_view where concept_full_name ='EDD') 
                    AND edd.value_datetime IS NOT NULL
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
                    AND obs2.concept_id = (select concept_id from  concept_view where concept_full_name ='Present Pregnancy')
				INNER JOIN (
					-- New patient started ART
					SELECT DISTINCT pt.patient_id, od.date_created as date_started
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id , obs2.value_datetime as date_started
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
                )started_art ON started_art.patient_id = pt.patient_id AND started_art.date_started < DATE_SUB(obs.value_datetime, INTERVAL 9 MONTH)
    )already_art_before_pregnncy ON already_art_before_pregnncy.patient_id = pt.patient_id where 
	observed_age_group.name not in ('<1 yr M','<1 yr F','1-4 yr M','1-4 yr F','5-9 yr M','5-9 yr F','< 10 yr M','10-14 yr M','Total F') and observed_age_group.sex <> 'M'
GROUP BY observed_age_group.id
   
UNION ALL

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Reporting Point', 
		year_q.year AS 'Age Groups', 
        NULL AS 'Total', 
        NULL AS ' Newly initiated on ART during the current pregnancy ', 
        NULL AS 'Already on ART at the beginning of the current pregnancy ' 
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))) as year
         )year_q
UNION ALL


SELECT  NULL AS 'Reporting Point',
		NULL AS 'Age Groups', 
		NULL AS 'Total', 
        'Maternal Regimen Type' AS ' Newly initiated on ART during the current pregnancy ', 
        NULL AS 'Already on ART at the beginning of the current pregnancy '
FROM  DUAL

UNION ALL
SELECT 
		NULL AS 'Reporting Point',
		observed_age_group.report_group_name  AS 'Age Groups', 
		format(sum(if(total.patient_id IS NOT NULL, 1, 0)),0)  AS 'Total', 
        format(sum(if(pregnant_newly_started_art.patient_id IS NOT NULL, 1, 0)),0) AS ' Newly initiated on ART during the current pregnancy ', 
        format(sum(if(already_art_before_pregnncy.patient_id IS NOT NULL, 1, 0)),0)  AS 'Already on ART at the beginning of the current pregnancy '

FROM 
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
	RIGHT OUTER  JOIN reporting_age_group observed_age_group  
		ON DATE(now()) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
		AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
		AND  observed_age_group.sex ='M'
        AND observed_age_group.report_group_name != 'Total M' AND observed_age_group.report_group_name !=  'Total F'
	LEFT JOIN (
		-- IN PMTCT (Has ANC number) and is on ART(started AT + current on ART)
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
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
					AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                    
				INNER JOIN  (
					-- New patient started ART
					SELECT DISTINCT pt.patient_id
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						AND MONTH(od.date_created) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
						AND YEAR(od.date_created) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                        
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id 
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND MONTH(obs2.value_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
							AND YEAR(obs2.value_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                            
					UNION distinct
                    -- New patient currently on ART
                    SELECT DISTINCT pt.patient_id
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
					INNER JOIN (
							SELECT max(orders.order_id), max(orders.date_created) as date_created, orders.patient_id FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE DATE(orders.date_created) <= DATE(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
							AND date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)max_order 
						ON max_order.patient_id = pt.patient_id 
                        
					UNION DISTINCT 
                    -- Existing patient current on ART
                    SELECT DISTINCT pt.patient_id 
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND DATE(obs2.value_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
							AND obs2.voided = 0
                )on_art ON on_art.patient_id = pt.patient_id 
    )total ON total.patient_id = pt.patient_id
    LEFT JOIN (
		-- Pregnant women newly started ART and in PMTCT(Has ANC number)
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
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='EDD') 
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
                    AND obs2.concept_id = (select concept_id from  concept_view where concept_full_name ='Present Pregnancy') 
				INNER JOIN (
                    -- New patient started ART
					SELECT DISTINCT pt.patient_id, od.date_created as date_started
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						AND MONTH(od.date_created) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
						AND YEAR(od.date_created) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                        
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id , obs2.value_datetime as date_started
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND MONTH(obs2.value_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
							AND YEAR(obs2.value_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
                )started_art ON started_art.patient_id = pt.patient_id AND started_art.date_started > DATE_SUB(obs.value_datetime, INTERVAL 9 MONTH)
    )pregnant_newly_started_art ON pregnant_newly_started_art.patient_id = pt.patient_id
    
    LEFT JOIN (
		-- IN PMTCT (Has ANC number) and is enrolled at ART before start of current pregnancy)
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
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
					AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				INNER JOIN encounter pregnant
					ON pregnant.patient_id = pt.patient_id
				INNER JOIN obs edd
					ON edd.encounter_id = e.encounter_id 
					AND edd.voided=0 
                    AND edd.concept_id = (select concept_id from  concept_view where concept_full_name ='EDD') 
                    AND edd.value_datetime IS NOT NULL
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
                    AND obs2.concept_id = (select concept_id from  concept_view where concept_full_name ='Present Pregnancy')
				INNER JOIN (
					-- New patient started ART
					SELECT DISTINCT pt.patient_id, od.date_created as date_started
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id , obs2.value_datetime as date_started
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
                )started_art ON started_art.patient_id = pt.patient_id AND started_art.date_started < DATE_SUB(obs.value_datetime, INTERVAL 9 MONTH)
    )already_art_before_pregnncy ON already_art_before_pregnncy.patient_id = pt.patient_id
       where 
	observed_age_group.name not in ('<1 yr M','<1 yr F','1-4 yr M','1-4 yr F','5-9 yr M','5-9 yr F','< 10 yr M','10-14 yr M','Total F') and observed_age_group.sex <> 'M' 
        
GROUP BY observed_age_group.id


UNION ALL


SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Reporting Point', 
		year_q.year AS 'Age Groups', 
        NULL AS 'Total', 
        NULL AS ' Newly initiated on ART during the current pregnancy ', 
        NULL AS 'Already on ART at the beginning of the current pregnancy ' 
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as year
         )year_q
UNION ALL


SELECT  NULL AS 'Reporting Point',
		NULL AS 'Age Groups', 
		NULL AS 'Total', 
        'Maternal Regimen Type' AS ' Newly initiated on ART during the current pregnancy ', 
        NULL AS 'Already on ART at the beginning of the current pregnancy '
FROM  DUAL
UNION ALL 


SELECT 
		NULL AS 'Reporting Point',
		observed_age_group.report_group_name  AS 'Age Groups', 
		format(sum(if(total.patient_id IS NOT NULL, 1, 0)),0)  AS 'Total', 
        format(sum(if(pregnant_newly_started_art.patient_id IS NOT NULL, 1, 0)),0) AS ' Newly initiated on ART during the current pregnancy ', 
        format(sum(if(already_art_before_pregnncy.patient_id IS NOT NULL, 1, 0)),0)  AS 'Already on ART at the beginning of the current pregnancy '

FROM 
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
	RIGHT OUTER  JOIN reporting_age_group observed_age_group  
		ON DATE(now()) BETWEEN (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
		AND (DATE_ADD(DATE_ADD(p.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
		AND  observed_age_group.sex ='M'
        AND observed_age_group.report_group_name != 'Total M' AND observed_age_group.report_group_name !=  'Total F'
	LEFT JOIN (
		-- IN PMTCT (Has ANC number) and is on ART(started AT + current on ART)
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
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
					AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                    
				INNER JOIN  (
					-- New patient started ART
					SELECT DISTINCT pt.patient_id
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						AND MONTH(od.date_created) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
						AND YEAR(od.date_created) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                        
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id 
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND MONTH(obs2.value_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
							AND YEAR(obs2.value_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                            
					UNION distinct
                    -- New patient currently on ART
                    SELECT DISTINCT pt.patient_id
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
					INNER JOIN (
							SELECT max(orders.order_id), max(orders.date_created) as date_created, orders.patient_id FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE DATE(orders.date_created) <= DATE(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
							AND date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)max_order 
						ON max_order.patient_id = pt.patient_id 
                        
					UNION DISTINCT 
                    -- Existing patient current on ART
                    SELECT DISTINCT pt.patient_id 
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND DATE(obs2.value_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
							AND obs2.voided = 0
                )on_art ON on_art.patient_id = pt.patient_id 
    )total ON total.patient_id = pt.patient_id
    LEFT JOIN (
		-- Pregnant women newly started ART and in PMTCT(Has ANC number)
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
                    AND obs.concept_id = (select concept_id from  concept_view where concept_full_name ='EDD') 
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
                    AND obs2.concept_id = (select concept_id from  concept_view where concept_full_name ='Present Pregnancy') 
				INNER JOIN (
                    -- New patient started ART
					SELECT DISTINCT pt.patient_id, od.date_created as date_started
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						AND MONTH(od.date_created) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
						AND YEAR(od.date_created) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                        
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id , obs2.value_datetime as date_started
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
							AND MONTH(obs2.value_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
							AND YEAR(obs2.value_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
                )started_art ON started_art.patient_id = pt.patient_id AND started_art.date_started > DATE_SUB(obs.value_datetime, INTERVAL 9 MONTH)
    )pregnant_newly_started_art ON pregnant_newly_started_art.patient_id = pt.patient_id
    
    LEFT JOIN (
		-- IN PMTCT (Has ANC number) and is enrolled at ART before start of current pregnancy)
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
                    AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
					AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				INNER JOIN encounter pregnant
					ON pregnant.patient_id = pt.patient_id
				INNER JOIN obs edd
					ON edd.encounter_id = e.encounter_id 
					AND edd.voided=0 
                    AND edd.concept_id = (select concept_id from  concept_view where concept_full_name ='EDD') 
                    AND edd.value_datetime IS NOT NULL
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
                    AND obs2.concept_id = (select concept_id from  concept_view where concept_full_name ='Present Pregnancy')
				INNER JOIN (
					-- New patient started ART
					SELECT DISTINCT pt.patient_id, od.date_created as date_started
					FROM patient pt
					INNER JOIN  orders od
						ON od.patient_id = pt.patient_id
						AND pt.voided = 0
						AND od.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = pt.patient_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='NewPatient')
					INNER JOIN order_type ot 
						ON ot.order_type_id = od.order_type_id
						AND ot.order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
						AND od.date_stopped IS NULL 
						AND od.order_id IN (
							SELECT MIN(order_id) FROM orders
							INNER JOIN drug
								ON orders.concept_id = drug.concept_id
								AND drug.dosage_form = (select concept_id from concept_view where concept_full_name='HIVTC, ART Regimen')
							WHERE date_stopped IS NULL 
							AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
							GROUP BY patient_id
						)
						
					UNION DISTINCT 
                    -- Existing patient started ART
                    SELECT DISTINCT pt.patient_id , obs2.value_datetime as date_started
					FROM patient pt
					INNER JOIN person p
						ON p.person_id = pt.patient_id
						AND p.voided = 0
						AND pt.voided = 0
					INNER JOIN person_attribute pa
						ON pa.person_id = p.person_id 
						AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
						AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
					INNER JOIN encounter e 
							ON e.patient_id = p.person_id 
							AND e.voided = 0
					INNER JOIN obs 
							ON obs.encounter_id = e.encounter_id 
							AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Were ARVS Received?') 
							AND obs.value_coded = 1
							AND obs.voided = 0
					INNER JOIN obs obs2 
							ON obs2.encounter_id = e.encounter_id 
							AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='ANC, ART Start Date') 
                )started_art ON started_art.patient_id = pt.patient_id AND started_art.date_started < DATE_SUB(obs.value_datetime, INTERVAL 9 MONTH)
    )already_art_before_pregnncy ON already_art_before_pregnncy.patient_id = pt.patient_id
	where 
	observed_age_group.name not in ('<1 yr M','<1 yr F','1-4 yr M','1-4 yr F','5-9 yr M','5-9 yr F','< 10 yr M','10-14 yr M','Total F') and observed_age_group.sex <> 'M'
GROUP BY observed_age_group.id
