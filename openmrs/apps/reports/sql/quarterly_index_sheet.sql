-- Index Sheet Quarterly report

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Age Groups',
		year_q.year AS 'SEX',
        NULL 'Number of Index cases offered index testing services',
        NULL AS 'Number of index cases that accepted index testing services',
        NULL AS 'Number of contacts elicited (brought)',
        NULL AS 'New negative',
        NULL AS 'New positives',
        NULL AS 'Known positives',
        NULL AS 'Not tested '
FROM  (
	SELECT MONTHNAME(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) as month) quarter
		 JOIN (SELECT YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) as year
         )year_q

UNION ALL
SELECT  observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        sum(if(offered.val is not null , offered.val, 0)) AS 'Number of Index cases offered index testing services',
        sum(if(accepted.val is not null , accepted.val, 0)) AS 'Number of index cases that accepted index testing services',
        sum(if(elicited.val is not null , elicited.val, 0)) AS 'Number of contacts elicited (brought)',
        sum(if(new_negative.val is not null , 1, 0)) AS 'New negative',
        sum(if(new_positive.val is not null , 1, 0)) AS 'New positives',
        sum(if(known_positive.val is not null , 1, 0)) AS 'Known positives',
        sum(if(not_tested.val is not null , 1, 0)) AS 'Not tested '

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
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of indexes Offered for Testing')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS offered ON offered.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Indexes accepted to be tested')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS accepted ON accepted.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Contacts Elicited(Brought)')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS elicited ON elicited.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Negative')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_negative ON new_negative.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_positive ON new_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Known')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Result')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS known_positive ON known_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Tested')
                    AND obs2.value_coded > 0
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS not_tested ON not_tested.patient_id  = pt.patient_id

	WHERE
    pt.voided = 0
    GROUP BY observed_age_group.id

UNION  ALL
SELECT   NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Age Groups',
		year_q.year AS 'SEX',
        NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  (
	SELECT MONTHNAME(DATE_ADD('#startDate#', INTERVAL 1 MONTH)) as month) quarter
		 JOIN (SELECT YEAR(DATE_ADD('#startDate#', INTERVAL 1 MONTH)) as year
         )year_q

UNION ALL
SELECT  observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        sum(if(offered.val is not null , offered.val, 0)) AS 'Number of Index cases offered index testing services',
        sum(if(accepted.val is not null , accepted.val, 0)) AS 'Number of index cases that accepted index testing services',
        sum(if(elicited.val is not null , elicited.val, 0)) AS 'Number of contacts elicited (brought)',
        sum(if(new_negative.val is not null , 1, 0)) AS 'New negative',
        sum(if(new_positive.val is not null , 1, 0)) AS 'New positives',
        sum(if(known_positive.val is not null , 1, 0)) AS 'Known positives',
        sum(if(not_tested.val is not null , 1, 0)) AS 'Not tested '

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
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of indexes Offered for Testing')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS offered ON offered.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Indexes accepted to be tested')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS accepted ON accepted.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Contacts Elicited(Brought)')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS elicited ON elicited.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Negative')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_negative ON new_negative.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_positive ON new_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Known')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Result')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS known_positive ON known_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 1 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Tested')
                    AND obs2.value_coded > 0
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS not_tested ON not_tested.patient_id  = pt.patient_id

	WHERE
    pt.voided = 0
    GROUP BY observed_age_group.id

UNION  ALL
SELECT   NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL

SELECT   CONCAT('Reporting Month : ',quarter.month) AS 'Age Groups',
		year_q.year AS 'SEX',
        NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  (
	SELECT MONTHNAME(DATE_ADD('#startDate#', INTERVAL 2 MONTH)) as month) quarter
		 JOIN (SELECT YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH)) as year
         )year_q

