SELECT
  final.ObstetricComplications AS 'Obstetric Complicationss',
  final.icdCode AS 'ICD Code',
  sum(final.count) AS Number
FROM
(SELECT
  o.answer_full_name AS ObstetricComplications,
  crterm.code        AS icdCode,
  COUNT(*)           AS count
FROM nonVoidedQuestionAnswerObs o
  INNER JOIN concept_reference_map crmap ON o.answer_id = crmap.concept_id
  INNER JOIN concept_reference_term crterm ON crmap.concept_reference_term_id = crterm.concept_reference_term_id
  INNER JOIN concept_reference_source crsorce
    ON crterm.concept_source_id = crsorce.concept_source_id AND crsorce.name = 'ICD-10-WHO'
WHERE o.question_full_name = 'ANC-Obstetric Complication'
      AND o.answer_full_name NOT LIKE '%Not present%'
      AND (DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#')
GROUP BY crterm.code
 UNION ALL SELECT 'Ectopic Pregnancy',            'O00',0
 UNION ALL SELECT 'Abortion Complication',        'O08',0
 UNION ALL SELECT 'Pregnancy Induced Hypertension','O13',0
 UNION ALL SELECT 'Severe/Pre-eclampsia',         'O14',0
 UNION ALL SELECT 'Eclampsia',                    'O15',0
 UNION ALL SELECT 'Hyperemesis grivadarum',       'O21.0',0
 UNION ALL SELECT 'Antepartum Haemorrhage',       'O46',0
 UNION ALL SELECT 'Prolonged labour',             'O63',0
 UNION ALL SELECT 'Obstructed Labor',             'O64-O66',0
 UNION ALL SELECT 'Ruptured uterus',              'S37.6',0
 UNION ALL SELECT 'Postpartum haemorrhage',       'O72',0
 UNION ALL SELECT 'Retained placenta',            'O73',0
 UNION ALL SELECT 'Pueperal sepsis',              'O85',0
 UNION ALL SELECT 'Other complications',          'O75',0
) final
GROUP BY final.icdCode;