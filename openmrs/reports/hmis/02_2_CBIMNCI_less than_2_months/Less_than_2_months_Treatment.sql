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
select drug_group,
agegroup,
count(distinct person_id) as count_total
from 
(
SELECT DISTINCT
    (o1.person_id),
    CASE
			WHEN TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) < 29 THEN '< 29 days'
			WHEN
				TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) > 28
					AND TIMESTAMPDIFF(DAY, p1.birthdate, v.date_started) < 60
			THEN
				'29 - 59 days'
		END AS agegroup,
    CASE
	WHEN (SELECT   name FROM  drug WHERE drug_id = dord.drug_inventory_id) in ('Amoxicillin 125mg/5ml Suspension, 60ml Bottle') 
    THEN  'Amoxicillin'
	
	WHEN (SELECT   name  FROM  drug WHERE drug_id = dord.drug_inventory_id) in ('Ampicillin & Cloxacillin 125/125mg /5ml Suspension, 40ml Bottle') 
    THEN  'Ampicillin'
	
    WHEN (SELECT   lower(name)  FROM  drug WHERE drug_id = dord.drug_inventory_id) in ('Amoxicillin & Clavulanate 200/28.5mg /5ml Suspension, 30ml Bottle',
    'Cefixime 60mg/5ml Suspension, 60ml Bottle',
    'Metronidazole 100mg/5ml Suspension, 60ml Bottle'
    ,'Cefadroxil 250mg/5ml Suspension, 30ml bottle') 
    
    
    THEN  'Other Antibiotics'
    END AS drug_group
FROM
    obs o1
        INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'CBIMNCI (<2 months child)'
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
    TIMESTAMPDIFF(DAY,
        p1.birthdate,
        v.date_started) > 1
        AND TIMESTAMPDIFF(DAY,
        p1.birthdate,
        v.date_started) < 60
        AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#') 
        )  b

group by drug_group,agegroup) first_concept ON first_concept.drug_group = drugs.drug_name
 and age_days_grp.age_days = first_concept.agegroup
 GROUP BY drugs.drug_name,age_days_grp.age_days
ORDER BY drugs.drug_name;