UNION ALL
SELECT  observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        sum(if(offered.val is not null , offered.val, 0)) AS 'Number of Index cases offered index testing services',
        sum(if(accepted.val is not null , accepted.val, 0)) AS 'Number of index cases that accepted index testing services',
        sum(if(elicited.val is not null , elicited.val, 0)) AS 'Number of contacts elicited (brought)',
        sum(if(new_negative.val is not null , 1, 0)) AS 'New negative',
        sum(if(new_positive.val is not null , 1, 0)) AS 'New positives',
        sum(if(known_positive.val is not null , 1, 0)) AS 'Known positives',
        sum(if(not_tested.val is not null , 1, 0)) AS 'Not tested '

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
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of indexes Offered for Testing')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS offered ON offered.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Indexes accepted to be tested')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS accepted ON accepted.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Contacts Elicited(Brought)')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS elicited ON elicited.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Negative')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_negative ON new_negative.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_positive ON new_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Known')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Result')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS known_positive ON known_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) = MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) = YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Tested')
                    AND obs2.value_coded > 0
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS not_tested ON not_tested.patient_id  = pt.patient_id

	WHERE
    pt.voided = 0
    GROUP BY observed_age_group.id


UNION  ALL
SELECT   NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION  ALL
SELECT   'Summary' , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM  DUAL

UNION ALL
SELECT  observed_age_group.report_group_name AS 'Age Groups',
        observed_age_group.sex AS 'SEX',
        sum(if(offered.val is not null , offered.val, 0)) AS 'Number of Index cases offered index testing services',
        sum(if(accepted.val is not null , accepted.val, 0)) AS 'Number of index cases that accepted index testing services',
        sum(if(elicited.val is not null , elicited.val, 0)) AS 'Number of contacts elicited (brought)',
        sum(if(new_negative.val is not null , 1, 0)) AS 'New negative',
        sum(if(new_positive.val is not null , 1, 0)) AS 'New positives',
        sum(if(known_positive.val is not null , 1, 0)) AS 'Known positives',
        sum(if(not_tested.val is not null , 1, 0)) AS 'Not tested '

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
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) BETWEEN MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) BETWEEN YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of indexes Offered for Testing')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS offered ON offered.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) BETWEEN MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) BETWEEN YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Indexes accepted to be tested')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS accepted ON accepted.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_numeric AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) BETWEEN MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) BETWEEN YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Number of Contacts Elicited(Brought)')
                    AND obs.value_numeric IS NOT NULL
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS elicited ON elicited.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) BETWEEN MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) BETWEEN YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Negative')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_negative ON new_negative.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) BETWEEN MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) BETWEEN YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Status')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS new_positive ON new_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) BETWEEN MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) BETWEEN YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Known')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Result')
                    AND obs2.value_coded = (select concept_id from  concept_view where concept_full_name ='Positive')
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS known_positive ON known_positive.patient_id  = pt.patient_id
    LEFT JOIN (
		SELECT
        pt.patient_id AS patient_id,
		obs.value_coded AS val
			FROM patient pt
				INNER JOIN
					person p ON p.person_id = pt.patient_id
                    AND p.voided=0 AND pt.voided=0
				INNER JOIN encounter e
					ON e.patient_id = p.person_id
                    AND MONTH(e.encounter_datetime) BETWEEN MONTH(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND MONTH(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND YEAR(e.encounter_datetime) BETWEEN YEAR(DATE_ADD('#startDate#', INTERVAL 0 MONTH)) AND YEAR(DATE_ADD('#startDate#', INTERVAL 2 MONTH))
                    AND e.voided = 0
				INNER JOIN obs
					ON obs.encounter_id = e.encounter_id
					AND obs.voided=0 AND obs.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member - HIV Status')
                    AND obs.value_coded = (select concept_id from  concept_view where concept_full_name ='Don\'t Know')
				INNER JOIN obs obs2
					ON obs2.encounter_id = e.encounter_id
					AND obs2.voided=0 AND obs2.concept_id IN (select concept_id from  concept_view where concept_full_name ='Family Member Contacts Tested')
                    AND obs2.value_coded > 0
				INNER JOIN obs testing_point
					ON testing_point.encounter_id = e.encounter_id
					AND testing_point.concept_id = (select concept_id from  concept_view where concept_full_name ='HIV - Entry Point')
					AND testing_point.value_coded = (select concept_id from  concept_view where concept_full_name ='Index Testing')
    ) AS not_tested ON not_tested.patient_id  = pt.patient_id

	WHERE
    pt.voided = 0
    GROUP BY observed_age_group.id
