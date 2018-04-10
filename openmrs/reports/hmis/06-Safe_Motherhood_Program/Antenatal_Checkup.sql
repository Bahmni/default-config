SELECT
  final.antenatalCheckup 'Antenatal Checkup',
  sum(final.lessThan20) '< 20 Years',
  sum(final.moreThan20) '>=20 Years'
FROM
(SELECT
  anc_table.concept_name             AS antenatalCheckup,
  SUM(IF(anc_table.age < 20, 1, 0))  AS lessThan20,
  SUM(IF(anc_table.age >= 20, 1, 0)) AS moreThan20
FROM
  (
    (SELECT
       t2.name                                                         AS concept_name,
       DATE_FORMAT(FROM_DAYS(DATEDIFF(t1.obs_datetime, t3.birthdate)), '%Y') + 0 AS age
     FROM obs t1
       INNER JOIN concept_name t2 ON t1.concept_id = t2.concept_id AND t2.concept_name_type LIKE 'SHORT%'
       INNER JOIN person t3 ON t1.person_id = t3.person_id
       INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
       INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
     WHERE
       t1.concept_id IN (SELECT concept_id
                         FROM concept_name
                         WHERE NAME = 'ANC, Completed 4 ANC visits' AND voided = 0)
       AND t1.value_coded = 1 AND
       (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
       AND t1.voided = 0)
    UNION ALL
    (SELECT
       t2.name                                                         AS concept_name,
       DATE_FORMAT(FROM_DAYS(DATEDIFF(t1.obs_datetime, t3.birthdate)), '%Y') + 0 AS age
     FROM obs t1
       INNER JOIN concept_name t2 ON t1.value_coded = t2.concept_id AND t2.concept_name_type LIKE 'SHORT%'
       INNER JOIN person t3 ON t1.person_id = t3.person_id
       INNER JOIN encounter t4 ON t1.encounter_id = t4.encounter_id
       INNER JOIN visit t5 ON t4.visit_id = t5.visit_id
     WHERE
       t1.value_coded IN (SELECT concept_id
                          FROM concept_name
                          WHERE NAME IN ('ANC, 1st (per protocol)', 'ANC, 1st (any time)')
                                AND voided = 0)
       AND
       (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
       AND
       t1.voided = 0
    )) anc_table
GROUP BY anc_table.concept_name
-- ------------------------------------------------------------------------------------
UNION ALL SELECT '1st (per protocol)', 0, 0
UNION ALL SELECT'1st (any time)',0,0
UNION ALL SELECT 'Completed 4 ANC visits per protocol',0,0) final
GROUP BY final.antenatalCheckup
ORDER BY final.antenatalCheckup;