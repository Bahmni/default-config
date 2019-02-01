SELECT 
 first_answers.answer_name as 'Drug',
 ifnull(first_concept.count_total,0) as 'Total Patient (2-59) months'
FROM
    (select  'Retinol (Vitamin A)'  as answer_name union 
	select  'Other Antibiotics' as answer_name union 
	select  'ORS only'  as answer_name union 
	select  'ORS and Zinc'  as answer_name union 
	select  'IV Fluid'  as answer_name union 
	select  'Anti-helminthes'  as answer_name union 
	select 'Amoxicillin'  as answer_name union
	select 'Contrim'  as answer_name
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
        AND DATE(e.encounter_datetime) BETWEEN   '#startDate#' AND '#endDate#'
        
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
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    WHERE
        TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN  '#startDate#' AND '#endDate#'
    GROUP BY person_id) a
    WHERE
        drug_group IS NOT NULL) zin_ors_childs
        

union all  -- contrim

SELECT 
     distinct a.person_id, 'Contrim' AS drug_group
FROM
    (SELECT DISTINCT
        (o1.person_id), drug.name
    FROM
       obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness (2-59)-ARI-Classification')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
		AND cn2.name in ('Childhood Illness (2-59)-ARI-Classification-Pneumonia','Childhood Illness (2-59)-ARI-Classification-Severe Pneumonia')
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    JOIN drug ON drug.drug_id = dord.drug_inventory_id
    WHERE
       drug.name IN (select name from drug where name like '%Cotrim%') 
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN   '#startDate#' AND '#endDate#') a
			

union all  -- Other antibiotics

SELECT 
     distinct a.person_id, 'Other Antibiotics' AS drug_group
FROM
    (SELECT DISTINCT
        (o1.person_id), drug.name
    FROM
       obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness (2-59)-ARI-Classification')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
		AND cn2.name in ('Childhood Illness (2-59)-ARI-Classification-Pneumonia','Childhood Illness (2-59)-ARI-Classification-Severe Pneumonia')
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    JOIN drug ON drug.drug_id = dord.drug_inventory_id
    WHERE
       drug.name IN('Amoxicillin & Clavulanate 200/28.5mg /5ml Suspension, 30ml Bottle','Cefixime 60mg/5ml Suspension, 60ml Bottle','Metronidazole 100mg/5ml Suspension, 60ml Bottle','Cefadroxil 250mg/5ml Suspension, 30ml bottle') 
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN   '#startDate#' AND '#endDate#') a
        

union all -- Amoxillin

SELECT 
     distinct a.person_id, 'Amoxicillin' AS drug_group
FROM
    (SELECT DISTINCT
        (o1.person_id), drug.name
    FROM
       obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Childhood Illness (2-59)-ARI-Classification')
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
		AND cn2.name in ('Childhood Illness (2-59)-ARI-Classification-Pneumonia','Childhood Illness (2-59)-ARI-Classification-Severe Pneumonia')
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    LEFT JOIN orders ord ON ord.patient_id = o1.person_id
        AND ord.order_type_id = 2
        AND ord.voided = 0
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    JOIN drug ON drug.drug_id = dord.drug_inventory_id
    WHERE
        drug.name IN (select name from drug where name like '%Amox%')
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) > 1
            AND TIMESTAMPDIFF(MONTH, p1.birthdate, v.date_started) < 60
            AND DATE(e.encounter_datetime) BETWEEN   '#startDate#' AND '#endDate#') a

 )  b

group by drug_group ) first_concept ON first_concept.drug_group = first_answers.answer_name


GROUP BY first_answers.answer_name
ORDER BY first_answers.answer_name;