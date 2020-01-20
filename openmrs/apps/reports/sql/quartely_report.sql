use openmrs;

SELECT  if(observed_age_group.name = '25-29 yr M', 'PITC (Index)','') AS 'Testing point',
        observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        sum(if(tested.val is not null , 1, 0)) AS 'Total Tested',
        sum(if(positive.val is not null , 1, 0)) AS 'Tested Positive',
        sum(if(started.val = 1 , 1, 0)) AS 'Started ART in HF',
        sum(if(reffered.val is not null , 1, 0)) AS 'Reffered to other site for ART',
        sum(if(dead.val is not null , 1, 0)) AS 'Dead',
        '' AS 'Other (Specify)'

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
		SELECT 
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN obs 
					ON obs.person_id = pt.patient_id 
					AND obs.voided=0 AND obs.concept_id IN (3832) AND obs.value_coded = 3829
    ) AS reffered ON reffered.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT 
        pt.patient_id AS patient_id,
		obs.value_datetime AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN obs 
					ON obs.person_id = pt.patient_id 
					AND obs.voided=0 AND obs.concept_id IN (3738) AND obs.value_datetime IS NOT NULL
    ) AS positive ON positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT 
        pt.patient_id AS patient_id,
		obs.value_datetime AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN obs 
					ON obs.person_id = pt.patient_id 
					AND obs.voided=0 AND obs.concept_id IN (3738) AND obs.value_datetime IS NOT NULL
    ) AS tested ON tested.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT 
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN obs 
					ON obs.person_id = pt.patient_id 
					AND obs.voided=0 AND obs.concept_id IN (3756) AND obs.value_coded IS NOT NULL
    ) AS started ON started.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT 
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN obs 
					ON obs.person_id = pt.patient_id 
					AND obs.voided=0 AND obs.concept_id IN (3845) AND obs.value_coded IS NOT NULL
                    AND obs.value_coded = 1072
    ) AS dead ON dead.patient_id  = pt.patient_id
	WHERE
    pt.voided = 0
    GROUP BY observed_age_group.id;
