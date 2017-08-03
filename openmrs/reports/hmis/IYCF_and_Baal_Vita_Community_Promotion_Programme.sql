SELECT
  CASE
    WHEN (age >=6 and age <= 11) THEN "6-11 M"
    WHEN (age >=12 and age <= 17) THEN "12-17 M"
    WHEN (age >=18 and age <=23) THEN "18-23 M"
  END As "Age group",
  SUM(IF(isFCHV= "True" and numOfTimes=1,1,0)) AS "First Time/FCHV",
  SUM(IF(isFCHV= "False" and numOfTimes=1,1,0)) AS "First Time/HV",
  SUM(IF(isFCHV= "True" and numOfTimes=2,1,0)) AS "Second Time/FCHV",
  SUM(IF(isFCHV= "False" and numOfTimes=2,1,0)) AS "Second Time/HV",
  SUM(IF(isFCHV= "True" and numOfTimes=3,1,0)) AS "Third Time/FCHV",
  SUM(IF(isFCHV= "False" and numOfTimes=3,1,0)) AS "Third Time/HV"
from
(
SELECT
  p.person_id                                       AS personId,
  COUNT(e.encounter_id) As numOfTimes,
  TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) AS age,
  oIsFCHV.answer_full_name                          AS isFCHV
FROM person p
  JOIN visit v ON p.person_id = v.patient_id
  JOIN encounter e ON v.visit_id = e.visit_id
  JOIN nonVoidedQuestionAnswerObs oIsFCHV ON e.encounter_id = oIsFCHV.encounter_id
WHERE !p.voided AND !v.voided AND !e.voided
      AND
      DATE(oIsFCHV.obs_datetime) BETWEEN DATE('2017-03-01') AND DATE('2017-03-31')
      AND TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) >=6
      AND TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) <= 23
      AND (oIsFCHV.question_full_name = 'Nutrition, Bal Vita Provided by FCHV')
GROUP BY personId) baalVitaProgram GROUP BY `Age group` ORDER BY age;