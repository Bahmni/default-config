SELECT  CONCAT('Reporting Month : ',CONCAT(quarter.start_mon, '-' , quarter.month)) AS 'Serial \#', 
		year_q.year AS 'Date of birth', 
        NULL AS 'EID Number', 
        NULL AS 'Sex', 
        NULL AS 'Date EID sample collected' ,
        NULL AS '0 - 2 months of age',
        NULL AS ' 2-12 months of age',
        NULL AS 'Final outcome at 24 months of age  (1. HIV infected; 2- HIV-uninfected; 3-HIV final status unknown;4-Died without status known:'
FROM  (
	SELECT MONTHNAME(DATE_SUB('#startDate#', INTERVAL DAYOFMONTH('#startDate#')-1 DAY)) as start_mon, 
		MONTHNAME(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as month) quarter
	JOIN (
			SELECT YEAR(LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))) as year
         )year_q
         
         
UNION ALL

SELECT  NULL AS 'Serial \#', 
		DATE_FORMAT(p.birthdate, "%d/%m/%Y")AS 'Date of birth', 
        hei_no.value AS 'EID Number', 
        p.gender AS 'Sex', 
        DATE_FORMAT(date_sample_collected.value_datetime, "%d/%m/%Y") AS 'Date EID sample collected' ,
        IF(eid_age.value_numeric IS NOT NULL, IF(eid_age.value_numeric <=2, 1, ''),
			IF(date_sample_collected.value_datetime IS NOT NULL AND TIMESTAMPDIFF( MONTH, p.birthdate, date_sample_collected.value_datetime) <=2 , 1 , '')) AS '0 - 2 months of age',
        IF(eid_age.value_numeric IS NOT NULL, IF(eid_age.value_numeric BETWEEN 3 AND 12 , 1, ''),
			IF(date_sample_collected.value_datetime IS NOT NULL AND TIMESTAMPDIFF( MONTH, p.birthdate, date_sample_collected.value_datetime)  BETWEEN 3 AND 12 , 1 , '')) AS ' 2-12 months of age',
        CASE 
			WHEN outcome.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= '24Months Outcome,HIV infected') THEN 1
            WHEN outcome.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= '24Months Outcome,HIV uninfected') THEN 2
            WHEN outcome.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= '24Months Outcome,HIV Final Status Unknown') THEN 3
            WHEN outcome.value_coded = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= '24Months Outcome,Died without status known') THEN 4
		END
        AS  'Final outcome at 24 months of age  (1. HIV infected; 2- HIV-uninfected; 3-HIV final status unknown;4-Died without status known:'
FROM
	patient pt
    INNER JOIN
		person p ON p.person_id = pt.patient_id
        AND p.voided = 0
        AND pt.voided =  0
        AND p.birthdate BETWEEN DATE_SUB('#startDate#', INTERVAL DAYOFMONTH('#startDate#')-1 DAY) AND LAST_DAY(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
	INNER JOIN person_attribute hei_no
		ON hei_no.person_id = p.person_id 
		AND hei_no.person_attribute_type_id = (select pat.person_attribute_type_id from person_attribute_type pat where name='HIVExposedInfant(HEI)No')
	LEFT JOIN obs date_sample_collected
		ON date_sample_collected.person_id = p.person_id
        AND date_sample_collected.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Date EID sample collected')
        AND date_sample_collected.voided = 0
	LEFT JOIN obs eid_age
		ON eid_age.person_id = p.person_id
        AND eid_age.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'EID - Age at 1st EID')
        AND eid_age.voided = 0
	LEFT JOIN obs outcome
		ON outcome.person_id = p.person_id
        AND outcome.concept_id = (SELECT cv.concept_id FROM concept_view cv where cv.concept_full_name= 'Final outcome at 24 months of age')
        AND outcome.value_coded IS NOT NULL
        AND outcome.voided = 0
