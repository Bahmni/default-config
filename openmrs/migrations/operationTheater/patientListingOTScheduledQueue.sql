DELETE FROM global_property WHERE property = 'emrapi.sqlSearch.otScheduledQueue';
SELECT uuid() INTO @uuid;

INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.otScheduledQueue',
"SELECT
  pi.identifier                              AS PATIENT_LISTING_QUEUES_HEADER_IDENTIFIER,
  CONCAT(pn.given_name, ' ', pn.family_name) AS PATIENT_LISTING_QUEUES_HEADER_NAME,
  bed_info.locationName                      AS `Current Department`,
  bed_info.bedNumber                         AS `Bed Number`,
  state_cn.name                              AS `Current Program State`,
  DATE_FORMAT(sb.start_datetime, '%d/%m/%Y') AS `Date of Surgery`,
  sa.status                                  AS `Status`,
  'Enter Disposition'                        AS disposition,
  'Change Program State'                     AS `Program State`,
  p.uuid                                     AS uuid,
  prog.uuid                                  AS programUuid,
  pp.uuid                                    AS enrollment
FROM surgical_block sb
  INNER JOIN surgical_appointment sa ON sb.surgical_block_id = sa.surgical_block_id
                                        AND sb.voided IS FALSE
                                        AND sa.voided IS FALSE
                                        AND sa.status = 'SCHEDULED'
  INNER JOIN person p ON p.person_id = sa.patient_id AND p.voided IS FALSE
  INNER JOIN person_name pn ON pn.person_id = sa.patient_id
                               AND pn.voided IS FALSE
  INNER JOIN patient_identifier pi ON pi.patient_id = pn.person_id AND pi.voided IS FALSE
  INNER JOIN patient_program pp ON pp.patient_id = sa.patient_id AND pp.voided IS FALSE AND pp.date_completed IS NULL
  INNER JOIN program prog ON prog.program_id = pp.program_id AND prog.retired IS FALSE
  JOIN concept_name prog_cn ON prog_cn.concept_id = prog.concept_id
                               AND prog_cn.name = 'Reconstructive surgery'
                               AND prog_cn.concept_name_type = 'FULLY_SPECIFIED'
                               AND prog_cn.voided IS FALSE
  INNER JOIN concept_name state_cn ON state_cn.concept_name_type = 'FULLY_SPECIFIED'
                                      AND state_cn.voided IS FALSE
  INNER JOIN program_workflow_state pws ON pws.concept_id = state_cn.concept_id AND pws.retired IS FALSE
  INNER JOIN patient_state ps ON
                                ps.patient_program_id = pp.patient_program_id AND
                                ps.state = pws.program_workflow_state_id AND
                                ps.end_date IS NULL AND ps.voided IS FALSE
  LEFT OUTER JOIN (
                    SELECT
                      l.name          AS locationName,
                      bpam.patient_id AS patient_id,
                      b.bed_number    AS bedNumber
                    FROM
                      bed_patient_assignment_map bpam
                      INNER JOIN bed b ON bpam.bed_id = b.bed_id AND b.voided IS FALSE
                                          AND bpam.voided IS FALSE
                                          AND bpam.date_stopped IS NULL
                      INNER JOIN bed_location_map blm ON blm.bed_id = b.bed_id
                      INNER JOIN location l ON l.location_id = blm.location_id AND l.retired IS FALSE
                  ) bed_info ON bed_info.patient_id = sa.patient_id
  ORDER BY sb.start_datetime DESC;"
   ,'SQL for scheduled patient listing queues for OT module',@uuid);
