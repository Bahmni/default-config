SELECT 
 first_answers.answer_name as 'Drug',
 ifnull(first_concept.count_total,0) as 'Total Patient (2-59) months'
FROM
    (SELECT 
        ca.answer_concept AS answer,
            IFNULL(answer_concept_short_name.name, answer_concept_fully_specified_name.name) AS answer_name,
            question_concept_name.name AS category
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    INNER JOIN concept_answer ca ON c.concept_id = ca.concept_id
    INNER JOIN concept_name answer_concept_fully_specified_name ON ca.answer_concept = answer_concept_fully_specified_name.concept_id
        AND answer_concept_fully_specified_name.concept_name_type = 'FULLY_SPECIFIED'
        AND answer_concept_fully_specified_name.voided
        IS FALSE
    LEFT JOIN concept_name answer_concept_short_name ON ca.answer_concept = answer_concept_short_name.concept_id
        AND answer_concept_short_name.concept_name_type = 'SHORT'
        AND answer_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ( 'Childhood Illness - Treatment - Treated with 2-59')
            AND cd.name = 'Coded'
    ORDER BY answer_name DESC) first_answers
        LEFT OUTER JOIN
    (
select drug_group,
count(distinct person_id) as count_total
from 
(
SELECT DISTINCT
    (o1.person_id),
    Case
	WHEN (SELECT   name  FROM  drug WHERE drug_id = dord.drug_inventory_id) in ('P lyte 500 ml IV fluid','Normal Saline 0.9% 500ml Injection','Ringer\'s Lactate, 500ml Injection')
    THEN  'IV Fluid'
	WHEN (SELECT   name  FROM  drug WHERE drug_id = dord.drug_inventory_id) in ('Albendazole 400mg chewable Tablet','Albendazole 200mg/5ml Suspension') 
    THEN  'Anti-helminthes'
	WHEN (SELECT   lower(name)  FROM  drug WHERE drug_id = dord.drug_inventory_id) LIKE '%Vitamin A%' 
    THEN  'Retinol (Vitamin A)'
    WHEN (SELECT   lower(name)  FROM  drug WHERE drug_id = dord.drug_inventory_id) in ('Amoxicillin & Clavulanate 200/28.5mg /5ml Suspension, 30ml Bottle','Cefixime 60mg/5ml Suspension, 60ml Bottle','Metronidazole 100mg/5ml Suspension, 60ml Bottle'
    ,'Cefadroxil 250mg/5ml Suspension, 30ml bottle') 
    THEN  'Other Antibiotics'
    END AS drug_group
FROM
    obs o1
        INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (2 to 59 months child)'
        AND o1.voided = 0
        AND cn1.voided = 0
        INNER JOIN
    encounter e ON o1.encounter_id = e.encounter_id
        INNER JOIN
    person p1 ON o1.person_id = p1.person_id
        INNER JOIN
    visit v ON v.visit_id = e.visit_id
        LEFT JOIN
    orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
        INNER JOIN
    drug_order dord ON dord.order_id = ord.order_id
WHERE
    TIMESTAMPDIFF(MONTH,
        p1.birthdate,
        v.date_started) > 1
        AND TIMESTAMPDIFF(MONTH,
        p1.birthdate,
        v.date_started) < 60
        AND DATE(e.encounter_datetime) BETWEEN  DATE('#startDate#') AND DATE('#endDate#')
        
 union all 
        
SELECT 
    zin_ors_childs.person_id, zin_ors_childs.drug_group
FROM
    (SELECT 
        person_id, drug_group
    FROM
        (SELECT DISTINCT
        (o1.person_id),
            CASE
                WHEN
                    (GROUP_CONCAT(DISTINCT (SELECT 
                            name
                        FROM
                            drug
                        WHERE
                            drug_id = dord.drug_inventory_id)
                        SEPARATOR '||')) LIKE '%zinc%'
                        AND (GROUP_CONCAT(DISTINCT (SELECT 
                            name
                        FROM
                            drug
                        WHERE
                            drug_id = dord.drug_inventory_id)
                        SEPARATOR '||')) LIKE '%oral rehydration solution%'
                THEN
                    'ORS and Zinc'
            END AS drug_group
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (2 to 59 months child)'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    WHERE
        TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
    GROUP BY person_id) a
    WHERE
        drug_group IS NOT NULL) zin_ors_childs
        JOIN
    (SELECT DISTINCT
        o1.person_id,
            cn2.concept_id AS answer,
            cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness, Dehydration Status')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name IN ('No Dehydration' , 'Severe Dehydration', 'Some Dehydration')
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    WHERE
        TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) dehydration_childs ON zin_ors_childs.person_id = dehydration_childs.person_id

union all 

SELECT 
     distinct amox_patient.person_id, 'Amoxicillin' AS drug_group
FROM
    (SELECT DISTINCT
        (o1.person_id), drug.name
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (2 to 59 months child)'
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
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) amox_patient
        JOIN
    (SELECT DISTINCT
        o1.person_id,
            cn2.concept_id AS answer,
            cn1.concept_id AS question
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness (2-59)-ARI-Classification')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
		AND cn2.name in ('Severe Pneumonia','Pneumonia')
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    WHERE
        TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) ari_patient ON amox_patient.person_id = ari_patient.person_id

 )  b

group by drug_group) first_concept ON first_concept.drug_group = first_answers.answer_name


GROUP BY first_answers.answer_name
ORDER BY first_answers.answer_name;