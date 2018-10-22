SELECT 
    'Total Patients Admitted' AS Reports,
    COUNT(*) AS Count
FROM
    person
        JOIN
    visit ON visit.patient_id = person.person_id
           and cast(visit.date_stopped as date) between '#startDate#' and '#endDate#'
        JOIN
    visit_attribute AS va ON va.visit_id = visit.visit_id
        AND va.value_reference = 'IPD'
        LEFT JOIN
    visit_attribute_type vat ON vat.visit_attribute_type_id = va.attribute_type_id
        AND vat.name = 'Visit Status' 
UNION 
SELECT 
    'Number of beds' AS Reports, 
    COUNT(*) AS Count
FROM
    bed_location_map