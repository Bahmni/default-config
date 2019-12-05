-- HIV Exposed Infant Register Report page 1

SELECT (@row_number1 := @row_number1 + 1) AS 'Serial No.',
  DATE_FORMAT(v1.date_enrolled,'%d-%m-%Y') AS 'Date Of Enrollment', p1.hei_no AS 'Exposed Infant Number',
  CONCAT(pn.given_name, ' ', IFNULL(pn.family_name, ''), '\n', IFNULL(pn.middle_name,'')) AS 'Infant\'s Name',
  CONCAT(IF(paddr.country IS NULL OR paddr.country = '', '',CONCAT(paddr.country, ' ')), 
	IF(paddr.address4 IS NULL OR paddr.address4 = '', '', CONCAT(paddr.address4, ' ')), 
	IF(paddr.address3 IS NULL OR paddr.address3 = '', '', CONCAT(paddr.address3, ' ')), 
	IF(paddr.address2 IS NULL OR paddr.address2 = '', '', CONCAT(paddr.address2, ' ')), 
	IF(paddr.address1 IS NULL OR paddr.address1 = '', '', CONCAT(paddr.address1, ' ')), 
	IF(paddr.address5 IS NULL OR paddr.address5 = '', '', CONCAT(paddr.address5, ' ')), 
	IF(paddr.address6 IS NULL OR paddr.address6 = '', '', CONCAT(paddr.address6, ' ')), 
	IF(paddr.city_village IS NULL OR paddr.city_village = '', '', paddr.city_village)) AS 'Physical Address', 
  CONCAT(DATE_FORMAT(p.birthdate, '%d-%m-%Y'),'\n',TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE())) AS 'Date of Birth\n Age',
  p.gender AS 'Sex\n(M/F)',
  v3.entryPointEnrollment AS 'Clinic\nReferred\nFrom', 
  TIMESTAMPDIFF(MONTH, p.birthdate, CURDATE()) - TIMESTAMPDIFF(MONTH, v4.ageAtArv, CURDATE()) AS 'Age at ARV\nProphylaxis\nInitiation\n(Months)', 
  TIMESTAMPDIFF(MONTH, p.birthdate, CURDATE()) - TIMESTAMPDIFF(MONTH, v5.ageAtCtx, CURDATE()) AS 'Age at\nCotrimaxazole\nInitiation\n(Months)', 
  CONCAT(p2.caregiverName,'\n\n',p3.caregiverContact) AS 'Mother/Caregiver\'s Name\n\nTelephone Number', 
  p4.caregiverArtNo AS 'Mother\'s ART No.', 
  '' AS 'Antenatal', 
  '' AS 'Delivery', 
  '' AS 'Post natal', 
  '' AS 'Infant\'s Risk\nStatus\n(Low or High)', 
  v6.infantsArv AS 'Infant\'s ARVs\nfor PMTCT:\n(1=NVP;\n2=NVP+AZT;\n3=None)',
  CONCAT(DATE_FORMAT(v7.firstPcrTestDate, '%d-%m-%Y'),'\n',DATE_FORMAT(v8.repeatPcrTestDate, '%d-%m-%Y')) AS 'Initial\nSample\n-------\nRepeat', 
  DATE_FORMAT(v7.firstPcrTestDate, '%d-%m-%Y') AS 'Date DBS\nwas\ncollected', 
  TIMESTAMPDIFF(MONTH, p.birthdate, v7.firstPcrTestDate) AS 'Age at\n1st DBS\n(Weeks/\nMonth)',
  v9.infantFeeding AS 'Infant\nFeeding\nStatus', 
  v10.firstPcrTestResults AS 'Test\nResult', 
  DATE_FORMAT(v10.firstPcrTestResultsDate, '%d-%m-%Y') AS 'Date Result\nReceived', 
  DATE_FORMAT(v11.firstPcrResultDateCaregiver, '%d-%m-%Y') AS 'Date Result\ngiven to\nCaregiver' 
