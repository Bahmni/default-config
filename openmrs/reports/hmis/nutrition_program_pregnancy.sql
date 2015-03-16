-- Pregnant women receiving - Iron tablets first time
SELECT 'Patients Receiving Iron Tablets - First Time' AS "String", COUNT(DISTINCT(this_month.patient)) AS Result
FROM 
(SELECT ov.person_id AS patient
	FROM obs_view ov 
		WHERE ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#"
		AND ov.concept_full_name ='ANC, Number of IFA Tablets given') AS this_month
LEFT JOIN 
(SELECT ov1.person_id as patient
	FROM obs_view ov1
		WHERE ov1.concept_full_name ='ANC, Number of IFA Tablets given'
        AND (DATEDIFF("#startDate#", ov1.obs_datetime)/30 BETWEEN 0 AND 9)) AS last_9_months         
ON this_month.patient = last_9_months.patient WHERE last_9_months.patient IS NULL

UNION 

-- Pregnant women receiving - 180 iron tablets
SELECT 'Patients Receiving > 180 Iron Tablets' as "String", COUNT(DISTINCT result.patient) AS Result
	FROM
	(SELECT ov.person_id AS patient, SUM(ov.value_numeric) AS TABLET_COUNT
	FROM obs_view ov
	WHERE ov.concept_full_name='ANC, Number of IFA Tablets given' AND (ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#")
	GROUP BY ov.person_id) AS result
WHERE result.TABLET_COUNT > 180

UNION

-- Pregnant women receiving - Deworming tablets
SELECT 'Patients Receiving Deworming Tablets' as "String", COUNT(DISTINCT(ov.person_id)) AS Result 
	FROM obs_view ov
	WHERE ov.concept_full_name='ANC, Albendazole given' AND (ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#")

UNION 

-- PP women receiving - 45 iron tablets + Vit A
SELECT 'Postpartum Patients Receiving > 45 Iron Tablets and Vit A' as "String", COUNT(DISTINCT(RESULT1.patient)) AS Result
	FROM
	(SELECT ov.person_id AS patient, SUM(ov.value_numeric) AS IFA_TABLETS 
		FROM obs_view ov
		WHERE ov.concept_full_name = 'PNC, IFA Tablets Provided' AND (ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#")
		GROUP BY ov.person_id) AS RESULT1
	INNER JOIN 
	(SELECT DISTINCT(ov.person_id) AS patient
		FROM obs_view ov
		WHERE ov.concept_full_name = 'PNC, Vitamin A Capsules Provided' AND ov.value_numeric > 0 AND (ov.obs_datetime BETWEEN "#startDate#" AND "#endDate#")) 
        AS RESULT2 ON RESULT1.patient = RESULT2.patient
	WHERE RESULT1.IFA_TABLETS >= 45

UNION

-- Blood transfusion  - NUMBER
SELECT 'Patients Blood Transfusions' as "String", CONCAT(CAST(COUNT(DISTINCT(person_id)) AS CHAR), ' Patients  -- ', CAST(SUM(Count)/1000 AS CHAR), ' Litres') AS Result
FROM
(SELECT obs1.person_id, obs1.concept_full_name AS Provided, obs2.concept_full_name AS Quantity, obs2.value_numeric AS Count 
	FROM obs_view obs1 
	INNER JOIN obs_view obs2 on obs1.encounter_id = obs2.encounter_id AND obs2.concept_full_name IN ('ANC, Blood Transfusion Quantity','Delivery Note, Blood transfusion quantity','PNC, Blood Transfusion Quantity') 
    WHERE obs1.concept_full_name IN ('ANC, Blood Transfusion Provided','Delivery Note, Blood transfusion provided','PNC, Blood Transfusion Provided') 
    AND (obs1.obs_datetime BETWEEN "#startDate#" AND "#endDate#") AND (obs2.obs_datetime BETWEEN "#startDate#" AND "#endDate#")) AS result_view;

