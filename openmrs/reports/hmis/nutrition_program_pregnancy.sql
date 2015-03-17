-- Pregnant women receiving - Iron tablets first time
SELECT 'Patients Receiving Iron Tablets - First Time' AS "String", COUNT(DISTINCT(this_month.patient)) AS Result
FROM 
(SELECT ov.person_id AS patient
	FROM obs ov 
		INNER JOIN concept_name con on con.concept_id = ov.concept_id and con.name ='ANC, Number of IFA Tablets given' and con.concept_name_type = 'FULLY_SPECIFIED'
		WHERE ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#") AS this_month
LEFT JOIN 
(SELECT ov1.person_id as patient
	FROM obs ov1
		INNER JOIN concept_name con1 on con1.concept_id = ov1.concept_id and con1.name ='ANC, Number of IFA Tablets given' and con1.concept_name_type = 'FULLY_SPECIFIED'
		WHERE (DATEDIFF("#startDate#", ov1.obs_datetime)/30 BETWEEN 0 AND 9)) AS last_9_months         
ON this_month.patient = last_9_months.patient WHERE last_9_months.patient IS NULL


UNION 

-- Pregnant women receiving - 180 iron tablets
SELECT 'Patients Receiving > 180 Iron Tablets' as "String", COUNT(DISTINCT result.patient) AS Result
	FROM
	(SELECT ov.person_id AS patient, SUM(ov.value_numeric) AS TABLET_COUNT
	FROM obs ov
	INNER JOIN concept_name con on con.concept_id = ov.concept_id and con.name='ANC, Number of IFA Tablets given' and con.concept_name_type = 'FULLY_SPECIFIED'
	WHERE ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#"
	GROUP BY ov.person_id) AS result
WHERE result.TABLET_COUNT > 180


UNION

-- Pregnant women receiving - Deworming tablets
SELECT 'Patients Receiving Deworming Tablets' as "String", COUNT(DISTINCT(ov.person_id)) AS Result 
	FROM obs ov
    INNER JOIN concept_name con on con.concept_id = ov.concept_id and con.name='ANC, Albendazole given' and con.concept_name_type = 'FULLY_SPECIFIED'
	WHERE ov.value_coded = 1 and (ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#")

UNION 

-- PP women receiving - 45 iron tablets + Vit A
SELECT 'Postpartum Patients Receiving > 45 Iron Tablets' as "String", COUNT(DISTINCT(IFA.patient)) AS Result
	FROM
	(SELECT ov.person_id AS patient, SUM(ov.value_numeric) AS IFA_TABLETS 
		FROM obs ov
        INNER JOIN concept_name con on con.concept_id = ov.concept_id and con.name = 'PNC, IFA Tablets Provided' and con.concept_name_type = 'FULLY_SPECIFIED'
		WHERE ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#"
		GROUP BY ov.person_id) AS IFA
	WHERE IFA.IFA_TABLETS >= 45

UNION

SELECT 'Postpartum Patients Receiving Vitamin A Capsules' as "String", COUNT(DISTINCT(ov.person_id)) AS Result
		FROM obs ov
        INNER JOIN concept_name con on con.concept_id = ov.concept_id and con.name = 'PNC, Vitamin A Capsules Provided' and con.concept_name_type = 'FULLY_SPECIFIED'
		WHERE ov.value_numeric > 0 AND (ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#");
