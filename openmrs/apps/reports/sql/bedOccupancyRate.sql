SELECT 
    location.name AS Reports, COUNT(bed_patient_assignment_map.bed_id) AS Bed_occupancy
FROM
    bed_location_map
JOIN location on location.location_id = bed_location_map.location_id
JOIN bed_patient_assignment_map on bed_patient_assignment_map.bed_id=bed_location_map.bed_id
AND ((CAST(bed_patient_assignment_map.date_started AS DATE) <= '#startDate#'
        AND (CAST(bed_patient_assignment_map.date_stopped AS DATE) IS Null)) 
    OR (CAST(bed_patient_assignment_map.date_stopped AS DATE) = '#startDate#' OR 
        CAST(bed_patient_assignment_map.date_stopped AS DATE) = '#endDate#')
    OR ((CAST(bed_patient_assignment_map.date_started AS DATE) <= '#startDate#') AND
        (CAST(bed_patient_assignment_map.date_stopped AS DATE) >= '#endDate#')))
Group by bed_location_map.location_id;