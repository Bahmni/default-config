SELECT
  final.antenatalCheckup 'Antenatal Checkup',
  sum(final.lessThan20) '< 20 Years',
  sum(final.moreThan20) '>=20 Years'
FROM
(SELECT
  anc_table.concept_names             AS antenatalCheckup,
  SUM(IF(anc_table.age < 20, 1, 0))  AS lessThan20,
  SUM(IF(anc_table.age >= 20, 1, 0)) AS moreThan20
FROM
  (
    (SELECT
	DISTINCT(t3.person_id),
       t2.name                                                         AS concept_names,
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
DISTINCT person.person_id,
    cn2.name AS concept_names,
	       DATE_FORMAT(FROM_DAYS(DATEDIFF(obs.obs_datetime, person.birthdate)), '%Y') + 0 AS age


FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'ANC, ANC Visit'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
        INNER JOIN
    concept_name cn2 ON obs.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
        AND cn2.name = 'ANC, 1st (any time)'
WHERE
    DATE(obs.obs_datetime)BETWEEN '#startDate#' AND '#endDate#' 
    )
	UNION ALL
	(SELECT 
    DISTINCT person.person_id,
    cn2.name AS concept_names,
	       DATE_FORMAT(FROM_DAYS(DATEDIFF(obs.obs_datetime, person.birthdate)), '%Y') + 0 AS age
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'ANC, ANC Visit'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
        INNER JOIN
    concept_name cn2 ON obs.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
        AND cn2.name = 'ANC, 1st (per protocol)'
WHERE
    DATE(obs.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')) anc_table
GROUP BY anc_table.concept_names
-- ------------------------------------------------------------------------------------
UNION ALL SELECT 'ANC, 1st (per protocol)', 0, 0
UNION ALL SELECT'ANC, 1st (any time)',0,0
UNION ALL SELECT 'Completed 4 ANC visits per protocol',0,0) final
GROUP BY final.antenatalCheckup
ORDER BY final.antenatalCheckup;