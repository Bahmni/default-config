SELECT
  'Accessed' AS 'Treatment Adherence on ART',
  count(*)   AS 'No of Cases'
FROM obs_view
WHERE concept_full_name = 'ART, ART adherence to ART' AND
      value_coded IS NOT NULL AND obs_datetime < @end_date

UNION ALL

SELECT
  '< 95% (A)' AS 'Treatment Adherence on ART',
  count(*)    AS 'No of Cases'
FROM valid_coded_obs_view
WHERE concept_full_name = 'ART, ART adherence to ART'
      AND obs_datetime < @end_date AND value_concept_full_name = 'Adherence Level A'

UNION ALL

SELECT
  '80-95% (B)' AS 'Treatment Adherence on ART',
  count(*)     AS 'No of Cases'
FROM valid_coded_obs_view
WHERE concept_full_name = 'ART, ART adherence to ART'
      AND obs_datetime < @end_date AND value_concept_full_name = 'Adherence Level B'

UNION ALL
SELECT
  '< 80% (C)' AS 'Treatment Adherence on ART',
  count(*)    AS 'No of Cases'
FROM valid_coded_obs_view
WHERE concept_full_name = 'ART, ART adherence to ART'
      AND obs_datetime < @end_date AND value_concept_full_name = 'Adherence Level C';