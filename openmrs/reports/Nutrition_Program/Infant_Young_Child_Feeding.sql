SELECT
  T1.question AS 'Infant & Young Child Feeding',
  SUM(T1.Count) AS Count
From
(SELECT
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
      AND address.address1 ='10'
GROUP BY question
UNION ALL SELECT 'Excl. breast feeding', 0
UNION ALL SELECT 'Complementary feeding', 0
) as T1
GROUP BY question
ORDER BY question desc;
