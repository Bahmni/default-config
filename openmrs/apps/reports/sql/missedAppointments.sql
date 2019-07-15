SELECT
	 pai.identifier AS 'patient ID',
     pn.given_name AS 'First Name', 
	 ifnull(pn.family_name,'') AS 'Last Name',
	 paMobile.value AS 'Telephone No.',
	 p.gender AS 'Gender',
	 DATE_FORMAT(obsConcept.artStartDate, "%d/%m/%Y") AS 'ART Start Date',
	 DATE_FORMAT(start_date_time, "%d/%m/%Y") AS 'Appointment Date'
FROM patient_appointment pa 
   LEFT JOIN person p ON p.person_id = pa.patient_id AND pa.voided IS FALSE
   LEFT JOIN person_name pn ON p.person_id = pn.person_id AND pn.voided IS FALSE
   LEFT JOIN patient_identifier pai on (pai.patient_id = pa.patient_id and pai.preferred = 1) 
   LEFT JOIN person_attribute_type patMobile on patMobile.name = "MobileNumber" and patMobile.retired IS FALSE 
   LEFT JOIN person_attribute paMobile on (pa.patient_id = paMobile.person_id and paMobile.voided is false and patMobile.person_attribute_type_id = paMobile.person_attribute_type_id) 
   JOIN (SELECT o.value_datetime AS 'artStartDate', v.patient_id AS 'visitPatientId' FROM visit v 
   LEFT JOIN encounter enc ON enc.visit_id = v.visit_id 
   LEFT JOIN obs o ON o.encounter_id = enc.encounter_id 
   JOIN concept_name cn on (o.concept_id = cn.concept_id and cn.concept_name_type = "FULLY_SPECIFIED" and cn.voided=0 and cn.name="ANC, ART Start Date") 
   order by v.date_started desc limit 1) AS obsConcept ON obsConcept.visitPatientId = pa.patient_id 
WHERE start_date_time BETWEEN '#startDate#' AND '#endDate#' ORDER BY start_date_time DESC;
