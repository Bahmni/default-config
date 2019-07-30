SELECT DISTINCT 
	 pai.identifier AS 'patient ID',
     pn.given_name AS 'First Name', 
	 ifnull(pn.family_name,'') AS 'Last Name',
	 DATE_FORMAT(pa.start_date_time, "%d/%m/%Y") AS 'Appointment Date', 
	 pa.status AS 'Status',
	 pMobile.telephoneNo AS 'Contact No.',
	 p.gender AS 'Gender' 
FROM patient_appointment pa 
   LEFT JOIN person p ON p.person_id = pa.patient_id AND pa.voided IS FALSE 
   LEFT JOIN person_name pn ON p.person_id = pn.person_id AND pn.voided IS FALSE 
   LEFT JOIN patient_identifier pai ON (pai.patient_id = pa.patient_id AND pai.preferred = 1) 
   LEFT JOIN (select paMobile.person_id as 'pMobilePersonId', paMobile.value AS 'telephoneNo'  from person_attribute paMobile 
   JOIN person_attribute_type patMobile ON patMobile.name = "MobileNumber" AND patMobile.retired IS FALSE
    AND patMobile.person_attribute_type_id = paMobile.person_attribute_type_id) AS pMobile ON pa.patient_id = pMobile.pMobilePersonId 
WHERE pa.appointment_kind = 'Scheduled' AND pa.start_date_time BETWEEN '#startDate#' AND '#endDate#' 
ORDER BY pa.start_date_time DESC;
