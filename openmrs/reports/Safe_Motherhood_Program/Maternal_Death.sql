SELECT 'Maternal Death' AS 'Header',
       SUM(IF(Maternal_Death_Info.NAME LIKE '%AntePartum%', Maternal_Death_Info.COUNT, 0)) AS 'Ante-partum',
       SUM(IF(Maternal_Death_Info.NAME LIKE '%IntraPartum%', Maternal_Death_Info.COUNT, 0)) AS 'Intra-partum',
       SUM(IF(Maternal_Death_Info.NAME LIKE '%PostPartum%', Maternal_Death_Info.COUNT, 0)) AS 'Post-partum'
FROM
  (SELECT t2.name AS NAME, COUNT(*) AS COUNT FROM obs t1
    INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id
                                  AND t2.voided = 0 AND t2.concept_name_type = 'FULLY_SPECIFIED'
    INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
    INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
    INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id AND t5.voided = 0
                                  AND t5.concept_name_type = 'FULLY_SPECIFIED'
  WHERE t5.name = 'Death Note, Maternal Death'
        AND t1.voided = 0  AND
        (t1.obs_datetime >='#startDate#' AND t1.obs_datetime <= '#endDate#')
  GROUP BY t2.name) AS Maternal_Death_Info;