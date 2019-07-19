SELECT DISTINCT 
	 pai.identifier AS 'patient ID',
     pn.given_name AS 'First Name', 
	 ifnull(pn.family_name,'') AS 'Last Name',
	 pMobile.telephoneNo AS 'Telephone No.',
	 p.gender AS 'Gender',
	 DATE_FORMAT(obsConcept.artStartDate, "%d/%m/%Y") AS 'ART Start Date',
	 DATE_FORMAT(start_date_time, "%d/%m/%Y") AS 'Appointment Date' 
FROM patient_appointment pa 
   LEFT JOIN person p ON p.person_id = pa.patient_id AND pa.voided IS FALSE 
   LEFT JOIN person_name pn ON p.person_id = pn.person_id AND pn.voided IS FALSE 
   LEFT JOIN patient_identifier pai ON (pai.patient_id = pa.patient_id AND pai.preferred = 1) 
   LEFT JOIN (select paMobile.person_id as 'pMobilePersonId', paMobile.value AS 'telephoneNo'  from person_attribute paMobile 
   JOIN person_attribute_type patMobile ON patMobile.name = "MobileNumber" AND patMobile.retired IS FALSE
    AND patMobile.person_attribute_type_id = paMobile.person_attribute_type_id) AS pMobile ON pa.patient_id = pMobile.pMobilePersonId 
   LEFT JOIN (SELECT o.value_datetime AS 'artStartDate', v.patient_id AS 'visitPatientId', v.visit_id AS visitId FROM visit v 
   JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date") 
   JOIN encounter enc ON enc.visit_id = v.visit_id 
   JOIN obs o ON (o.encounter_id = enc.encounter_id and o.concept_id = cn.concept_id AND o.person_id = v.patient_id) 
   HAVING v.visit_id = (SELECT MAX(maxV.visit_id) as maxVisitId 
   FROM visit maxV WHERE maxV.patient_id = v.patient_id)) AS obsConcept ON obsConcept.visitPatientId = pa.patient_id 
WHERE pa.status = 'Missed' and pa.start_date_time BETWEEN '#startDate#' AND '#endDate#' ORDER BY pa.start_date_time DESC;
