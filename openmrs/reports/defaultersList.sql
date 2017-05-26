SELECT
  DISTINCT
  t3.identifier                                                                                       AS 'Patient ID',
  CONCAT_WS(' ',pn.given_name,pn.middle_name,pn.family_name) AS Name,
  TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started)                                                   AS Age,
  p.gender                                                                                            AS Gender,
  CONCAT_WS(',',pa.address1,pa.address2,pa.city_village,pa.county_district)                                                              AS Address,
  patt.value                                                                                          AS 'Contact Number'
FROM nonVoidedQuestionAnswerObs prevObs
  LEFT JOIN nonVoidedQuestionAnswerObs currentObs
    ON currentObs.person_id = prevObs.person_id
       AND currentObs.obs_datetime <= DATE_ADD(prevObs.obs_datetime, INTERVAL 28 DAY)
       AND currentObs.obs_datetime > prevObs.obs_datetime
       AND DATE(currentObs.obs_datetime) <= '#endDate#'
       AND currentObs.question_full_name = 'Admission Type'

  INNER JOIN patient_identifier t3 ON
                                     prevObs.person_id = t3.patient_id AND t3.identifier_type = 3 AND !t3.voided
  INNER JOIN encounter e ON e.encounter_id = prevObs.encounter_id AND !e.voided
  INNER JOIN visit v ON v.visit_id = e.visit_id AND !v.voided
  INNER JOIN person_name pn ON pn.person_id = t3.patient_id AND !pn.voided

  INNER JOIN person p ON p.person_id = pn.person_id AND !p.voided
  LEFT JOIN person_attribute patt ON patt.person_id = p.person_id AND !patt.voided
                                     AND patt.person_attribute_type_id IN (SELECT person_attribute_type_id
                                                                           FROM person_attribute_type
                                                                           WHERE name = 'Contact Number')
  LEFT JOIN person_address pa ON pa.person_id = pn.person_id AND !pa.voided
WHERE
  currentObs.obs_id is NULL
  AND prevObs.obs_datetime >= DATE_SUB('#startDate#', INTERVAL 28 DAY)
  AND DATE(prevObs.obs_datetime) <= DATE_SUB('#endDate#',INTERVAL 28 DAY)
  AND prevObs.question_full_name = 'Admission Type';