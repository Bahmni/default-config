SET @start_date = '2014-01-01';
SET @end_date = '2014-01-02';
SELECT
  'Accessed' AS 'Treatment Adherence on ART',
  count(*)   AS 'No of Cases'
FROM obs_view
WHERE concept_full_name = 'ART, ART adherence to ART' AND
      value_coded IS NOT NULL AND obs_datetime < @end_date

UNION ALL

SELECT *
FROM (
       SELECT
         labels.value_string AS 'Treatment Adherence on ART',
         count(*)            AS 'No of Cases'
       FROM bahmni_report_labels labels
         LEFT OUTER JOIN valid_coded_obs_view obs_vw
           ON trim(labels.key_string) = trim(obs_vw.value_concept_full_name)
              AND obs_vw.concept_full_name = 'ART, ART adherence to ART'
              AND obs_vw.obs_datetime < @end_date
       WHERE
         labels.section_name = 'ART_treatment_adherence'
         AND labels.column_name = 'adherence_level'
       GROUP BY labels.value_string
       ORDER BY labels.sort_order
     ) AS breakup;