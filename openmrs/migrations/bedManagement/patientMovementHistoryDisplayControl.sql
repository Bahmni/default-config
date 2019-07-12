DELETE FROM global_property WHERE property = 'bahmni.sqlGet.ipdPatientMovementHistory';
SELECT uuid() INTO @uuid;

INSERT INTO global_property (property, property_value, description, uuid)
 VALUES ('bahmni.sqlGet.ipdPatientMovementHistory',
"SELECT
    `Lit`,
    Lieu,
    Action,
    DATE_FORMAT(bpamStartDate, '%d %b %Y %h:%i %p')         AS `Attribué le`,
    DATE_FORMAT(dischargeDate, '%d %b %Y %h:%i %p')         AS `Sorti le`,
    `Etiquettes`
FROM
    (
        (SELECT
             b.bed_number                                        AS `Lit`,
             l.name                                              AS Lieu,
             IF(et.name = 'TRANSFER', 'MOVEMENT', et.name)       AS `Action`,
             bpam.date_started                                   AS bpamStartDate,
             bpam.date_stopped                                   AS dischargeDate,
             bedTagsInfo.bedTag                                  AS `Etiquettes`
         FROM person p
             INNER JOIN visit v
                 ON p.person_id = v.patient_id AND v.voided IS FALSE AND p.voided IS FALSE AND
                    p.uuid = ${patientUuid}
                    AND v.uuid = ${visitUuid}
             INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided IS FALSE
             INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id AND et.retired IS FALSE
             INNER JOIN bed_patient_assignment_map bpam ON bpam.encounter_id = e.encounter_id AND bpam.voided IS FALSE
             INNER JOIN bed_location_map blm ON blm.bed_id = bpam.bed_id
             INNER JOIN location l ON blm.location_id = l.location_id AND l.retired IS FALSE
             INNER JOIN bed b ON bpam.bed_id = b.bed_id AND b.voided IS FALSE
             LEFT OUTER JOIN (
                                 SELECT
                                     btm.bed_id,
                                     bpam.bed_patient_assignment_map_id,
                                     bpam.date_started,
                                     bpam.date_stopped,
                                     GROUP_CONCAT(CONCAT(bt.name, '(',
                                                         concat_ws(' - ',
                                                                   DATE_FORMAT(
                                                                       GREATEST(btm.date_created, bpam.date_started),
                                                                       '%d %b %Y %h:%i %p'),
                                                                   IF(btm.date_voided IS NULL AND
                                                                      bpam.date_stopped IS NULL,
                                                                      NULL,
                                                                      DATE_FORMAT(LEAST(IFNULL(btm.date_voided, now()),
                                                                                        IFNULL(bpam.date_stopped,
                                                                                               now())),
                                                                                  '%d %b %Y %h:%i %p'))), ')') ORDER BY
                                                  GREATEST(btm.date_created, bpam.date_started) SEPARATOR
                                                  '<br>') AS bedTag
                                 FROM bed_tag_map btm
                                     INNER JOIN bed_tag bt ON btm.bed_tag_id = bt.bed_tag_id AND bt.voided IS FALSE
                                     INNER JOIN bed_patient_assignment_map bpam
                                         ON bpam.bed_id = btm.bed_id AND bpam.voided IS FALSE
                                     INNER JOIN person p
                                         ON p.person_id = bpam.patient_id AND p.voided IS FALSE AND
                                            p.uuid = ${patientUuid}
                                            AND NOT
                                            (
                                                btm.date_voided IS NOT NULL && btm.date_voided < bpam.date_started
                                                OR
                                                bpam.date_stopped IS NOT NULL && btm.date_created > bpam.date_stopped
                                            )
                                 GROUP BY btm.bed_id, bpam.date_started
                             ) bedTagsInfo ON bpam.bed_id = bedTagsInfo.bed_id AND
                                              bpam.bed_patient_assignment_map_id =
                                              bedTagsInfo.bed_patient_assignment_map_id
         ORDER BY bpam.date_started
        )
        UNION
        (SELECT
             latestBpam.bed_number                          AS `Bed Number`,
             latestBpam.location                            AS Lieu,
             et.name                                        AS `Action`,
             NULL                                           AS bpamStartDate,
             e.encounter_datetime                           AS dischargeDate,
             bedTag                                         AS `Etiquettes`
         FROM person p
             INNER JOIN encounter e ON e.patient_id = p.person_id
                                       AND p.voided IS FALSE
                                       AND e.voided IS FALSE
                                       AND p.uuid = ${patientUuid}
             INNER JOIN visit v ON v.visit_id = e.visit_id
                                   AND v.voided IS FALSE
                                   AND v.uuid = ${visitUuid}
             INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id
                                             AND et.retired IS FALSE
                                             AND et.name = 'DISCHARGE'
             INNER JOIN (SELECT
                             bpam.patient_id,
                             b.bed_number,
                             l.name AS location,
                             bpam.date_stopped,
                             bedTagsInfo.bedTag
                         FROM bed_patient_assignment_map bpam
                             INNER JOIN (SELECT
                                             p.person_id,
                                             MAX(bpam.date_stopped) AS latestMovementDateTime
                                         FROM person p
                                             INNER JOIN bed_patient_assignment_map bpam ON bpam.patient_id = p.person_id
                                                                                           AND p.voided IS FALSE
                                                                                           AND bpam.voided IS FALSE
                                                                                           AND p.uuid = ${patientUuid}
                                             INNER JOIN encounter e ON e.encounter_id = bpam.encounter_id
                                                                       AND e.voided IS FALSE
                                             INNER JOIN visit v ON v.visit_id = e.visit_id
                                                                   AND v.voided IS FALSE
                                                                   AND v.uuid = ${visitUuid}) latestBpamInfo
                                 ON bpam.patient_id = latestBpamInfo.person_id
                                    AND bpam.date_stopped = latestBpamInfo.latestMovementDateTime
                             INNER JOIN bed_location_map blm ON blm.bed_id = bpam.bed_id
                             INNER JOIN location l ON blm.location_id = l.location_id AND l.retired IS FALSE
                             INNER JOIN bed b ON bpam.bed_id = b.bed_id AND b.voided IS FALSE
                             LEFT OUTER JOIN (
                                                 SELECT
                                                     btm.bed_id,
                                                     bpam.bed_patient_assignment_map_id,
                                                     bpam.date_started,
                                                     bpam.date_stopped,
                                                     GROUP_CONCAT(CONCAT(bt.name, '(',
                                                                         concat_ws(' - ',
                                                                                   DATE_FORMAT(
                                                                                       GREATEST(btm.date_created, bpam.date_started),
                                                                                       '%d %b %Y %h:%i %p'),
                                                                                   IF(btm.date_voided IS NULL AND
                                                                                      bpam.date_stopped IS NULL,
                                                                                      NULL,
                                                                                      DATE_FORMAT(LEAST(IFNULL(btm.date_voided, now()),
                                                                                                        IFNULL(bpam.date_stopped,
                                                                                                               now())),
                                                                                                  '%d %b %Y %h:%i %p'))), ')') ORDER BY
                                                                  GREATEST(btm.date_created, bpam.date_started) SEPARATOR
                                                                  '<br>') AS bedTag
                                                 FROM bed_tag_map btm
                                                     INNER JOIN bed_tag bt ON btm.bed_tag_id = bt.bed_tag_id AND bt.voided IS FALSE
                                                     INNER JOIN bed_patient_assignment_map bpam
                                                         ON bpam.bed_id = btm.bed_id AND bpam.voided IS FALSE
                                                     INNER JOIN person p
                                                         ON p.person_id = bpam.patient_id AND p.voided IS FALSE AND
                                                            p.uuid = ${patientUuid}
                                                            AND NOT
                                                            (
                                                                btm.date_voided IS NOT NULL && btm.date_voided < bpam.date_started
                                                                OR
                                                                bpam.date_stopped IS NOT NULL && btm.date_created > bpam.date_stopped
                                                            )
                                                 GROUP BY btm.bed_id, bpam.date_started
                                             ) bedTagsInfo ON bpam.bed_id = bedTagsInfo.bed_id AND
                                                              bpam.bed_patient_assignment_map_id =
                                                              bedTagsInfo.bed_patient_assignment_map_id
                        ) latestBpam
                 ON latestBpam.patient_id = p.person_id
        )) patientMovementHistory
ORDER BY
    CASE
    WHEN patientMovementHistory.dischargeDate IS NULL
        THEN 0
    ELSE 1
    END DESC, patientMovementHistory.dischargeDate"
, 'patient movement history in bed management', @uuid);
