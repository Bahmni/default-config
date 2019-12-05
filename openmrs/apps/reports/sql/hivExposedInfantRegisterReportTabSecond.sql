-- HIV Exposed Infant Register Report page 2

SELECT CONCAT(pn.given_name, ' ', IFNULL(pn.family_name, ''), '\n', IFNULL(pn.middle_name,'')) AS 'Infants Name',
  CONCAT(DATE_FORMAT(v1.secondPcrTestDate, '%d-%m-%Y'),'\n',TIMESTAMPDIFF(MONTH,p.birthdate,v1.secondPcrTestDate),'\n',v2.secondPcrTestResults) 
	AS 'Date of Test\nAge\n(Months)\nRapid Test Result\n(Pos/Neg)', 
  CONCAT(DATE_FORMAT(v1.secondPcrTestDate, '%d-%m-%Y'),'\n',DATE_FORMAT(v3.repeatPcrTestDate, '%d-%m-%Y')) AS 'Initial\n-------\nRepeat', 
  DATE_FORMAT(v1.secondPcrTestDate, '%d-%m-%Y') AS 'Date DBS\nwas collected', 
  '' AS 'Reason for\n2nd PCR\n(see the code\nbelow:\n1, 2, 3)', 
  '' AS 'Age at\n2nd DBS\n(Months)', 
  v4.infantFeedingStatus AS 'Infant\nFeeding\nStatus', 
  v2.secondPcrTestResults AS 'Test Result', 
  DATE_FORMAT(v2.secondPcrTestResultsDate, '%d-%m-%Y') AS 'Date Result\nReceived', 
  DATE_FORMAT(v5.secondPcrResultDateCaregiver, '%d-%m-%Y') AS 'Date Result\ngiven to\nCaretaker', 
  CONCAT('Appointment Date:','\n','Date of Visit:','\n','Age (mo):','\n','Feeding Code:','\n','Immunization Codes:','\n','CTX/ARV Prophylaxis (Y/N):') AS 'Visit Details', 
  CONCAT(DATE_FORMAT(v6.firstVisitAppointmentDate, '%d-%m-%Y'),'\n',DATE_FORMAT(v6.visitDate1, '%d-%m-%Y'),'\n',TIMESTAMPDIFF(MONTH, p.birthdate, CURDATE()),'\n','','\n','','\n',IF(v13.arvProphylaxisStartDate IS null OR v13.arvProphylaxisStartDate = '','No','Yes')) AS 'Visit 1', 
  CONCAT(DATE_FORMAT(v10.secondVisitAppointmentDate, '%d-%m-%Y'),'\n',DATE_FORMAT(v10.visitDate2, '%d-%m-%Y'),'\n',TIMESTAMPDIFF(MONTH, p.birthdate, CURDATE()),'\n','','\n','','\n',IF(v13.arvProphylaxisStartDate IS NULL OR v13.arvProphylaxisStartDate = '','No','Yes')) AS 'Visit 2', 
  CONCAT(DATE_FORMAT(v11.thirdVisitAppointmentDate, '%d-%m-%Y'),'\n',DATE_FORMAT(v11.visitDate3, '%d-%m-%Y'),'\n',TIMESTAMPDIFF(MONTH, p.birthdate, CURDATE()),'\n','','\n','','\n',IF(v13.arvProphylaxisStartDate IS NULL OR v13.arvProphylaxisStartDate = '','No','Yes')) AS 'Visit 3',  
  CONCAT(DATE_FORMAT(v12.fourthVisitAppointmentDate, '%d-%m-%Y'),'\n',DATE_FORMAT(v12.visitDate4, '%d-%m-%Y'),'\n',TIMESTAMPDIFF(MONTH, p.birthdate, CURDATE()),'\n','','\n','','\n',IF(v13.arvProphylaxisStartDate IS NULL OR v13.arvProphylaxisStartDate = '','No','Yes')) AS 'Visit 4', 
  '' AS 'Visit 5', '' AS 'Visit 6', '' AS 'Visit 7', '' AS 'Visit 8', '' AS 'Visit 9', '' AS 'Visit 10',
  CONCAT(DATE_FORMAT(v7.months18RapidTestDate, '%d-%m-%Y'),'\n',TIMESTAMPDIFF(MONTH, p.birthdate, CURDATE()),'\n',v8.months18RapidTestResults) AS 'Date of Test\nAge\n(months)\nRapid Test Result\n(Pos=Positive,\nNeg=Negative)',
  v9.finalStatus AS 'Final Outcome' 
FROM 
  patient pt 
  LEFT JOIN person p ON p.person_id = pt.patient_id AND pt.voided is FALSE AND p.voided is FALSE 
  LEFT JOIN person_name pn ON p.person_id = pn.person_id AND pn.voided IS FALSE
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'secondPcrTestDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (Second PCR Test Date)'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v1 ON v1.visitPatientId = p.person_id
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
	  o.obs_datetime AS 'secondPcrTestResultsDate',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'secondPcrTestResults'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (Second PCR Results)'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v2 ON v2.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'repeatPcrTestDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (Repeat PCR Test Date)'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v3 ON v3.visitPatientId = p.person_id
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'infantFeedingStatus'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Infant Feeding'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v4 ON v4.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'secondPcrResultDateCaregiver'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (Second PCR Date Result Given to Caregiver)'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v5 ON v5.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
	  enc.encounter_datetime AS 'visitDate1',
      o.value_datetime AS 'firstVisitAppointmentDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Hei End Of Follow up (First Attempt Date)'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v6 ON v6.visitPatientId = p.person_id
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'months18RapidTestDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (18Months Rapid Test Date)'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v7 ON v7.visitPatientId = p.person_id
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'months18RapidTestResults'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (18Months Rapid Test Results)'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v8 ON v8.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'finalStatus'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Final Status'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v9 ON v9.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
	  enc.encounter_datetime AS 'visitDate2',
      o.value_datetime AS 'secondVisitAppointmentDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Hei End Of Follow up (Second Attempt Date)'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v10 ON v10.visitPatientId = p.person_id
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
	  enc.encounter_datetime AS 'visitDate3',
      o.value_datetime AS 'thirdVisitAppointmentDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Hei End Of Follow up (Third Attempt Date)'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v11 ON v11.visitPatientId = p.person_id
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
	  enc.encounter_datetime AS 'visitDate4',
      o.value_datetime AS 'fourthVisitAppointmentDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Hei End Of Follow up (Fourth Attempt Date)'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v12 ON v12.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'arvProphylaxisStartDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Date of ARV Prophylaxis Start'
        AND o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v13 ON v13.visitPatientId = p.person_id 
group by CAST('Serial No.' AS UNSIGNED);
