SELECT 
    'Total Patients Admitted' AS Reports, COUNT(*) AS Count
FROM
    person
        JOIN
    visit ON visit.patient_id = person.person_id
        AND CAST(visit.date_stopped AS DATE) BETWEEN '#startDate#' AND '#endDate#'
        JOIN
    visit_attribute AS va ON va.visit_id = visit.visit_id
        AND va.value_reference = 'IPD'
        LEFT JOIN
    visit_attribute_type vat ON vat.visit_attribute_type_id = va.attribute_type_id
        AND vat.name = 'Visit Status' 
UNION SELECT 
    'Number of beds' AS Reports, COUNT(*) AS Count
FROM
    bed_location_map 
UNION SELECT 
'Number of beds sanction ' AS Reports,property_value AS Count
FROM global_property WHERE property='hospital.assigned.bed'
 


