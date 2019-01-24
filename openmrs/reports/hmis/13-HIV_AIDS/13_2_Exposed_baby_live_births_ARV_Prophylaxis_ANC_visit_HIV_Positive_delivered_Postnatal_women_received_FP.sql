SELECT 
    livebirth.exposed_baby AS 'Exposed baby (live births)',
    prophylaxis.baby_prophylaxis AS 'Exposed baby (Started ARV Prophylaxis)',
    ANC.anc_visit AS 'Number of ANC visits',
    hivdeliverd.delivered_women AS 'HIV+ve Women Delivered',
    fpservies.HIV_postnatal AS 'HIV+ve postnatal women received FP services'
FROM
    (SELECT 
        COUNT(DISTINCT (o1.person_id)) AS exposed_baby
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'PMTCT, Baby birth status'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.name = 'Livebirth'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) AS livebirth
        INNER JOIN
    (SELECT 
        COUNT(DISTINCT (o1.person_id)) AS baby_prophylaxis
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'PMTCT, Started ARV Prophylaxis for Baby'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.concept_id = '1'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) prophylaxis
        INNER JOIN
    (SELECT 
        COUNT(DISTINCT (o1.person_id)) AS anc_visit
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'ANC, ANC Visit'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) AS ANC
        INNER JOIN
    (SELECT 
        COUNT(DISTINCT (o1.person_id)) AS delivered_women
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Intrapartum'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
        AND cn2.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) hivdeliverd
        INNER JOIN
    (SELECT 
        COUNT(DISTINCT (o1.person_id)) AS HIV_postnatal
    FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'PMTCT, Family Planning services provided postpartum'
        AND o1.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN person p1 ON o1.person_id = p1.person_id
    WHERE
        DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
            AND o1.value_coded IS NOT NULL) fpservies
        
