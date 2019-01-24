
SELECT 
 drugs.drug_name as 'Drug',
 age_days_grp.age_days AS 'Age-Days',
 ifnull(first_concept.count_total,0) as 'Total Patient less than 2 months'
FROM
    (select 'Amoxicillin' as drug_name union select 'Ampicillin' as drug_name union select 'Other Antibiotics' as drug_name) drugs
       INNER JOIN
    (SELECT '< 29 days' AS age_days UNION SELECT '29 - 59 days' AS age_days ) age_days_grp
        LEFT OUTER JOIN
    (
    
SELECT 
    COUNT(DISTINCT (amox_patient.person_id)) as count_total,
    'Amoxicillin' AS drug_group,
    amox_patient.agegroup
FROM
    (SELECT DISTINCT
        (o1.person_id), drug.name, 
         CASE
        WHEN
            TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) < 29
        THEN
            '< 29 days'
        WHEN
            TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) > 28
                AND TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) < 60
        THEN
            '29 - 59 days'
    END AS agegroup
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (<2 months child)'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    JOIN drug ON drug.drug_id = dord.drug_inventory_id
    WHERE
        drug.name IN ('Amoxicillin 250mg Tablet' , 'Amoxicillin 125mg/5ml Suspension, 60ml Bottle')
            AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) amox_patient
        JOIN
    (SELECT DISTINCT
        o1.person_id, cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness - PSBI/LBI/NBI - LBI' , 'PSBI/LBI/NBI, Jaundice', 'Difficulty feeding or low weight')
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    WHERE
             DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) lbiJaunLow_patient ON amox_patient.person_id = lbiJaunLow_patient.person_id  group by drug_group,agegroup
			
	

-- ===================== Ampicilin ========================

 union all 
SELECT 
    COUNT(DISTINCT (ampi_patient.person_id)) as count_total,
    'Ampicillin' AS drug_group,
    ampi_patient.agegroup
FROM
    (SELECT DISTINCT
        (o1.person_id), drug.name, 
         CASE
        WHEN
            TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) < 29
        THEN
            '< 29 days'
        WHEN
            TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) > 28
                AND TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) < 60
        THEN
            '29 - 59 days'
    END AS agegroup
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (<2 months child)'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    JOIN drug ON drug.drug_id = dord.drug_inventory_id
    WHERE
        drug.name IN ('Ampicillin & Cloxacillin 125/125mg /5ml Suspension, 40ml Bottle')
            AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) ampi_patient
        JOIN
    (SELECT DISTINCT
        o1.person_id, cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness - PSBI/LBI/NBI - LBI' , 'PSBI/LBI/NBI, Jaundice', 'Difficulty feeding or low weight')
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    WHERE
             DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) lbiJaunLow_patient ON ampi_patient.person_id = lbiJaunLow_patient.person_id
	
group by drug_group,agegroup



-- ===================== Other Antibiotics ========================

 union all 
SELECT 
    COUNT(DISTINCT (other_patient.person_id)) as count_total,
    'Other Antibiotics' AS drug_group,
    other_patient.agegroup
FROM
    (SELECT DISTINCT
        (o1.person_id), drug.name, 
         CASE
        WHEN
            TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) < 29
        THEN
            '< 29 days'
        WHEN
            TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) > 28
                AND TIMESTAMPDIFF(DAY,
                p1.birthdate,
                v.date_started) < 60
        THEN
            '29 - 59 days'
    END AS agegroup
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (<2 months child)'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    JOIN drug ON drug.drug_id = dord.drug_inventory_id
    WHERE
        drug.name in ('Amoxicillin & Clavulanate 200/28.5mg /5ml Suspension, 30ml Bottle',
    'Cefixime 60mg/5ml Suspension, 60ml Bottle',
    'Metronidazole 100mg/5ml Suspension, 60ml Bottle'
    ,'Cefadroxil 250mg/5ml Suspension, 30ml bottle') 
            AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) other_patient
        JOIN
    (SELECT DISTINCT
        o1.person_id, cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness - PSBI/LBI/NBI - LBI' , 'PSBI/LBI/NBI, Jaundice', 'Difficulty feeding or low weight')
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    WHERE
             DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) lbiJaunLow_patient ON other_patient.person_id = lbiJaunLow_patient.person_id
	
group by drug_group,agegroup

) first_concept ON first_concept.drug_group = drugs.drug_name
 and age_days_grp.age_days = first_concept.agegroup
 GROUP BY drugs.drug_name,age_days_grp.age_days
ORDER BY drugs.drug_name;