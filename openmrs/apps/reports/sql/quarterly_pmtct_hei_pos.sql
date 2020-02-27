SELECT  CONCAT('Reporting Month : ',CONCAT(quarter.start_mon, '-' , quarter.month)) AS 'Serial \#', 
		year_q.year AS 'Date result was delivered to the facility ', 
        NULL AS 'EID Number', 
        NULL AS 'Sex', 
        NULL AS 'Age at enrolment ' ,
        NULL AS '0 - 2 months of age',
        NULL AS ' 2-12 months of age',
        NULL AS 'Date EID sample collecetd',
        NULL AS 'Date ART initiated (DD/MM/YYY)',
        NULL AS 'Unique ART \#',
        NULL AS 'Reason if HIV infected infant not initiated on ART'
FROM  (
	SELECT MONTHNAME(DATE_SUB('#startDate#', INTERVAL DAYOFMONTH('#startDate#')-1 DAY)) as start_mon, 
		MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 3 MONTH))) as month) quarter
	JOIN (
			SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 3 MONTH))) as year
         )year_q
         
UNION ALL 

SELECT DISTINCT NULL AS 'Serial \#', 
		DATE_FORMAT(date_delivered.value_datetime, "%d/%m/%Y") AS 'Date result was delivered to the facility ', 
        eid_number.value_numeric AS 'EID Number', 
        p.gender AS 'Sex', 
        NULL AS 'Age at enrolment ' ,
        IF(eid_age.value_numeric IS NOT NULL, IF(eid_age.value_numeric <=2, 1, ''),
			IF(date_delivered.value_datetime IS NOT NULL AND TIMESTAMPDIFF( MONTH, p.birthdate, date_delivered.value_datetime) <=2 , 1 , '')) AS '0 - 2 months of age',
        IF(eid_age.value_numeric IS NOT NULL, IF(eid_age.value_numeric BETWEEN 3 AND 12 , 1, ''),
			IF(date_delivered.value_datetime IS NOT NULL AND TIMESTAMPDIFF( MONTH, p.birthdate, date_delivered.value_datetime)  BETWEEN 3 AND 12 , 1 , '')) AS ' 2-12 months of age',
        DATE_FORMAT(date_sample_collected.value_datetime, "%d/%m/%Y") AS 'Date EID sample collecetd',
        DATE_FORMAT(date_art_initiated.value_datetime, "%d/%m/%Y") AS 'Date ART initiated (DD/MM/YYY)',
        pid.identifier AS 'Unique ART \#',
        reason.value_text AS 'Reason if HIV infected infant not initiated on ART'
FROM  
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
        AND pt.voided =  0
	INNER JOIN encounter e
		ON e.patient_id = pt.patient_id
        AND e.voided = 0
	INNER JOIN obs date_delivered
		ON date_delivered.encounter_id = e.encounter_id
        AND date_delivered.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'EID - Date result was delivered to the facility')
        AND date_delivered.voided = 0
        AND date_delivered.value_datetime BETWEEN DATE_SUB('#startDate#', INTERVAL DAYOFMONTH('#startDate#')-1 DAY) AND LAST_DAY(DATE_ADD('#startDate#', INTERVAL 3 MONTH))
	LEFT JOIN obs eid_number
		ON eid_number.person_id = p.person_id
        AND eid_number.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'EID Number')
        AND eid_number.voided = 0
	LEFT JOIN obs eid_age
		ON eid_age.person_id = p.person_id
        AND eid_age.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'EID - Age at 1st EID')
        AND eid_age.voided = 0
	LEFT JOIN obs date_sample_collected
		ON date_sample_collected.person_id = p.person_id
        AND date_sample_collected.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Date EID sample collected')
        AND date_sample_collected.voided = 0
	LEFT JOIN obs date_art_initiated
		ON date_art_initiated.person_id = p.person_id
        AND date_art_initiated.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Treatment,Date ART initiated')
        AND date_art_initiated.voided = 0
	-- Primary patient identifier doubles up as ART number
	LEFT JOIN patient_identifier pid
		ON pid.patient_id = pt.patient_id
        AND pid.identifier_type = (SELECT pit.patient_identifier_type_id FROM patient_identifier_type pit WHERE pit.name = 'Patient Identifier')
        AND pid.voided = 0
	LEFT JOIN obs reason
		ON reason.person_id = p.person_id
        AND reason.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Treatment,Reason if HIV infected infant not initiated on ART')
        AND reason.voided = 0
        AND date_art_initiated.value_datetime IS NULL
