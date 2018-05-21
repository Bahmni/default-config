
SELECT final.`Safe Abortion Service`,
  sum(final.Medical) AS medical,
  IF(final.Surgical='NA','NA',sum(final.Surgical)) AS surgical
FROM
(SELECT
    'Post Abortion Complications' AS 'Safe Abortion Service',
    SUM(IF(PAC_Compilications.Abortion_Name LIKE 'Medical Abortion%',PAC_Compilications.Count, 0)) AS 'Medical',
    SUM(IF(PAC_Compilications.Abortion_Name LIKE 'Surgical Abortion%', PAC_Compilications.Count, 0)) AS 'Surgical'
  FROM
    (
      SELECT t2.name AS Abortion_Name, COUNT(1) AS 'Count'
      FROM obs t1
        INNER JOIN concept_name t2 ON t1.concept_id = t2.concept_id AND t2.concept_name_type = 'FULLY_SPECIFIED' AND t2.voided = 0 
		AND t2.name IN
					('Medical Abortion complications','Surgical Abortion, Immediate complications','Surgical Abortion, Late complications')
        INNER JOIN person t3 ON t1.person_id = t3.person_id
        INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
        INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
      WHERE
        (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
        AND
        t1.voided = 0
      GROUP BY t2.name) AS PAC_Compilications

 UNION ALL

  SELECT
    'Post Abortion Care Service Availed' AS 'Safe Abortion Service',
    PAC_Cause.Count AS 'Medical',
    'NA' AS 'Surgical'
  FROM
    (
      SELECT t2.name AS Cause, COUNT(1) AS 'Count'
      FROM obs t1
        INNER JOIN concept_name t2 ON t1.concept_id = t2.concept_id AND t2.concept_name_type = 'FULLY_SPECIFIED' AND t2.voided = 0 AND t2.name IN
                                                                                                                                       ('PAC Cause','Not Applicable')
        INNER JOIN person t3 ON t1.person_id = t3.person_id
        INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
        INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
      WHERE
        (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
        AND
        t1.voided = 0
      GROUP BY t2.name) AS PAC_Cause
 UNION ALL SELECT 'Post Abortion Care Service Availed', 0 ,0
 UNION ALL SELECT 'Post Abortion Complications', 0 ,0
) final
GROUP BY final.`Safe Abortion Service`
ORDER BY final.`Safe Abortion Service`
;