SELECT  NULL AS 'Age Groups', 
		NULL AS 'SEX', 
        NULL AS '\# started on ART', 
        NULL AS '\# of breast Feeding  women at initiation', 
        NULL AS 'Age', 
        NULL AS 'Sex', 
        NULL AS '\# current on ART' 
FROM  DUAL

UNION ALL

SELECT  NULL AS 'Age Groups', 
		'Newly' AS 'SEX', 
        'Started On' AS '\# started on ART', 
        'ART' AS '\# of breast Feeding  women at initiation', 
        'Currently on' AS 'Age', 
        'ART' AS 'Sex', 
        NULL AS '\# current on ART' 
FROM  DUAL

UNION ALL

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Age Groups', 
		year_q.year AS 'SEX', 
        NULL AS '\# started on ART', 
        NULL AS '\# of breast Feeding  women at initiation', 
        'TX_CURR ' AS 'Age', 
        ' (ART register)' AS 'Sex', 
        NULL AS '\# current on ART' 
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))) as year
         )year_q
         
UNION ALL 
SELECT  'Age Groups', 
		'SEX', 
        NULL AS '\# started on ART', 
        '\# of breast Feeding  women at initiation', 
        'Age', 
        'Sex', 
        '\# current on ART' 
FROM  DUAL

UNION ALL

SELECT DISTINCT  observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        format(sum(if(newly_started.patient_id IS NOT NULL, 1, 0)),0) AS '\# started on ART',
        format(sum(if(breastfeeding.patient_id IS NOT NULL, 1, 0)),0)  AS '\# of breast Feeding  women at initiation', 
        observed_age_group.report_group_name AS 'Age',
        observed_age_group.sex AS 'Sex', 
		format(sum(if(currently_on_art.patient_id IS NOT NULL, 1, 0)),0) AS '\# current on ART' 

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
		SELECT pt.patient_id
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
			SELECT pt.patient_id as val
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
                    AND obs2.voided = 0
			
    )newly_started ON newly_started.patient_id = pt.patient_id
    
    LEFT JOIN (
		SELECT pt.patient_id
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
			SELECT pt.patient_id 
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
                    AND obs2.voided = 0
			
    )breastfeeding ON breastfeeding.patient_id = pt.patient_id 
		AND breastfeeding.patient_id IN (
			SELECT pt.patient_id
            FROM patient pt
            INNER JOIN person p 
                ON p.person_id = pt.patient_id
				AND p.voided=0 AND pt.voided=0
			INNER JOIN encounter e 
				ON e.patient_id = p.person_id 
				AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
				AND e.voided = 0
			INNER JOIN obs
				ON obs.encounter_id = e.encounter_id 
				AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Currently Breastfeeding?') 
				AND obs.value_coded = 1
				AND obs.voided = 0
        )
	
    LEFT JOIN (
		SELECT pt.patient_id
            FROM patient pt
            INNER JOIN person p
				ON p.person_id = pt.patient_id
                AND p.voided = 0
                AND pt.voided = 0
            INNER JOIN person_attribute pa
				ON pa.person_id = p.person_id 
				AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
				AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
                AND pa.voided = 0
                
		UNION DISTINCT 
        
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
				WHERE DATE(orders.date_created) <= LAST_DAY(DATE(DATE_ADD('#startDate#', INTERVAL 0 MONTH)))
                AND date_stopped IS NULL 
				AND order_type_id = (select order_type_id as ot_id from order_type where name ='Drug Order')
				GROUP BY patient_id
            )max_order 
            ON max_order.patient_id = pt.patient_id 
		
        UNION DISTINCT
        
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
        
    )currently_on_art 
    ON currently_on_art.patient_id = pt.patient_id
    AND currently_on_art.patient_id NOT IN (
		SELECT DISTINCT pt.patient_id 
        FROM patient pt
        INNER JOIN person p 
			ON p.person_id = pt.patient_id
			AND p.voided=0 AND pt.voided=0
		INNER JOIN (
			SELECT DISTINCT pt.patient_id
			FROM patient pt
			INNER JOIN obs obs2 
				ON obs2.person_id=pt.patient_id
				AND obs2.concept_id =(SELECT concept_id FROM  concept_view WHERE concept_full_name ='Interruption Type') 
                AND DATE(obs2.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
			INNER JOIN obs restarted 
				ON restarted.encounter_id = obs2.encounter_id
				AND restarted.concept_id=(select concept_id from  concept_view where concept_full_name ='Date If Restarted') 
                AND DATE(restarted.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
				AND restarted.voided = 0
			INNER JOIN (
					SELECT max(obs_id) as obs_id
					FROM obs
					WHERE concept_id=(SELECT concept_id FROM  concept_view WHERE concept_full_name ='Date If Restarted') 
                    AND DATE(obs.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
					GROUP BY obs.person_id
				)obs3 
				ON obs3.obs_id = restarted.obs_id
				AND (restarted.value_datetime is null OR DATE(restarted.value_datetime) < DATE(obs2.obs_datetime))
			group by pt.patient_id           
        )interrupted 
        ON interrupted.patient_id = pt.patient_id
    )
    
    
GROUP BY observed_age_group.id


UNION ALL

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Age Groups', 
		year_q.year AS 'SEX', 
        NULL AS '\# started on ART', 
        NULL AS '\# of breast Feeding  women at initiation', 
        'TX_CURR ' AS 'Age', 
        ' (ART register)' AS 'Sex', 
        NULL AS '\# current on ART' 
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))) as year
         )year_q
         
