select base.result,IF(actual.number is null, 0, actual.number) as count from
(SELECT 'Within' as result
UNION
    SELECT 'Outside' as result
UNION
    SELECT 'Foreigner' as result) base
LEFT OUTER JOIN
(SELECT
  IF(pa.country = 'Nepal', IF(pa.county_district = 'Achham', 'Within', 'Outside'), 'Foreigner') result,
  COUNT(pa.county_district)  as number
FROM obs obs
  INNER JOIN concept_name cn ON obs.concept_id = cn.concept_id
  INNER JOIN person_address pa ON obs.person_id = pa.person_id
WHERE cn.name = 'K-39' AND concept_name_type = 'FULLY_SPECIFIED' AND obs.value_text = 'Positive' 
AND DATE(obs_datetime) between '#startDate#' AND '#endDate#'
GROUP BY result) actual on base.result = actual.result;