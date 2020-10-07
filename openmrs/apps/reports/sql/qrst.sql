select 'Lision (24)' as ServiceArea, 'number of admission to' as Data1, location.name as Element, room.AM6Total as Report6AM,room.AM6Total as Report6PM,room.total as ReportTotal, '' as Remark
from (select l.parent_location,
IFNULL(SUM(CASE WHEN bpa.date_stopped is null && bpa.date_started BETWEEN date_format('#startDate#', "%Y-%m-%d 00:00:00") AND date_format('#endDate#', "%Y-%m-%d 12:00:00") THEN 1 ELSE 0 END),0) as AM6Total,
IFNULL(SUM(CASE WHEN bpa.date_stopped is null && bpa.date_started BETWEEN date_format('#startDate#', "%Y-%m-%d 00:00:00") AND date_format('#endDate#', "%Y-%m-%d 12:00:00") THEN 1 ELSE 0 END),0) as PM6Total,
IFNULL(SUM(CASE WHEN bpa.date_stopped is null && CAST(bpa.date_started AS DATE) BETWEEN '#startDate#' AND '#endDate#' THEN 1 ELSE 0 END),0) as total
from bed_patient_assignment_map as bpa
join bed_location_map as blm on blm.bed_id=bpa.bed_id
join location as l on l.location_id=blm.location_id
group by l.parent_location) as room 
Join location on room.parent_location = location.location_id;