UNION ALL 
SELECT  'Age Groups', 
		'SEX', 
        NULL AS '\# started on ART', 
        '\# of breast Feeding  women at initiation', 
        'Age', 
        'Sex', 
        '\# current on ART' 
FROM  DUAL

UNION ALL 

SELECT DISTINCT  observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        format(sum(if(newly_started.patient_id IS NOT NULL, 1, 0)),0) AS '\# started on ART',
        format(sum(if(breastfeeding.patient_id IS NOT NULL, 1, 0)),0)  AS '\# of breast Feeding  women at initiation', 
        observed_age_group.report_group_name AS 'Age',
        observed_age_group.sex AS 'Sex', 
		format(sum(if(currently_on_art.patient_id IS NOT NULL, 1, 0)),0) AS '\# current on ART' 

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
		SELECT pt.patient_id
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
			SELECT pt.patient_id as val
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
                    AND obs2.voided = 0
			
    )newly_started ON newly_started.patient_id = pt.patient_id
    
    LEFT JOIN (
		SELECT pt.patient_id
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
                    AND obs2.voided = 0
			
    )breastfeeding ON breastfeeding.patient_id = pt.patient_id 
		AND breastfeeding.patient_id IN (
			SELECT pt.patient_id
            FROM patient pt
            INNER JOIN person p 
                ON p.person_id = pt.patient_id
				AND p.voided=0 AND pt.voided=0
			INNER JOIN encounter e 
				ON e.patient_id = p.person_id 
				AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH)))
				AND e.voided = 0
			INNER JOIN obs
				ON obs.encounter_id = e.encounter_id 
				AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Currently Breastfeeding?') 
				AND obs.value_coded = 1
				AND obs.voided = 0
        )
	
    LEFT JOIN (
		SELECT pt.patient_id
            FROM patient pt
            INNER JOIN person p
				ON p.person_id = pt.patient_id
                AND p.voided = 0
                AND pt.voided = 0
            INNER JOIN person_attribute pa
				ON pa.person_id = p.person_id 
				AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
				AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
                AND pa.voided = 0
                
		UNION DISTINCT 
        
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
        
    )currently_on_art 
    ON currently_on_art.patient_id = pt.patient_id
    AND currently_on_art.patient_id NOT IN (
		SELECT DISTINCT pt.patient_id 
        FROM patient pt
        INNER JOIN person p 
			ON p.person_id = pt.patient_id
			AND p.voided=0 AND pt.voided=0
		INNER JOIN (
			SELECT DISTINCT pt.patient_id
			FROM patient pt
			INNER JOIN obs obs2 
				ON obs2.person_id=pt.patient_id
				AND obs2.concept_id =(SELECT concept_id FROM  concept_view WHERE concept_full_name ='Interruption Type') 
                AND DATE(obs2.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
			INNER JOIN obs restarted 
				ON restarted.encounter_id = obs2.encounter_id
				AND restarted.concept_id=(select concept_id from  concept_view where concept_full_name ='Date If Restarted') 
                AND DATE(restarted.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
				AND restarted.voided = 0
			INNER JOIN (
					SELECT max(obs_id) as obs_id
					FROM obs
					WHERE concept_id=(SELECT concept_id FROM  concept_view WHERE concept_full_name ='Date If Restarted') 
                    AND DATE(obs.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
					GROUP BY obs.person_id
				)obs3 
				ON obs3.obs_id = restarted.obs_id
				AND (restarted.value_datetime is null OR DATE(restarted.value_datetime) < DATE(obs2.obs_datetime))
			group by pt.patient_id           
        )interrupted 
        ON interrupted.patient_id = pt.patient_id
    )
    
    
GROUP BY observed_age_group.id

UNION ALL

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Age Groups', 
		year_q.year AS 'SEX', 
        NULL AS '\# started on ART', 
        NULL AS '\# of breast Feeding  women at initiation', 
        'TX_CURR ' AS 'Age', 
        ' (ART register)' AS 'Sex', 
        NULL AS '\# current on ART' 
FROM  (
	SELECT MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as month) quarter
		 JOIN (SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as year
         )year_q
         
UNION ALL 
SELECT  'Age Groups', 
		'SEX', 
        NULL AS '\# started on ART', 
        '\# of breast Feeding  women at initiation', 
        'Age', 
        'Sex', 
        '\# current on ART' 
FROM  DUAL

UNION ALL 

SELECT DISTINCT  observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        format(sum(if(newly_started.patient_id IS NOT NULL, 1, 0)),0) AS '\# started on ART',
        format(sum(if(breastfeeding.patient_id IS NOT NULL, 1, 0)),0)  AS '\# of breast Feeding  women at initiation', 
        observed_age_group.report_group_name AS 'Age',
        observed_age_group.sex AS 'Sex', 
		format(sum(if(currently_on_art.patient_id IS NOT NULL, 1, 0)),0) AS '\# current on ART' 

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
		SELECT pt.patient_id
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
			SELECT pt.patient_id as val
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
                    AND obs2.voided = 0
			
    )newly_started ON newly_started.patient_id = pt.patient_id
    
    LEFT JOIN (
		SELECT pt.patient_id
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
                    AND obs2.voided = 0
			
    )breastfeeding ON breastfeeding.patient_id = pt.patient_id 
		AND breastfeeding.patient_id IN (
			SELECT pt.patient_id
            FROM patient pt
            INNER JOIN person p 
                ON p.person_id = pt.patient_id
				AND p.voided=0 AND pt.voided=0
			INNER JOIN encounter e 
				ON e.patient_id = p.person_id 
				AND MONTH(e.encounter_datetime) = MONTH(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				AND YEAR(e.encounter_datetime) = YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH)))
				AND e.voided = 0
			INNER JOIN obs
				ON obs.encounter_id = e.encounter_id 
				AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Currently Breastfeeding?') 
				AND obs.value_coded = 1
				AND obs.voided = 0
        )
	
    LEFT JOIN (
		SELECT pt.patient_id
            FROM patient pt
            INNER JOIN person p
				ON p.person_id = pt.patient_id
                AND p.voided = 0
                AND pt.voided = 0
            INNER JOIN person_attribute pa
				ON pa.person_id = p.person_id 
				AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
				AND pa.value = (select concept_id from concept_view where concept_full_name='ExistingPatient')
                AND pa.voided = 0
                
		UNION DISTINCT 
        
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
        
    )currently_on_art 
    ON currently_on_art.patient_id = pt.patient_id
    AND currently_on_art.patient_id NOT IN (
		SELECT DISTINCT pt.patient_id 
        FROM patient pt
        INNER JOIN person p 
			ON p.person_id = pt.patient_id
			AND p.voided=0 AND pt.voided=0
		INNER JOIN (
			SELECT DISTINCT pt.patient_id
			FROM patient pt
			INNER JOIN obs obs2 
				ON obs2.person_id=pt.patient_id
				AND obs2.concept_id =(SELECT concept_id FROM  concept_view WHERE concept_full_name ='Interruption Type') 
                AND DATE(obs2.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
			INNER JOIN obs restarted 
				ON restarted.encounter_id = obs2.encounter_id
				AND restarted.concept_id=(select concept_id from  concept_view where concept_full_name ='Date If Restarted') 
                AND DATE(restarted.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
				AND restarted.voided = 0
			INNER JOIN (
					SELECT max(obs_id) as obs_id
					FROM obs
					WHERE concept_id=(SELECT concept_id FROM  concept_view WHERE concept_full_name ='Date If Restarted') 
                    AND DATE(obs.obs_datetime) <= LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
					GROUP BY obs.person_id
				)obs3 
				ON obs3.obs_id = restarted.obs_id
				AND (restarted.value_datetime is null OR DATE(restarted.value_datetime) < DATE(obs2.obs_datetime))
			group by pt.patient_id           
        )interrupted 
        ON interrupted.patient_id = pt.patient_id
    )
    
    
GROUP BY observed_age_group.id


