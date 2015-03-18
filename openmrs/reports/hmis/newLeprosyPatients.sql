SELECT
  @a := @a + 1                                                               AS SN,
  pa.person_id                                                               AS 'Person Id',
  concat(given_name, " ", family_name)                                       AS 'Name of New Cases (Patient)',
  cv1.concept_full_name                                                      AS 'Caste Code',
  if(DATEDIFF(CURRENT_DATE, person.birthdate) / 365 < 1,
     cast(DATEDIFF(CURRENT_DATE, person.birthdate) / 365 AS DECIMAL(10, 1)),
     cast(DATEDIFF(CURRENT_DATE, person.birthdate) / 365 AS DECIMAL(10, 0))) AS Age,
  gender                                                                     AS Gender,
  county_district                                                            AS District,
  city_village                                                               AS 'VDC/Municipality',
  paddr.address1                                                             AS 'Ward No',
  leprosy_type.type                                                          AS Type,
  grade.grade_type                                                           AS DG

FROM (SELECT @a := 0) initvars, person_name
  JOIN person ON person.person_id = person_name.person_id
  JOIN person_address AS paddr ON paddr.person_id = person.person_id
  JOIN person_attribute AS pa ON pa.person_id = person.person_id
  JOIN concept_view cv1 ON pa.value = cv1.concept_id

  JOIN obs AS newPatientObs ON person.person_id = newPatientObs.person_id AND newPatientObs.voided IS FALSE
  JOIN concept_view cv2 ON newPatientObs.value_coded = cv2.concept_id AND cv2.concept_full_name = 'New Patients'
                           AND cast(newPatientObs.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#'
  LEFT JOIN
  (SELECT
     person_id,
     obs_group_id,
     cv4.concept_full_name AS type
   FROM obs AS lepTypeObs
     JOIN concept_view cv3 ON lepTypeObs.concept_id = cv3.concept_id AND cv3.concept_full_name = 'Leprosy, Leprosy Type'
     JOIN concept_view cv4 ON cv4.concept_id = lepTypeObs.value_coded
   WHERE lepTypeObs.voided IS FALSE ) AS leprosy_type
    ON leprosy_type.person_id = person.person_id AND
       newPatientObs.obs_group_id = leprosy_type.obs_group_id
  LEFT JOIN
  (SELECT
     person_id,
     obs_group_id,
     cv6.concept_full_name AS grade_type
   FROM obs AS dgObs
     JOIN concept_view cv5 ON dgObs.concept_id = cv5.concept_id AND cv5.concept_full_name = 'Leprosy, Disability Grade'
     JOIN concept_view cv6 ON dgObs.value_coded = cv6.concept_id
   WHERE dgObs.voided IS FALSE ) AS grade
    ON newPatientObs.obs_group_id = grade.obs_group_id AND
       person.person_id = grade.person_id;