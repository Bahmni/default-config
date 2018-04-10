SELECT
                     count(distinct o1.person_id) as Discontinued_count
                    FROM obs o1
                      INNER JOIN concept_name cn1
                        ON o1.concept_id = cn1.concept_id AND
                           cn1.concept_name_type = 'FULLY_SPECIFIED' and 
                           cn1.name  = 'FRH-Discontinued'
                           AND o1.voided = 0 AND cn1.voided = 0
                      INNER JOIN concept_name cn2
                        ON o1.value_coded = cn2.concept_id
                           AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                           AND cn2.voided = 0
                      INNER JOIN encounter e
                        ON o1.encounter_id = e.encounter_id
                      INNER JOIN visit v1
                        ON v1.visit_id = e.visit_id
					Inner JOIN person p1
						ON o1.person_id = p1.person_id
                    WHERE 
                    -- DATE(e.encounter_datetime) BETWEEN DATE('2017-01-01') and DATE('2017-01-30')
                    DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
                    and o1.value_coded IS NOT NULL