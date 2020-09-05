SELECT 
    *
FROM
    (SELECT 
        a.name AS `Service Areas`,
            'Total cases seen(24hr)' AS `Data elements`,
            IFNULL(SUM(if(a.date_started BETWEEN date_format('#startDate#', "%Y-%m-%d 00:00:00") AND date_format('#endDate#', "%Y-%m-%d 12:00:00"), 1, 0)),0) AS `Report 6AM`, 
			IFNULL(SUM(if(a.date_started BETWEEN date_format('#startDate#', "%Y-%m-%d 12:00:01") AND date_format('#endDate#', "%Y-%m-%d 23:59:59"), 1, 0)),0) AS `Report 6PM`, 
           -- IFNULL(SUM(IF(a.date_started BETWEEN DATE_FORMAT('2020-08-04 00:09:26', '%Y-%m-%d 12:00:01') AND DATE_FORMAT('2020-09-04 00:09:26', '%Y-%m-%d 23:59:59'), 1, 0)), 0) AS `Report 6PM`,
            COUNT(a.location_id) AS Total,
            '' AS Remark
    FROM
        (SELECT 
        bpam.patient_id,
            bpam.date_started,
            bpam.date_stopped,
            bpam.bed_id,
            blm.location_id,
            l.name,
            l.parent_location
    FROM
        bed_patient_assignment_map bpam
    JOIN bed_location_map blm ON bpam.bed_id = blm.bed_id
    JOIN location l ON l.location_id = blm.location_id
        AND l.parent_location = (SELECT 
            location_id
        FROM
            location
        WHERE
            location.name = 'Emergency Ward')
    WHERE
       -- bpam.date_started BETWEEN DATE_FORMAT('2020-08-04 00:09:26', '%Y-%m-%d 00:00:00') AND DATE_FORMAT('2020-09-04 00:09:26', '%Y-%m-%d 23:59:59')) AS a
    bpam.date_started BETWEEN date_format('#startDate#', "%Y-%m-%d 00:00:00") AND date_format('#endDate#', "%Y-%m-%d 23:59:59")) AS a
    GROUP BY a.location_id UNION SELECT 
        a.name AS `Service Areas`,
            'Total Number of kept cases' AS `Data elements`,
            '-' AS `Report 6AM`, 
    '-' AS `Report 6PM`, 
            COUNT(a.location_id) AS Total,
            '' AS Remark
    FROM
        (SELECT 
        bpam.patient_id,
            bpam.date_started,
            bpam.date_stopped,
            bpam.bed_id,
            blm.location_id,
            l.name,
            l.parent_location
    FROM
        bed_patient_assignment_map bpam
    JOIN bed_location_map blm ON bpam.bed_id = blm.bed_id
    JOIN location l ON l.location_id = blm.location_id
        AND l.parent_location = (SELECT 
            location_id
        FROM
            location
        WHERE
            location.name = 'Emergency Ward')
    WHERE
        bpam.date_started < DATE_FORMAT('#startDate#', '%Y-%m-%d 00:00:00')
            AND (bpam.date_stopped BETWEEN DATE_FORMAT('#startDate#', '%Y-%m-%d 23:59:59') 
            AND DATE_FORMAT('#endDate#', '%Y-%m-%d 23:59:59')
            OR bpam.date_stopped > DATE_FORMAT('#endDate#', '%Y-%m-%d 23:59:59'))) AS a
    GROUP BY a.location_id UNION SELECT 
        a.name AS `Service Areas`,
            'Number of cases with > 24hr stay' AS `Data elements`,
            '-' AS `Report 6AM`,
            '-' AS `Report 6PM`,
            COUNT(a.location_id) AS Total,
            '' AS Remark
    FROM
        (SELECT 
        bpam.patient_id,
            bpam.date_started,
            bpam.date_stopped,
            bpam.bed_id,
            blm.location_id,
            l.name,
            l.parent_location
    FROM
        bed_patient_assignment_map bpam
    JOIN bed_location_map blm ON bpam.bed_id = blm.bed_id
    JOIN location l ON l.location_id = blm.location_id
        AND l.parent_location = (SELECT 
            location_id
        FROM
            location
        WHERE
            location.name = 'Emergency Ward')
    WHERE
        bpam.date_started BETWEEN DATE_FORMAT('#startDate#', '%Y-%m-%d 00:00:00') 
        AND DATE_FORMAT('#endDate#', '%Y-%m-%d 23:59:59')
            AND bpam.date_stopped > DATE_FORMAT('#endDate#', '%Y-%m-%d 23:59:59')) AS a
    GROUP BY a.location_id) AS b
ORDER BY b.`Service Areas`