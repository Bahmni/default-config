
SELECT
  final.`Visit Type`          AS 'Visit Type',
  sum(final.`0-11 Normal`)    AS '0-11 Normal',
  sum(final.`0-11 Moderate`)  AS '0-11 Moderate',
  sum(final.`0-11 Severe`)    AS '0-11 Severe',
  sum(final.`12-23 Normal`)   AS '12-23 Normal',
  sum(final.`12-23 Moderate`) AS '12-23 Moderate',
  sum(final.`12-23 Severe`)   AS '12-23 Severe'
FROM
(SELECT
  visitType                                       AS "Visit Type",
  SUM(IF(age < 12 && status = 'Normal', 1, 0))    AS "0-11 Normal",
  SUM(IF(age < 12 && status = 'Severe', 1, 0))    AS "0-11 Moderate",
  SUM(IF(age < 12 && status = 'Moderate', 1, 0))  AS "0-11 Severe",
  SUM(IF(age >= 12 && status = 'Normal', 1, 0))   AS "12-23 Normal",
  SUM(IF(age >= 12 && status = 'Severe', 1, 0))   AS "12-23 Moderate",
  SUM(IF(age >= 12 && status = 'Moderate', 1, 0)) AS "12-23 Severe"
FROM (SELECT
        TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) AS age,
        oStatus.answer_full_name                          AS status,
        IF(oVisitType.answer_full_name = 'Nutrition-More Than 1 Visit In a Month',
           'Re-visit',
           oVisitType.answer_full_name)                   AS visitType

      FROM person p
        JOIN visit v ON p.person_id = v.patient_id
        JOIN encounter e ON v.visit_id = e.visit_id
        JOIN nonVoidedQuestionAnswerObs oStatus ON e.encounter_id = oStatus.encounter_id
        JOIN nonVoidedQuestionAnswerObs oVisitType ON e.encounter_id = oVisitType.encounter_id
        JOIN person_address address ON p.person_id = address.person_id
      WHERE !p.voided AND !v.voided AND !e.voided
            AND address.address1 ='10'
            AND DATE(oStatus.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND DATE(oVisitType.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND TIMESTAMPDIFF(MONTH, p.birthdate, v.date_started) < 24
            AND oStatus.question_full_name = 'Nutrition, Nutritional Status'
            AND oVisitType.question_full_name = 'Nutrition, Visit Type') report
GROUP BY visitType
UNION ALL SELECT 'New',0,0,0,0,0,0
UNION ALL SELECT 'Re-visit',0,0,0,0,0,0
)final
GROUP BY final.`Visit Type`;
