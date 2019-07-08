INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.transferEnHospitalisation',
"SELECT DISTINCT
          pi.identifier                                         AS identifier,
          concat(pn.given_name, ' ', pn.family_name)            AS PATIENT_LISTING_QUEUES_HEADER_NAME,
          floor(DATEDIFF(CURDATE(), p.birthdate) / 365)         AS age,
          p.gender                                              AS gender,
          parentLocation.name                                   AS department,
          b.bed_number                                          AS `Bed No`,
          DATE_FORMAT(o.obs_datetime,'%d %b %Y %h:%i %p')       AS 'Disposition Date',
          'Mouvement des patients'                                    AS action,
          CONCAT('', p.uuid)                                    AS uuid,
          CONCAT('', v.uuid)                                    AS activeVisitUuid
        FROM visit v
        INNER JOIN person_name pn ON v.patient_id = pn.person_id and pn.voided is FALSE AND v.voided IS FALSE
        INNER JOIN patient_identifier pi ON v.patient_id = pi.patient_id and pi.voided is FALSE
        INNER JOIN patient_identifier_type pit on pi.identifier_type = pit.patient_identifier_type_id
        INNER JOIN global_property gp on gp.property='bahmni.primaryIdentifierType' and gp.property_value=pit.uuid
        INNER JOIN person p ON v.patient_id = p.person_id
        INNER JOIN bed_patient_assignment_map bpam ON bpam.patient_id = p.person_id AND bpam.date_stopped IS NULL AND bpam.voided IS FALSE
        INNER JOIN bed b ON bpam.bed_id = b.bed_id
        INNER JOIN bed_location_map blm ON bpam.bed_id = blm.bed_id
        INNER JOIN location parentLocation ON parentLocation.location_id = blm.location_id AND parentLocation.retired IS FALSE
        INNER JOIN encounter bpame ON bpam.encounter_id = bpame.encounter_id
        INNER JOIN (SELECT DISTINCT v.visit_id
          FROM encounter en
          LEFT JOIN visit v ON v.visit_id = en.visit_id AND en.encounter_type =
            (SELECT encounter_type_id
              FROM encounter_type
            WHERE name = 'ADMISSION')) v1 on v1.visit_id = v.visit_id
        INNER JOIN ( SELECT
                        en.patient_id,
                        max(en.date_created) AS dateCreated
                    FROM encounter en
                    INNER JOIN obs o ON en.encounter_id = o.encounter_id
                    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.voided is FALSE AND cn.name = 'Disposition'
                    GROUP BY en.patient_id
                       ) latestEncounterWithDisposition ON v.patient_id = latestEncounterWithDisposition.patient_id
        INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.date_created = latestEncounterWithDisposition.dateCreated
                                                          AND e.patient_id = latestEncounterWithDisposition.patient_id
        INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided IS FALSE
        INNER JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.voided is FALSE
                                                                    AND cn.name in ('Transférer en Hospitalisation','Transférer aux Soins Intensifs','Transférer en BMR') AND o.date_created > bpam.date_created
    WHERE v.date_stopped IS NULL
    ORDER BY o.obs_datetime;",'Patient moving to different bed/location',uuid());
