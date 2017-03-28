SELECT
  If(onlyBreastFeeding.question_full_name = 'Nutrition, Only Breast Feeding for 6 Months', 'Excl. breast feeding',
     'Complementary feeding')                 AS question,
  COUNT(DISTINCT onlyBreastFeeding.person_id) AS Count

FROM person p
  JOIN nonVoidedQuestionAnswerObs onlyBreastFeeding ON (onlyBreastFeeding.person_id = p.person_id)
  JOIN person_address address ON p.person_id = address.person_id
WHERE !p.voided AND
      DATE(onlyBreastFeeding.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
      AND (onlyBreastFeeding.question_full_name IN
           ('Nutrition, Only Breast Feeding for 6 Months', 'Nutrition, Breast Feeding and Light Food'))
      AND address.address1 ='10' AND address.county_district = 'saanfebagar'
GROUP BY question