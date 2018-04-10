
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
FROM
    person
        JOIN
    patient_identifier ON person.person_id = patient_identifier.patient_id
        AND patient_identifier.preferred = 1
        AND person.voided = 0
        JOIN
    visit ON visit.patient_id = person.person_id
        AND CAST(visit.date_stopped AS DATE) BETWEEN '#startDate#' AND '#endDate#'
        AND visit.voided = 0
        JOIN
    visit_attribute AS va ON va.visit_id = visit.visit_id
        AND va.value_reference = 'IPD'
        LEFT JOIN
    visit_attribute_type vat ON vat.visit_attribute_type_id = va.attribute_type_id
        AND vat.name = 'Visit Status';

