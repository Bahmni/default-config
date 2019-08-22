SELECT DISTINCT IFNULL(DATE_FORMAT(artStartDate, "%d/%m/%Y"), '') AS "ART Start Date", 
IFNULL(IF(retestBeforeArt IS NULL OR retestBeforeArt = '', '0', '1'), '') AS "HIV Retesting for ART initiation", 
IFNULL(pUART.UniqueArtNo, '') AS "Unique ART Number", concat(pn.given_name, ' ', IF(pn.middle_name IS NULL OR pn.middle_name = '', '', concat(pn.middle_name, ' ')), 
IF(pn.family_name IS NULL OR pn.family_name = '', '', pn.family_name)) AS "Name in full", IFNULL(pai.identifier, '') AS "patient ID", IFNULL(pMobile.telephoneNo, '') AS "Telephone No.", IFNULL(p.gender, '') AS "Gender",
TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) AS "Age", IFNULL(DATE_FORMAT(v.date_started, "%d/%m/%Y"), '') AS "Appointment Date", IFNULL(HEIGHT, '') HEIGHT, IFNULL(WEIGHT, '') WEIGHT, IFNULL(BMI, '') BMI, IFNULL(CD4, '') CD4,
IFNULL((select name from concept_name where concept_name_type="FULLY_SPECIFIED" and concept_id = WHOS), '') WHOS, IFNULL(CTX, '') CTX, IFNULL(date_startedTBRX, '') "Date Started TB RX",
IFNULL(Breastfeeding, '') "Breast feeding", IFNULL((select name from concept_name where concept_name_type="FULLY_SPECIFIED" and concept_id = SR1stLA ), '') "Substitution Regimen (1st  Line Adults)", 
IFNULL((select name from concept_name where concept_name_type="FULLY_SPECIFIED" and concept_id = RFRC), '') "Reason For Regimen Change",
IFNULL((select name from concept_name where concept_name_type="FULLY_SPECIFIED" and concept_id = ARSW1L), '') "ART Regimen - Substitution within 1st Line",
IFNULL((select name from concept_name where concept_name_type="FULLY_SPECIFIED" and concept_id = SR2LA), '') "Substitution Regimen (2nd Line Adults)", 
IFNULL((select name from concept_name where concept_name_type="FULLY_SPECIFIED" and concept_id = C1LR), '') "Child 1st Line Regimens", 
IFNULL((select name from concept_name where concept_name_type="FULLY_SPECIFIED" and concept_id = C2LR), '') "Child 2nd Line Regimens"
FROM visit v 
LEFT JOIN person p ON p.person_id = v.patient_id AND v.voided IS FALSE 
LEFT JOIN person_name pn ON p.person_id = pn.person_id AND pn.voided IS FALSE
LEFT JOIN patient_identifier pai ON (pai.patient_id = v.patient_id AND pai.preferred = 1)
LEFT JOIN encounter e ON e.visit_id = v.visit_id 
LEFT JOIN (select paMobile.person_id as 'pMobilePersonId', paMobile.value AS 'telephoneNo'  from person_attribute paMobile
JOIN person_attribute_type patMobile ON patMobile.name = "MobileNumber" AND patMobile.retired IS FALSE AND patMobile.person_attribute_type_id = paMobile.person_attribute_type_id) AS pMobile ON v.patient_id = pMobile.pMobilePersonId
LEFT JOIN (select paUART.person_id as 'pUARTPersonId', paUART.value AS 'UniqueArtNo'  from person_attribute paUART 
JOIN person_attribute_type patUART ON patUART.name = "UniqueArtNo" AND patUART.retired IS FALSE AND patUART.person_attribute_type_id = paUART.person_attribute_type_id) AS pUART ON v.patient_id = pUART.pUARTPersonId 
LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'artStartDate' FROM obs o 
JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="ANC, ART Start Date" and o.concept_id = cn.concept_id) 
JOIN encounter enc ON enc.encounter_id = o.encounter_id 
JOIN visit v ON v.visit_id = enc.visit_id  
GROUP BY v.patient_id 
ORDER BY v.visit_id DESC) AS obsConcept ON obsConcept.visitPatientId = v.patient_id 
LEFT JOIN (
	SELECT obs.person_id, obs.encounter_id,
	REPLACE(Group_concat(IF (obs.concept_id = 3731, obs.value_coded, "")), ",", "") AS retestBeforeArt,
	REPLACE(Group_concat(IF (obs.concept_id = 3767, obs.value_coded, "")), ",", "") AS WHOS,
    REPLACE(Group_concat(IF (obs.concept_id = 118, obs.value_numeric, "")), ",", "") AS HEIGHT, 
    REPLACE(Group_concat(IF (obs.concept_id = 119, obs.value_numeric, "")), ",", "") AS WEIGHT,
    REPLACE(Group_concat(IF (obs.concept_id = 120, obs.value_numeric, "")), ",", "") AS BMI,
    REPLACE(Group_concat(IF (obs.concept_id = 1187, obs.value_numeric, "")), ",", "") AS CD4,
    REPLACE(Group_concat(IF (obs.concept_id = 3764, obs.value_datetime, "")), ",", "") AS CTX, 
    REPLACE(Group_concat(IF (obs.concept_id = 3782, obs.value_datetime, "")), ",", "") AS date_startedTBRX,
    REPLACE(Group_concat(IF (obs.concept_id = 2041, obs.value_numeric, "")), ",", "") AS Breastfeeding,
    REPLACE(Group_concat(IF (obs.concept_id = 3652, obs.value_coded, "")), ",", "") AS SR1stLA,
    REPLACE(Group_concat(IF (obs.concept_id = 3654, obs.value_coded, "")), ",", "") AS RFRC,
    REPLACE(Group_concat(IF (obs.concept_id = 3679, obs.value_coded, "")), ",", "") AS ARSW1L,
    REPLACE(Group_concat(IF (obs.concept_id = 3663, obs.value_coded, "")), ",", "") AS SR2LA,
    REPLACE(Group_concat(IF (obs.concept_id = 3664, obs.value_coded, "")), ",", "") AS ARS2L,
    REPLACE(Group_concat(IF (obs.concept_id = 3958, obs.value_coded, "")), ",", "") AS C1LR,
    REPLACE(Group_concat(IF (obs.concept_id = 3968, obs.value_coded, "")), ",", "") AS C2LR
    FROM obs 
    WHERE obs.concept_id IN ( 3731, 3767, 118, 119, 120,1187, 3767, 3764, 3782, 2041, 3652, 3654, 3679, 3663, 3664, 3958, 3968) and obs.voided=0
    GROUP BY person_id, encounter_id
) AS nutvalues ON e.encounter_id = nutvalues.encounter_id; 
-- WHERE pa.start_date_time BETWEEN '#startDate#' AND '#endDate#' ORDER BY pa.start_date_time DESC;
