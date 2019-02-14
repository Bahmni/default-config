
SELECT 
    'Number of ANC Visit' AS Report,
    COUNT(DISTINCT person.person_id) AS No_of_patients
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'ANC, ANC Visit'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
        INNER JOIN
    concept_name cn2 ON obs.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
        AND cn2.name = 'ANC, 1st (any time)'
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
UNION 
SELECT 
    'ANC Counseled' AS Report,
    COUNT(DISTINCT obs.person_id) AS No_of_patients
FROM
    person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'ANC, HIV Counseling'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
        AND obs.value_coded = 1
        AND person.person_id IN (SELECT 
            person.person_id AS person_id
        FROM
            person person
                INNER JOIN
            obs ON obs.person_id = person.person_id
                AND person.voided = 0
                INNER JOIN
            concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
                AND deliveryMethodConcept.name = 'ANC, ANC Visit'
                AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
                INNER JOIN
            concept_name cn2 ON obs.value_coded = cn2.concept_id
                AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                AND cn2.voided = 0
                AND cn2.name = 'ANC, 1st (any time)'
        WHERE
               DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)) 
UNION 
SELECT 
    'ANC Tested' AS Report,
    COUNT(DISTINCT obs.person_id) AS No_of_patients
FROM
    person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'ANC, HIV Testing'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
        AND obs.value_coded = 1
        AND person.person_id IN (SELECT 
            person.person_id AS person_id
        FROM
            person person
                INNER JOIN
            obs ON obs.person_id = person.person_id
                AND person.voided = 0
                INNER JOIN
            concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
                AND deliveryMethodConcept.name = 'ANC, ANC Visit'
                AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
                INNER JOIN
            concept_name cn2 ON obs.value_coded = cn2.concept_id
                AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                AND cn2.voided = 0
                AND cn2.name = 'ANC, 1st (any time)'
        WHERE
               DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
) 
UNION 
SELECT 
    'ANC Positive' AS Report,
    COUNT(DISTINCT p1.person_id) AS No_of_patients
FROM
obs o1
INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
AND cn1.concept_name_type = 'FULLY_SPECIFIED'
AND cn1.name IN ('ANC, HIV Test Result')
AND o1.voided = 0
AND cn1.voided = 0
INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
AND cn2.concept_name_type = 'FULLY_SPECIFIED'
AND cn2.voided = 0
AND cn2.name = 'Positive'
INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
INNER JOIN person p1 ON o1.person_id = p1.person_id
WHERE DATE(e.encounter_datetime) BETWEEN '2018-12-16' and '2019-1-14'
AND o1.value_coded IS NOT NULL
UNION 
SELECT 
    'Labour and delivery - Counseled' AS Report,
    COUNT(DISTINCT person.person_id) AS No_of_patients
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'HIV Counselled'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
UNION 
SELECT 
    'Labour and delivery - tested' AS Report,
    COUNT(DISTINCT person.person_id) AS No_of_patients
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'Delivery note-Test performed in this delivery?'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
    AND obs.value_coded = 1
UNION 
SELECT 
    'Labour and Delivery Positive' AS Report,
    COUNT(DISTINCT person.person_id) AS No_of_patients
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'Delivery note-Test result'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
        INNER JOIN
    concept_name cn2 ON obs.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
        AND cn2.name = 'HIV positive'
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 

UNION
SELECT 
    'PNC counseled' AS Report,
    COUNT(DISTINCT person.person_id) AS No_of_patients
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'PNC - HIV counselling'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
       
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
       UNION
SELECT 
    'PNC tested' AS Report,
    COUNT(DISTINCT person.person_id) AS No_of_patients
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'PNC - HIV tested'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
       
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
    UNION
SELECT 
    'PNC Positive' AS Report,
    COUNT(DISTINCT person.person_id) AS No_of_patients
FROM
    person person
        INNER JOIN
    obs ON obs.person_id = person.person_id
        AND person.voided = 0
        INNER JOIN
    concept_name deliveryMethodConcept ON deliveryMethodConcept.concept_id = obs.concept_id
        AND deliveryMethodConcept.name = 'HCT, Result if tested'
        AND deliveryMethodConcept.concept_name_type = 'FULLY_SPECIFIED'
		 INNER JOIN
    concept_name cn2 ON obs.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
        AND cn2.name = 'Positive'
       
WHERE
    DATE(obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) 
  
    
  
