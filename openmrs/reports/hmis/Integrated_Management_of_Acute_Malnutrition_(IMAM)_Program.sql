SELECT
  COUNT(DISTINCT lastMonthPetient)                   AS 'Children at End of Last Month',
  if(age < 6, '< 6 month', '6-59 month')             AS 'Age Group',
  gender                                             AS 'Sex',
  SUM(IF(adtType = 'NEW', 1, 0))                     AS 'New Admission',
  SUM(IF(adtType = 'Re-admission', 1, 0))            AS 'Re-admission',
  SUM(IF(adtType = 'Transfer In', 1, 0))             AS 'Transfer In',
  SUM(IF(adtType = 'Recovered', 1, 0))               AS 'Recovered',
  SUM(IF(adtType = 'Death', 1, 0))                   AS 'Death',
  SUM(IF(adtType = 'Defaulter – DF', 1, 0))          AS 'De-faulter',
  SUM(IF(adtType = 'IMAM, Refer to Hospital', 1, 0)) AS 'Refer to Hospital',
  SUM(IF(adtType = 'Transfer Out - TO', 1, 0))       AS 'Transfer Out',
  COUNT(DISTINCT thisMothPetient)                    AS 'Children at End of This Month'


FROM (

       SELECT
         TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) AS                age,
         oAdtType.answer_full_name                         AS                adtType,
         p.gender                                          AS                gender,
         if(oAdtType.obs_datetime >= DATE('#startDate#'), p.person_id, NULL) thisMothPetient,
         if(oAdtType.obs_datetime < DATE('#startDate#'), p.person_id, NULL)  lastMonthPetient
       FROM person p
         JOIN visit v ON p.person_id = v.patient_id
         JOIN encounter e ON v.visit_id = e.visit_id
         JOIN nonVoidedQuestionAnswerObs oAdtType ON e.encounter_id = oAdtType.encounter_id
       WHERE !p.voided AND !v.voided AND !e.voided
             AND
             DATE(oAdtType.obs_datetime) BETWEEN DATE_SUB(DATE('#startDate#'), INTERVAL 1 MONTH) AND DATE('#endDate#')
             AND TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) < 60
             AND (oAdtType.question_full_name = 'IMAM, Admission' OR
                  oAdtType.question_full_name = 'IMAM, Discharge')) IMAM
GROUP BY `Age Group`,`Sex`
ORDER BY `Age Group` DESC;