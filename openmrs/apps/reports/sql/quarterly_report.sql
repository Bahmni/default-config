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
		AND  CASE WHEN observed_age_group.report_group_name = 'Total All' THEN observed_age_group.sex in ('M','F') else observed_age_group.sex = p.gender  END
	LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
				INNER JOIN obs
					ON obs.person_id = pt.patient_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr M', 'PITC (Emergency)','') AS 'Testing point',
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Emergency, entry point')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Emergency, entry point')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Emergency, entry point')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Emergency, entry point')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Emergency, entry point')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr M', 'PITC (Inpatient)','') AS 'Testing point',
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='In Patient')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='In Patient')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='In Patient')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='In Patient')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='In Patient')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr M', 'PITC (OPD)','') AS 'Testing point',
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Entry Point - OPD')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Entry Point - OPD')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Entry Point - OPD')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Entry Point - OPD')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Entry Point - OPD')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id


UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '1-4 yr M', 'PITC (Malnutrition facilities)','') AS 'Testing point',
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
        AND (observed_age_group.name LIKE'<1 yr%' OR  observed_age_group.name LIKE '1-4 yr%' OR observed_age_group.report_group_name='10 to 14 years')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Malnutrition Facilities')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Malnutrition Facilities')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Malnutrition Facilities')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Malnutrition Facilities')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Malnutrition Facilities')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '1-4 yr M', 'PITC (Pediatric <5 clinic)','') AS 'Testing point',
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
        AND (observed_age_group.report_group_name ='Less than 1 year' OR observed_age_group.report_group_name='1 to 4 years')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Padeatric')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Padeatric')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Padeatric')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Padeatric')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Padeatric')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr F', 'PMTCT (1st ANC only)','') AS 'Testing point',
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
        AND observed_age_group.sex = 'F'
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr F', 'PMTCT (Post ANC 1)','') AS 'Testing point',
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
        AND observed_age_group.sex = 'F'
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='ANC Clinic')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr M', 'PITC (TB)','') AS 'Testing point',
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='TB Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='TB Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='TB Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='TB Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='TB Clinic')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id

UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr M', 'VCT','') AS 'Testing point',
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='VCT Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='VCT Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='VCT Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='VCT Clinic')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='VCT Clinic')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id


UNION  ALL
SELECT  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT  if(observed_age_group.name = '25-29 yr M', 'PITC (Other)','') AS 'Testing point',
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Plan')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Refer')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Other Entry Point (Specify)')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Other Entry Point (Specify)')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Date First Tested HIV +')
                    AND obs.value_datetime IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Other Entry Point (Specify)')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Transferred in on ART?')
                    AND obs.value_coded IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Other Entry Point (Specify)')
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
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='End Of Follow Up Reason')
                    AND obs.value_coded IS NOT NULL
                    AND obs.value_coded =  (select concept_id from  concept_view where concept_full_name ='Death during treatment')
				INNER JOIN obs testing_point
					ON testing_point.person_id = pt.patient_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Other Entry Point (Specify)')
    ) AS dead ON dead.patient_id  = pt.patient_id
    GROUP BY observed_age_group.id
