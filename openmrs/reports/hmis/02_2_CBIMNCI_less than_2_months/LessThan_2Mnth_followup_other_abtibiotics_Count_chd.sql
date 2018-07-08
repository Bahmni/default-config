<<<<<<< HEAD:openmrs/reports/hmis/02_2_CBIMNCI_less than_2_months/LessThan_2Mnth_followup_other_abtibiotics_Count_chd.sql
SELECT 
    first_question.answer_name AS 'Category',
    COUNT(DISTINCT (first_concept.person_id)) AS 'Total Patient'
FROM
    (SELECT 
        question_concept_name.concept_id AS question,
            IFNULL(question_concept_short_name.name, question_concept_name.name) AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    LEFT JOIN concept_name question_concept_short_name ON question_concept_name.concept_id = question_concept_short_name.concept_id
        AND question_concept_short_name.concept_name_type = 'SHORT'
        AND question_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('Childhood Illness, Follow up result' )
    ORDER BY answer_name DESC) first_question
        LEFT OUTER JOIN
    (SELECT DISTINCT
        o.person_id, cn1.concept_id AS question,
         (select name from concept_name where concept_id = o.value_coded AND
			o.voided IS FALSE and concept_name_type = 'FULLY_SPECIFIED' and voided = '0') as Diag
    FROM
        obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON o.person_id = p.person_id
        AND p.voided = 0
    WHERE
        cn1.name IN ('Childhood Illness, Follow up result' )
            AND TIMESTAMPDIFF(DAY, p.birthdate, v.date_started) < 60
			And DATE(o.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            -- AND DATE(o.obs_datetime) BETWEEN DATE('2017-01-01') AND DATE('2017-12-30')
			) first_concept ON first_concept.question = first_question.question AND first_concept.Diag = "TRUE"
GROUP BY first_question.answer_name

union all


SELECT 'Other Antibiotics' as category,
	count(DISTINCT(o1.person_id)) as Count
FROM
	obs o1
 INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Childhood Illness-<2 months, case'
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
    inner join
    drug drug on drug.drug_id = dord.drug_inventory_id
    and drug.name in ('Amoxicillin & Clavulanate 200/28.5mg /5ml Suspension, 30ml Bottle',
    'Cefixime 60mg/5ml Suspension, 60ml Bottle',
    'Metronidazole 100mg/5ml Suspension, 60ml Bottle'
    ,'Cefadroxil 250mg/5ml Suspension, 30ml bottle') 
WHERE
        TIMESTAMPDIFF(Day,p1.birthdate,v.date_started) < 60
        AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#');

=======
SELECT 
    first_question.answer_name AS 'Category',
    COUNT(DISTINCT (first_concept.person_id)) AS 'Total Patient'
FROM
    (SELECT 
        question_concept_name.concept_id AS question,
            IFNULL(question_concept_short_name.name, question_concept_name.name) AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    LEFT JOIN concept_name question_concept_short_name ON question_concept_name.concept_id = question_concept_short_name.concept_id
        AND question_concept_short_name.concept_name_type = 'SHORT'
        AND question_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('Childhood Illness-2 months-Follow up result')
    ORDER BY answer_name DESC) first_question
        LEFT OUTER JOIN
    (SELECT DISTINCT
        o.person_id, cn1.concept_id AS question,
         (select name from concept_name where concept_id = o.value_coded AND
			o.voided IS FALSE and concept_name_type = 'FULLY_SPECIFIED' and voided = '0') as Diag
    FROM
        obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON o.person_id = p.person_id
        AND p.voided = 0
    WHERE
        cn1.name IN ('Childhood Illness, Follow up result' )
            AND TIMESTAMPDIFF(DAY, p.birthdate, v.date_started) < 60
			And DATE(o.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            -- AND DATE(o.obs_datetime) BETWEEN DATE('2017-01-01') AND DATE('2017-12-30')
			) first_concept ON first_concept.question = first_question.question AND first_concept.Diag = "TRUE"
GROUP BY first_question.answer_name

union all


SELECT 'Other Antibiotics' as category,
	count(DISTINCT(o1.person_id)) as Count
FROM
	obs o1
 INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Childhood Illness-<2 months, case'
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
    inner join
    drug drug on drug.drug_id = dord.drug_inventory_id
    and drug.name in ('Amoxicillin & Clavulanate 200/28.5mg /5ml Suspension, 30ml Bottle',
    'Cefixime 60mg/5ml Suspension, 60ml Bottle',
    'Metronidazole 100mg/5ml Suspension, 60ml Bottle'
    ,'Cefadroxil 250mg/5ml Suspension, 30ml bottle') 
WHERE
        TIMESTAMPDIFF(Day,p1.birthdate,v.date_started) < 60
        AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#');

>>>>>>> 5f8bd162ab3e1719b46ad1099f67f1bf2d5731bd:openmrs/reports/hmis/02-2-CBIMNCI/LessThan_2Mnth_followup_other_abtibiotics_Count_chd.sql
