
SELECT
  COALESCE(SUM(If(age >= 6 AND age <= 11, vitaminA, 0)),0)  AS 'Vitamin-A 6-11M',
  COALESCE(SUM(If(age >= 12 AND age <= 59, vitaminA, 0)),0) AS 'Vitamin-A 12-59M',
  COALESCE(SUM(deworming),0)                                AS 'Deworming tablet'
FROM (
       SELECT
         p.person_id,
         TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) AS age,
         IF(oDeworming.answer_full_name = 'True', 1, 0)    AS deworming,
         IF(oVitaminA.value_numeric > 0, 1, 0)             AS vitaminA
       FROM person p
         JOIN visit v ON p.person_id = v.patient_id
         JOIN encounter e ON v.visit_id = e.visit_id
         JOIN nonVoidedQuestionAnswerObs oDeworming ON e.encounter_id = oDeworming.encounter_id
         JOIN obs oVitaminA ON e.encounter_id = oVitaminA.encounter_id
         JOIN concept_name vitaminAConcept ON vitaminAConcept.concept_id = oVitaminA.concept_id
       WHERE !p.voided AND !v.voided AND !e.voided And !oVitaminA.voided
             AND DATE(oDeworming.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
             AND DATE(oVitaminA.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
             AND TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) < 60
             AND (oDeworming.question_full_name = 'Childhood Illness, Albendazole Given')
             AND (vitaminAConcept.name = 'Childhood Illness, Vitamin A Capsules Provided' AND
                  vitaminAConcept.concept_name_type = 'FULLY_SPECIFIED' AND !vitaminAConcept.voided))nutration;