FROM
  patient pt 
  inner JOIN (SELECT @row_number1 := 0) AS r 
  LEFT JOIN person p ON p.person_id = pt.patient_id AND pt.voided is FALSE AND p.voided is FALSE
  LEFT JOIN patient_identifier pin ON pin.patient_id = pt.patient_id and pin.preferred = 1 
  LEFT JOIN person_name pn ON p.person_id = pn.person_id
  AND pn.voided IS FALSE
  LEFT JOIN person_address paddr ON p.person_id = paddr.person_id
  AND paddr.voided IS FALSE
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_coded AS 'enrol_atart'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Treatment - Enrolled AT ART Clinic'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v2 ON v2.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'date_enrolled'
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
  ) AS v1 ON v1.visitPatientId = p.person_id AND v2.enrol_atart = 1 
  LEFT JOIN (
    select
      distinct pa.person_id as 'paPersonId',
      pa.value AS 'hei_no'
    FROM
      person_attribute pa
      JOIN person_attribute_type pat ON pat.name = 'HIVExposedInfant(HEI)No'
      AND pat.retired IS FALSE
      AND pat.person_attribute_type_id = pa.person_attribute_type_id
  ) AS p1 ON p.person_id = p1.paPersonId 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'entryPointEnrollment'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Entry Point(Enrollement)'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v3 ON v3.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'ageAtArv'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Date of ARV Prophylaxis Start'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v4 ON v4.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'ageAtCtx'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'CTX or Dapose Start Date'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v5 ON v5.visitPatientId = p.person_id 
  LEFT JOIN (
    select
      distinct pa.person_id as 'paPersonId',
      pa.value AS 'caregiverName'
    FROM
      person_attribute pa
      JOIN person_attribute_type pat ON pat.name = 'HeiChildMothersName'
      AND pat.retired IS FALSE
      AND pat.person_attribute_type_id = pa.person_attribute_type_id
  ) AS p2 ON p.person_id = p2.paPersonId 
  LEFT JOIN (
    select
      distinct pa.person_id as 'paPersonId',
      pa.value AS 'caregiverContact'
    FROM
      person_attribute pa
      JOIN person_attribute_type pat ON pat.name = 'MothersContactNumber'
      AND pat.retired IS FALSE
      AND pat.person_attribute_type_id = pa.person_attribute_type_id
  ) AS p3 ON p.person_id = p3.paPersonId 
  LEFT JOIN (
    select
      distinct pa.person_id as 'paPersonId',
      pa.value AS 'caregiverArtNo'
    FROM
      person_attribute pa
      JOIN person_attribute_type pat ON pat.name = 'MothersArtNo'
      AND pat.retired IS FALSE
      AND pat.person_attribute_type_id = pa.person_attribute_type_id
  ) AS p4 ON p.person_id = p4.paPersonId 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'infantsArv'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'Infant\'s PMTCT ARVS'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v6 ON v6.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'firstPcrTestDate'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (First PCR Test Date)'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v7 ON v7.visitPatientId = p.person_id
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
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v8 ON v8.visitPatientId = p.person_id
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'infantFeeding'
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
  ) AS v9 ON v9.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
	  o.obs_datetime AS 'firstPcrTestResultsDate',
      (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED") AS 'firstPcrTestResults'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (First PCR Results)'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v10 ON v10.visitPatientId = p.person_id 
  LEFT JOIN (
    SELECT
      distinct v.patient_id AS 'visitPatientId',
      o.obs_datetime AS 'obs_datetime',
      o.value_datetime AS 'firstPcrResultDateCaregiver'
    FROM
      obs o
      JOIN concept_name cn ON (
        cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.voided is false
        AND cn.name = 'HEI Testing (First PCR Date Result Given to Caregiver)'
        and o.concept_id = cn.concept_id
      )
      JOIN encounter enc ON enc.encounter_id = o.encounter_id
      JOIN visit v ON v.visit_id = enc.visit_id
  ) AS v11 ON v11.visitPatientId = p.person_id 
order by CAST('Serial No.' AS UNSIGNED) asc; 
