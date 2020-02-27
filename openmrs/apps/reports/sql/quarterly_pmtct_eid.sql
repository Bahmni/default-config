SELECT  CONCAT('Reporting Month : ',CONCAT(quarter.start_mon, '-' , quarter.month)) AS 'Serial \#', 
		year_q.year AS 'Date DBS sample collected', 
        NULL AS 'EID Number', 
        NULL AS 'Sex', 
        NULL AS 'Age at enrolment ' ,
        NULL AS '0-≤2 months of age',
        NULL AS ' 2-12 months of age',
        NULL AS 'Date result was delivered to the facility',
        NULL AS 'HIV Status (0=Negative, 1=Positive, 2=Unknown) ',
        NULL AS 'Date result given to the parent/ care giver',
        NULL AS 'Linkage status for HIV positives (1. Linked to ART; 2 Died; 3. TO ;4. Un known)',
        NULL AS 'Unique ART \#'
FROM  (
	SELECT MONTHNAME(DATE_SUB('#startDate#', INTERVAL DAYOFMONTH('#startDate#')-1 DAY)) as start_mon, 
		MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 3 MONTH))) as month) quarter
	JOIN (
			SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 3 MONTH))) as year
         )year_q
         
UNION ALL 

SELECT  NULL AS 'Serial \#', 
		    DATE_FORMAT(dbs.value_datetime, "%d/%m/%Y") AS 'Date DBS sample collected',
        hei_no.value AS 'EID Number', 
        p.gender AS 'Sex', 
        CONCAT( IF(  TIMESTAMPDIFF( YEAR, p.birthdate, enrolled.value_datetime)>0, CONCAT(TIMESTAMPDIFF( YEAR, p.birthdate, enrolled.value_datetime),' Years'),''  ), 
        IF(  TIMESTAMPDIFF( MONTH, p.birthdate, enrolled.value_datetime)% 12 >0, CONCAT(TIMESTAMPDIFF( MONTH, p.birthdate, enrolled.value_datetime)% 12 ,' Months'),''  )) AS 'Age at enrolment ' ,
        IF(first_age.value_numeric IS NOT NULL AND first_age.value_numeric <=2, 1,
			IF(dbs.value_datetime IS NOT NULL AND TIMESTAMPDIFF( MONTH, p.birthdate, dbs.value_datetime) <=2 , 1 , '')) AS '0-≤2 months of age',
        IF(first_age.value_numeric IS NOT NULL AND first_age.value_numeric BETWEEN 3 AND 12 , 1,
			IF(dbs.value_datetime IS NOT NULL AND TIMESTAMPDIFF( MONTH, p.birthdate, dbs.value_datetime) BETWEEN 3 AND 12 , 1 , '')) AS ' 2-12 months of age',
        DATE_FORMAT(date_delivered.value_datetime, "%d/%m/%Y") AS 'Date result was delivered to the facility',
        hiv_status.hiv_status AS 'HIV Status (0=Negative, 1=Positive, 2=Unknown) ',
        DATE_FORMAT(results_given.value_datetime, "%d/%m/%Y") AS 'Date result given to the parent/ care giver',
        CASE 
			WHEN link_status.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Referred To ART Clinic') THEN 1
            WHEN link_status.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Died') THEN 2
            WHEN link_status.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Final Status(Transferred)') THEN 3
            WHEN link_status.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Unknown') THEN 4
		END
        AS 'Linkage status for HIV positives (1. Linked to ART; 2 Died; 3. TO ;4. Un known)',
        pid.identifier AS 'Unique ART \#'
        
FROM 
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
        AND pt.voided =  0
	-- Inner join HEI patient types and get HEI number
	INNER JOIN person_attribute pa
		ON pa.person_id = p.person_id 
		AND pa.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='TypeofPatient')
		AND pa.value = (select concept_id from concept_view where concept_full_name='HeiRelationship')
	INNER JOIN person_attribute hei_no
		ON hei_no.person_id = p.person_id 
		AND hei_no.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='HIVExposedInfant(HEI)No')
	-- Must have first PCR date recorded
	INNER JOIN obs dbs
		ON dbs.person_id = p.person_id
        AND dbs.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Testing (First PCR Test Date)')
        AND dbs.voided = 0
        AND dbs.value_datetime BETWEEN DATE_SUB('#startDate#', INTERVAL DAYOFMONTH('#startDate#')-1 DAY) AND LAST_DAY(DATE_ADD('#startDate#', INTERVAL 3 MONTH))
	LEFT JOIN obs enrolled
		ON enrolled.person_id = p.person_id
        AND enrolled.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Treatment - Enrolled AT ART Date')
        AND enrolled.voided = 0
	LEFT JOIN obs first_age
		ON first_age.person_id = p.person_id
        AND first_age.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Age at 1st DBS(Months)')
        AND first_age.voided = 0
	LEFT JOIN obs date_delivered
		ON date_delivered.person_id = p.person_id
        AND date_delivered.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'First PCR,Date results delivered to facility')
        AND date_delivered.voided = 0
	-- TODO : Review what hei patient shiv tatus is captured
	LEFT JOIN (
		SELECT e.patient_id as patient_id,
			IF(pcr_results.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Results Positive'), 1, 
            IF(pcr_results.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Results Negative'), 0, 2)) AS hiv_status
        FROM encounter e 
        INNER JOIN obs pcr_results
			ON pcr_results.encounter_id = e.encounter_id
            AND pcr_results.voided = 0
            AND pcr_results.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Testing (First PCR Results)')
		WHERE 
			e.voided = 0
    )hiv_status ON hiv_status.patient_id = pt.patient_id
    LEFT JOIN obs results_given
		ON results_given.person_id = p.person_id
        AND results_given.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'HEI Testing (First PCR Date Result Given to Caregiver)')
        AND results_given.voided = 0
	LEFT JOIN obs link_status
		ON link_status.person_id = p.person_id
        AND link_status.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Final Status')
        AND link_status.value_coded IS NOT NULL
        AND link_status.voided = 0
	-- Primary patient identifier doubles up as ART number
	LEFT JOIN patient_identifier pid
		ON pid.patient_id = pt.patient_id
        AND pid.identifier_type = (SELECT pit.patient_identifier_type_id FROM patient_identifier_type pit WHERE pit.name = 'Patient Identifier')
        AND pid.voided = 0
