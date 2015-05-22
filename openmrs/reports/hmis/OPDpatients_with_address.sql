SELECT
  COALESCE(pn.given_name, pn.family_name),
  pi.identifier,
  person.birthdate,
  person.gender,
  pa.city_village,
  pa.county_district,
  va.value_reference AS visit_status
FROM visit
  INNER JOIN patient ON visit.patient_id = patient.patient_id AND
                        DATE(visit.date_stopped) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
                        AND patient.voided = 0 AND visit.voided = 0
  INNER JOIN person ON person.person_id = patient.patient_id AND person.voided = 0
  INNER JOIN person_name pn
    ON pn.person_id = person.person_id
  INNER JOIN person_address pa
    ON pa.person_id = person.person_id
  INNER JOIN patient_identifier pi
    ON pi.patient_id = person.person_id
  INNER JOIN visit_attribute va
    ON visit.visit_id = va.visit_id
	AND va.value_reference = 'OPD'
  LEFT JOIN visit_attribute_type vat ON vat.visit_attribute_type_id = va.attribute_type_id 
  	AND vat.name = 'VisitStatus';
