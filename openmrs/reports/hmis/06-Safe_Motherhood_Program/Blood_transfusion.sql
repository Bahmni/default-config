SELECT 
    final.Blood AS Blood,
    SUM(final.BloodTransfusion) AS 'Blood Transfusion'
FROM
    (SELECT 
        'No of Females' AS Blood,
            COUNT(DISTINCT (p1.person_id)) AS BloodTransfusion
    FROM
        obs t1
    INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
    INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
    INNER JOIN person p1 ON t1.person_id = p1.person_id
    INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id
        AND t5.voided = 0
        AND t5.concept_name_type = 'FULLY_SPECIFIED'
    WHERE
        t5.name = 'Delivery Note, Blood transfusion quantity'
            AND t1.voided = 0
            AND t1.value_numeric > 0
            AND (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#') UNION ALL SELECT 
        'Unit' AS Blood, SUM(t1.value_numeric) AS BloodTransfusion
    FROM
        obs t1
    INNER JOIN encounter t3 ON t1.encounter_id = t3.encounter_id
    INNER JOIN visit t4 ON t3.visit_id = t4.visit_id
    INNER JOIN concept_name t5 ON t1.concept_id = t5.concept_id
        AND t5.voided = 0
        AND t5.concept_name_type = 'FULLY_SPECIFIED'
    WHERE
        t5.name = 'Delivery Note, Blood transfusion quantity'
            AND t1.voided = 0
            AND (DATE(t1.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
    GROUP BY t5.name UNION ALL SELECT 'No of Females', 0 UNION ALL SELECT 'Unit', 0) final
GROUP BY final.Blood
ORDER BY final.Blood;