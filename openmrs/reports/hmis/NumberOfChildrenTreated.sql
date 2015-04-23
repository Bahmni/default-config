SELECT count(*)
FROM person
JOIN patient_identifier ON person.person_id = patient_identifier.patient_id
JOIN visit on visit.patient_id = person.person_id
    AND cast(visit.date_stopped as date) BETWEEN '#startDate' AND '#endDate'
    AND visit.date_stopped BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 0 YEAR), INTERVAL 0 DAY)) 
	AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL 5 YEAR), INTERVAL -1 DAY))