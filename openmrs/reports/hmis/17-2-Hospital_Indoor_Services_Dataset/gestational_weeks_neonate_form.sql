SELECT 
    birth.type AS 'Count of Delivery Outcome / Gestation Period',
    ifnull(SUM(22_27),0) AS '22 - 27',
    ifnull(SUM(28_36),0) AS '28 - 36',
    ifnull(SUM(37_41),0) AS '37 - 41',
    ifnull(SUM(above41),0) AS '>= 42'
FROM
    (SELECT 'Primi' AS type UNION SELECT 'Multi' AS type UNION SELECT 'Grand Multi' AS type) AS birth
        LEFT JOIN
    (SELECT 
        IF(a.parity LIKE 'Single%', 'Primi', IF(a.parity LIKE 'Twins%', 'Multi', 'Grand Multi')) AS delivery_outcome,
            IF(a.parity LIKE 'Single%', 1, IF(a.parity LIKE 'Twins%', 2, 3)) AS sort_order,
            SUM(IF(a.gestation_period BETWEEN 22 AND 27, 1, 0)) AS 22_27,
            SUM(IF(a.gestation_period BETWEEN 28 AND 36, 1, 0)) AS 28_36,
            SUM(IF(a.gestation_period BETWEEN 37 AND 41, 1, 0)) AS 37_41,
            SUM(IF(a.gestation_period >= 42, 1, 0)) AS above41
    FROM
    (
    SELECT
   distinct pi.identifier AS ip,
        gestation_period_obs.value_numeric as gestation_period,
        outcome_value.concept_full_name as parity
        
        
    FROM obs outcome_of_delivery_obs
   
	INNER JOIN concept_view outcome_value
       ON outcome_value.concept_id = outcome_of_delivery_obs.value_coded
       
    INNER JOIN encounter e ON outcome_of_delivery_obs.encounter_id = e.encounter_id
	INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON outcome_of_delivery_obs.person_id = p.person_id
        AND p.voided = 0
    INNER JOIN patient_identifier pi ON pi.patient_id = p.person_id
        AND pi.voided = '0'

     LEFT OUTER JOIN obs gestation_period_obs
     on gestation_period_obs.encounter_id = e.encounter_id
          AND gestation_period_obs.concept_id = (SELECT concept_id
                                                 FROM concept_view
                                                 WHERE concept_full_name = 'Delivery Note, Gestation period')
          AND gestation_period_obs.voided = FALSE
   WHERE
   (gestation_period_obs.value_numeric IS NOT NULL) and 
     outcome_of_delivery_obs.concept_id = (SELECT concept_id
                                           FROM concept_view
                                           WHERE concept_full_name = 'Delivery Note, Outcome of Delivery')
     AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
     AND outcome_of_delivery_obs.voided = FALSE group by pi.identifier) a  group by a.parity)  simpler_form ON simpler_form.delivery_outcome = birth.type
GROUP BY birth.type
ORDER BY birth.type DESC;