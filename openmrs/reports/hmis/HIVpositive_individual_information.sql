SELECT
  @serial_number := @serial_number + 1 AS 'S.No',
  client_code                          AS 'Client Code',
  district_code                        AS 'District Code',
  sex                                  AS 'Sex',
  age_in_years                         AS 'Age(in yrs)',
  risk_groups                          AS 'Risk Group(s)',
  initial_cd4_count                    AS 'Initial CD4 Count',
  who_stage                            AS 'WHO Stage'
FROM
  (SELECT
     t1.identifier                                   AS client_code,
     county_district                                 AS district_code,
     gender                                          AS sex,
     floor(DATEDIFF(obs_date, birthdate) / 365)      AS age_in_years,
     group_concat(DISTINCT risk_group SEPARATOR ',') AS risk_groups,
     CD4                                             AS initial_cd4_count,
     WHO                                             AS who_stage
   FROM

     (SELECT
        pi.identifier,
        o.person_id,
        pa.county_district,
        p.gender,
        o.concept_full_name,
        c.concept_full_name  AS 'risk_group',
        o.value_coded,
        o.value_text,
        DATE(o.obs_datetime) AS 'obs_date',
        p.birthdate
      FROM obs_view o
        INNER JOIN person p ON o.person_id = p.person_id
        INNER JOIN person_address pa ON p.person_id = pa.person_id
        INNER JOIN patient_identifier pi ON p.person_id = pi.patient_id and pi.preferred = 1
        LEFT OUTER JOIN concept_view c ON o.value_coded = c.concept_id
      WHERE
        (o.voided = 0 AND o.concept_full_name IN ('HTC, Risk Group', 'PMTCT, Risk Group') AND o.value_coded IS NOT NULL)
        AND (DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
      GROUP BY o.person_id, o.concept_full_name, c.concept_full_name) AS t1

     INNER JOIN

     (SELECT person_id
      FROM obs_view
      WHERE voided = 0 AND ((concept_full_name = 'HTC, Result if tested'
                             AND value_coded IN (SELECT concept_id
                                                 FROM concept_view
                                                 WHERE concept_full_name = 'Positive')) OR
                            (concept_full_name IN ('HIV (Blood)', 'HIV (Serum)') AND value_text IN ('Positive')))
            AND (DATE(obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
      GROUP BY person_id) AS t2 ON t1.person_id = t2.person_id

     INNER JOIN

     (SELECT
        person_id,
        value_numeric AS 'CD4',
        min(obs_datetime)
      FROM obs_view
      WHERE voided = 0 AND concept_full_name = 'HTC, CD4 Count'
      GROUP BY person_id) AS t3 ON t1.person_id = t3.person_id

     INNER JOIN

     (SELECT
        o.person_id,
        c.concept_full_name AS 'WHO'
      FROM obs_view o
        INNER JOIN concept_view c ON o.value_coded = c.concept_id
      WHERE o.voided = 0 AND o.concept_full_name IN ('HTC, WHO Staging', 'PMTCT, WHO clinical staging') AND
            o.value_coded IS NOT NULL AND (o.person_id, o.obs_datetime) IN
                                          (SELECT
                                             person_id,
                                             max(obs_datetime) AS 'obs_datetime'
                                           FROM
                                             (SELECT
                                                o.person_id,
                                                o.concept_full_name,
                                                o.obs_datetime,
                                                o.value_coded,
                                                c.concept_full_name AS 'WHO_Stage'
                                              FROM obs_view o
                                                INNER JOIN concept_view c ON o.value_coded = c.concept_id
                                              WHERE o.voided = 0 AND o.concept_full_name IN
                                                                     ('HTC, WHO Staging', 'PMTCT, WHO clinical staging')
                                                    AND o.value_coded IS NOT NULL
                                              GROUP BY o.person_id, o.concept_full_name
                                              HAVING max(o.obs_datetime)) AS t1
                                           GROUP BY t1.person_id)) AS t4 ON t1.person_id = t4.person_id

   GROUP BY t1.identifier
   ORDER BY t1.person_id) AS final_table
  JOIN
  (SELECT @serial_number := 0) AS r;