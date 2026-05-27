SELECT pp.patient_id as "Patient ID",CONCAT(pn.given_name," ",pn.family_name) as "Patient Name",ROUND(DATEDIFF(CURDATE(), p2.birthdate)/365.25, 0 ) as "Age" , p2.gender as "Gender", phn.value as "Phone Number", co.name as "CoMorbidities"
FROM patient_program pp
JOIN program p ON pp.program_id = p.program_id AND p.name = "COVID-19 Program"
JOIN patient_program_attribute ppa ON ppa.patient_program_id = pp.patient_program_id
JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND ppa.value_reference="true"
JOIN person p2 ON pp.patient_id = p2.person_id
JOIN person_name pn ON p2.person_id =pn.person_id
LEFT JOIN (
	SELECT pa.value, pa.person_id
	FROM person_attribute pa
	JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id
	WHERE pat.name = "secondaryContact"
) phn ON phn.person_id = pp.patient_id
JOIN (
	SELECT DISTINCT o.person_id , cn.name
	FROM obs o
	JOIN concept_name cn
	ON o.value_coded = cn.concept_id and cn.concept_name_type = "FULLY_SPECIFIED"
	WHERE o.concept_id = (
		SELECT concept_id from concept_name where name = "COVID-19-Starter, Comorbidities"
	)
) co ON co.person_id=pn.person_id
where pp.patient_id NOT IN (SELECT DISTINCT person_id FROM obs where concept_id = (SELECT concept_id FROM concept_name where name="COVID-19-Starter, Dose-1"));
