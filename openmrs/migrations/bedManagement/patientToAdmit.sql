
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.admettreEnHospitalisation',
"SELECT DISTINCT
  pi.identifier                                         AS identifier,
  concat(pn.given_name, ' ', ifnull(pn.family_name,''))            AS PATIENT_LISTING_QUEUES_HEADER_NAME,
  floor(DATEDIFF(CURDATE(), p.birthdate) / 365)         AS age,
  p.gender                                              AS gender,
  DATE_FORMAT(o.obs_datetime,'%d %b %Y %h:%i %p')       AS 'Disposition Date',
  cn.name                                               As Department,
  'Admettre le patient'                                         AS action,
  concat('', p.uuid)                                    AS uuid,
  concat('', v.uuid)                                    AS activeVisitUuid
FROM person p
  INNER JOIN person_name pn ON p.person_id = pn.person_id AND pn.voided IS FALSE AND p.voided IS FALSE
  INNER JOIN patient_identifier pi ON p.person_id = pi.patient_id AND pi.voided IS FALSE
  INNER JOIN patient_identifier_type pit ON pi.identifier_type = pit.patient_identifier_type_id AND pit.retired IS FALSE
  INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided IS FALSE
  INNER JOIN ( SELECT
                    en.patient_id,
                    max(en.date_created) AS dateCreated
                FROM encounter en
                INNER JOIN obs o ON en.encounter_id = o.encounter_id
                INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.voided is FALSE AND cn.name = 'Disposition'
                GROUP BY en.patient_id
            ) latestEncounterWithDisposition ON v.patient_id = latestEncounterWithDisposition.patient_id
  INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.date_created = latestEncounterWithDisposition.dateCreated
                            AND e.patient_id = latestEncounterWithDisposition.patient_id AND e.voided IS FALSE
  INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided IS FALSE
  INNER JOIN concept c ON o.value_coded = c.concept_id AND c.retired IS FALSE
  INNER JOIN concept_name cn ON c.concept_id = cn.concept_id AND cn.voided IS FALSE
  LEFT JOIN (SELECT
                    bpam.patient_id,
                    max(bpam.date_stopped) AS date_stopped
                FROM bed_patient_assignment_map bpam
                    WHERE bpam.voided IS FALSE
                GROUP BY bpam.patient_id) lastDischargeTime ON p.person_id = lastDischargeTime.patient_id
WHERE v.date_stopped IS NULL AND cn.name in ('Admettre en Hospitalisation','Admettre aux Soins Intensifs','Admettre en BMR') AND p.person_id NOT IN (SELECT patient_id
                                                                                   FROM bed_patient_assignment_map bpam
                                                                                   WHERE bpam.date_stopped IS NULL
                                                                                   GROUP BY patient_id)
                            AND CASE
                                    WHEN lastDischargeTime.date_stopped IS NOT NULL AND o.date_created > lastDischargeTime.date_stopped THEN 1
                                    WHEN lastDischargeTime.date_stopped IS NULL THEN 1
                                END
GROUP BY pi.identifier
ORDER BY o.obs_datetime;",'To Admit patient list',uuid());
