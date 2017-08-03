
SELECT final.`Safe Abortion Service`,
  sum(final.Medical) AS medical,
  IF(final.Surgical='NA','NA',sum(final.Surgical)) AS surgical
FROM
(SELECT Safe_Abortion.Age_Cat AS 'Safe Abortion Service',
        SUM(IF(Safe_Abortion.concept_name LIKE 'Medical abortion%',1, 0)) AS 'Medical',
        SUM(IF(Safe_Abortion.concept_name LIKE 'Surgical Abortion%', 1, 0)) AS 'Surgical'
 FROM
   (SELECT t2.name AS concept_name,
           IF(DATE_FORMAT(FROM_DAYS(DATEDIFF(t1.obs_datetime, t3.birthdate)),'%Y')+0  < 20,
              'No of Women : < 20 Years','No of Women : >=20 Years') AS Age_Cat
    FROM obs t1
      INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id AND t2.concept_name_type LIKE 'SHORT%'
      INNER JOIN person t3 ON t1.person_id = t3.person_id
      INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
      INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
    WHERE
      t1.value_coded IN (SELECT answer_concept FROM concept_answer
      WHERE concept_id IN (SELECT concept_id FROM concept_name WHERE NAME='PAC Cause' AND voided = 0))
      AND
      (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
      AND
      t1.voided = 0) AS Safe_Abortion
 GROUP BY Safe_Abortion.Age_Cat
 UNION ALL
 SELECT PAC_Methods.Method AS 'Safe Abortion Service',
        SUM(IF(PAC_Methods.concept_name LIKE 'Medical abortion%',1, 0)) AS 'Medical',
        SUM(IF(PAC_Methods.concept_name LIKE 'Surgical Abortion%', 1, 0)) AS 'Surgical'
 FROM
   (
     SELECT
       Abortion_method.Method,
       PAC_Cause.concept_name
     FROM
       (
         SELECT t1.encounter_id, IF(t2.name IN ('Condoms', 'Pills','Depo Provera'),
                                    'Post Abortion FP methods:Short term','Post Abortion FP methods:Long term') AS Method
         FROM obs t1
           INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id AND t2.concept_name_type LIKE 'SHORT%'
           INNER JOIN person t3 ON t1.person_id = t3.person_id
           INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
           INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
         WHERE
           t1.concept_id IN (SELECT concept_id FROM concept_name WHERE NAME='Accepted Family Planning methods' AND voided = 0)
           AND
           (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
           AND
           t1.voided = 0) AS Abortion_method
       LEFT OUTER JOIN
       (
         SELECT t1.encounter_id,
           t2.name AS concept_name
         FROM obs t1
           INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id AND t2.concept_name_type LIKE 'SHORT%'
           INNER JOIN person t3 ON t1.person_id = t3.person_id
           INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
           INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
         WHERE
           t1.value_coded IN (SELECT answer_concept FROM concept_answer
           WHERE concept_id IN (SELECT concept_id FROM concept_name WHERE NAME='PAC Cause' AND voided = 0))
           AND
           (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
           AND
           t1.voided = 0
       ) AS PAC_Cause
         ON Abortion_method.encounter_id = PAC_Cause.encounter_id) AS PAC_Methods
 GROUP BY PAC_Methods.Method
 UNION ALL

  SELECT
    'Post Abortion Complications' AS 'Safe Abortion Service',
    SUM(IF(PAC_Compilications.Abortion_Name LIKE 'Medical Abortion%',PAC_Compilications.Count, 0)) AS 'Medical',
    SUM(IF(PAC_Compilications.Abortion_Name LIKE 'Surgical Abortion%', PAC_Compilications.Count, 0)) AS 'Surgical'
  FROM
    (
      SELECT t2.name AS Abortion_Name, COUNT(1) AS 'Count'
      FROM obs t1
        INNER JOIN concept_name t2 ON t1.concept_id = t2.concept_id AND t2.concept_name_type = 'FULLY_SPECIFIED' AND t2.voided = 0 AND t2.name IN
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
                                                                                                                                       ('PAC Cause')
        INNER JOIN person t3 ON t1.person_id = t3.person_id
        INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
        INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
      WHERE
        (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
        AND
        t1.voided = 0
      GROUP BY t2.name) AS PAC_Cause

 UNION ALL SELECT 'No of Women : < 20 Years' ,0,0
 UNION ALL SELECT 'No of Women : >=20 Years', 0 ,0
 UNION ALL SELECT 'Post Abortion Care Service Availed', 0 ,'NA'
 UNION ALL SELECT 'Post Abortion Complications', 0 ,0
 UNION ALL SELECT 'Post Abortion FP methods:Long term', 0 ,0
 UNION ALL SELECT 'Post Abortion FP methods:Short term', 0 ,0
) final
GROUP BY final.`Safe Abortion Service`
ORDER BY final.`Safe Abortion Service`
;