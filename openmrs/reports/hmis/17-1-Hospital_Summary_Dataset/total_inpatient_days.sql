SELECT 
ifnull(SUM(CASE
        WHEN
            (TIMESTAMPDIFF(DAY,
                visit.date_started,
                visit.date_stopped)) = 0
        THEN
            1
        ELSE (TIMESTAMPDIFF(DAY,
            visit.date_started,
            visit.date_stopped))
    END),0) AS 'IPD Duration'
    FROM person
INNER JOIN patient_identifier ON person.person_id = patient_identifier.patient_id
  AND patient_identifier.preferred = 1
	AND person.voided = 0
      INNER  JOIN obs o1 ON o1.person_id = person.person_id
INNER JOIN visit on visit.patient_id = person.person_id
    AND cast(visit.date_started as date) BETWEEN '#startDate#' AND '#endDate#'
    AND cast(visit.date_stopped as date) BETWEEN '#startDate#' AND '#endDate#'
    AND visit.voided=0
 INNER JOIN visit_attribute AS va ON va.visit_id = visit.visit_id AND va.value_reference = 'IPD' 
 INNER JOIN visit_attribute_type vat ON vat.visit_attribute_type_id = va.attribute_type_id 
 	AND vat.name = 'Visit Status'
INNER JOIN
		 concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name NOT IN ('DRTuberculosis, Diagnosis Category')
        AND o1.voided = 0
        AND cn1.voided = 0
         INNER JOIN 
         concept_name cn2 ON o1.concept_id = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name ='Discharge Note, Admission Date'
 ORDER BY TIMESTAMPDIFF(DAY, visit.date_started, visit.date_stopped) DESC;