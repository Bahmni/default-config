SELECT  @a:=@a+1 Serial,
(DATE_FORMAT(v.date_started, "%d/%m/%Y")) as "Date of visit",
IFNULL(pa.value ,' ') as "Mother Name",
IFNULL(pa1.value ,' ') as "Mothers Number",
CONCAT (TIMESTAMPDIFF(Year, p.birthdate, CURDATE()) , 'Y ' ,TIMESTAMPDIFF(Month, p.birthdate, CURDATE()) , 'M') AS "Age",
CONCAT(IF(paddr.country IS NULL OR paddr.country = '', '',CONCAT(paddr.country, ', ')), 
IF(paddr.address4 IS NULL OR paddr.address4 = '', '', CONCAT(paddr.address4, ', ')), 
	IF(paddr.address3 IS NULL OR paddr.address3 = '', '', CONCAT(paddr.address3, ', ')), 
	IF(paddr.address2 IS NULL OR paddr.address2 = '', '', CONCAT(paddr.address2, ', ')), 
	IF(paddr.address1 IS NULL OR paddr.address1 = '', '', CONCAT(paddr.address1, ', ')), 
	IF(paddr.address5 IS NULL OR paddr.address5 = '', '', CONCAT(paddr.address5, ', ')), 
	IF(paddr.address6 IS NULL OR paddr.address6 = '', '', CONCAT(paddr.address6, ', ')), 
	IF(paddr.city_village IS NULL OR paddr.city_village = '', '', paddr.city_village)) AS 'Name of village or Address',
IFNULL(pa2.value ,' ') as "Next of Kin and Phone Number",
pai.identifier as "ART NO.",
IFNULL(motherArt,' ') as "ART  Regimen During Pregnancy",
IFNULL(durationArt ,' ') as "Duration on ART During Pregnancy",
IFNULL(infantArvs ,' ') as "Infant ARV Prophylaxis and Date   1=NVP  2=AZT+NVP",
CONCAT((IFNULL(nvpDate,' ')),'/',(IFNULL(AZTDate,' '))) as "NVP/AZT Date given",
IFNULL(infantFeed ,' ') as "Infant Feeding practice 1=EBF 2= RF 3=MF",
IFNULL(pa3.value ,' ') as "Exposed Infant Number",
'' as "Comments",
'' as "Provider initials"
From person p
JOIN (SELECT @a:= 0) a
JOIN person_name pn on pn.person_id= p.person_id
LEFT JOIN visit v on v.patient_id=p.person_id
LEFT JOIN patient_identifier pai ON (pai.patient_id = v.patient_id AND pai.preferred = 1)
JOIN person_attribute par on par.person_id = p.person_id and par.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
JOIN person_attribute_type patr on (patr.person_attribute_type_id = par.person_attribute_type_id and patr.retired = 0 and patr.name = "TypeofPatient")
LEFT JOIN person_address paddr ON (p.person_id = paddr.person_id AND paddr.voided = 0 )
Left JOIN person_attribute pa on p.person_id=pa.person_id
JOIN person_attribute_type pat on pat.person_attribute_type_id = pa.person_attribute_type_id And pat.name = "HeiChildMothersName"
Left JOIN person_attribute pa1 on p.person_id=pa1.person_id
JOIN person_attribute_type pat1 on pat1.person_attribute_type_id = pa1.person_attribute_type_id And pat1.name = "MothersContactNumber"
Left JOIN person_attribute pa2 on p.person_id=pa2.person_id
JOIN person_attribute_type pat2 on pat1.person_attribute_type_id = pa2.person_attribute_type_id And pat2.name = "TreatmentSupporterTelephoneNumber"
Left JOIN person_attribute pa3 on p.person_id=pa3.person_id
JOIN person_attribute_type pat3 on pat3.person_attribute_type_id = pa3.person_attribute_type_id And pat3.name = "HIVExposedInfant(HEI)No"
LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'motherArt' FROM obs o
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Mother's ART Regimen" 
  and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = p.person_id)
LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'durationArt' FROM obs o
  JOIN concept_name cn1 ON (cn1.concept_name_type = "FULLY_SPECIFIED" AND cn1.voided is false AND cn1.name="Duration on ART?" 
  and o.concept_id = cn1.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr1 ON (vr1.visitPatientId = p.person_id)
LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'infantArvs' FROM obs o
  JOIN concept_name cn2 ON (cn2.concept_name_type = "FULLY_SPECIFIED" AND cn2.voided is false AND cn2.name="Infant's PMTCT ARVS" 
  and o.concept_id = cn2.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr2 ON (vr2.visitPatientId = p.person_id)
LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', (select name from concept_name where concept_id = o.value_coded and concept_name_type = "FULLY_SPECIFIED")  AS 'infantFeed' FROM obs o
  JOIN concept_name cn3 ON (cn3.concept_name_type = "FULLY_SPECIFIED" AND cn3.voided is false AND cn3.name="Infant Feeding" 
  and o.concept_id = cn3.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr3 ON (vr3.visitPatientId = p.person_id)
LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'nvpDate' FROM obs o
  JOIN concept_name cn4 ON (cn4.concept_name_type = "FULLY_SPECIFIED" AND cn4.voided is false AND cn4.name="Daily NVP Date" 
  and o.concept_id = cn4.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr4 ON (vr4.visitPatientId = p.person_id)
LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'AZTDate' FROM obs o
  JOIN concept_name cn5 ON (cn5.concept_name_type = "FULLY_SPECIFIED" AND cn5.voided is false AND cn5.name="AZT+NV Date" 
  and o.concept_id = cn5.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr5 ON (vr5.visitPatientId = p.person_id)