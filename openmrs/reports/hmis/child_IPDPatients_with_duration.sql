SELECT patient_identifier.identifier, TIMESTAMPDIFF(DAY, visit.date_started, visit.date_stopped) AS 'IPD Duration', DATE(person.birthdate)
FROM person
JOIN patient_identifier ON person.person_id = patient_identifier.patient_id
	AND person.voided = 0
JOIN visit on visit.patient_id = person.person_id
    AND cast(visit.date_stopped as date) BETWEEN '#startDate#' AND '#endDate#'
    AND visit.date_stopped BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 0 YEAR), INTERVAL 0 DAY)) 
	AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 5 YEAR), INTERVAL -1 DAY))
    AND visit.voided=0
  JOIN visit_attribute AS va ON va.visit_id = visit.visit_id AND va.value_reference = 'IPD' 
  LEFT JOIN visit_attribute_type vat ON vat.visit_attribute_type_id = va.attribute_type_id 
 	AND vat.name = 'Visit Status'
  ORDER BY TIMESTAMPDIFF(DAY, visit.date_started, visit.date_stopped) DESC;
