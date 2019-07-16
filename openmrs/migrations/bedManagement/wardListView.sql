SELECT uuid() INTO @uuid;
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlGet.allWardsListDetails',
"SELECT DISTINCT
bed.bed_number                                                                     	AS 'Lit',
CONCAT(pn.given_name, ' ', pn.family_name)                                         	AS 'Nom',
patient_identifier.identifier                                                      	AS 'Identité',
p.gender                                                                              As 'Sexe',
TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE())                                           AS 'Age',
CAST(DATE_FORMAT(latestAdmissionEncounter.admission_datetime, '%Y-%m-%d') AS CHAR) 	AS 'Date d''admission'
from
bed
INNER JOIN bed_location_map blm ON blm.bed_id = bed.bed_id
INNER JOIN location l ON l.location_id = blm.location_id AND l.name = ${location_name} AND l.retired IS FALSE
LEFT OUTER JOIN bed_patient_assignment_map bpam ON bpam.bed_id = bed.bed_id AND bpam.date_stopped IS NULL
LEFT OUTER JOIN person p ON p.person_id = bpam.patient_id AND p.voided IS FALSE
LEFT OUTER JOIN person_name pn ON pn.person_id = p.person_id AND pn.voided IS FALSE
LEFT OUTER JOIN patient_identifier ON patient_identifier.patient_id = p.person_id AND patient_identifier.voided IS FALSE
LEFT OUTER JOIN (
                    SELECT
                      e.patient_id,
                      MAX(e.encounter_datetime) AS admission_datetime
                    FROM
                      encounter e
                      INNER JOIN encounter_type et ON et.encounter_type_id = e.encounter_type AND et.name = 'ADMISSION'
                    GROUP BY
                      e.patient_id
                  ) latestAdmissionEncounter ON p.person_id = latestAdmissionEncounter.patient_id
Order by ABS(bed.bed_number);",'SQL query to get list of bed details in ward',@uuid);
