CREATE  PROCEDURE CREATE_REFERENCE_MAPPING_CEIL(IN concept_name VARCHAR(200), IN code VARCHAR(50))
  BEGIN
    IF NOT EXISTS (SELECT  *
                   FROM concept_name cn,
                     concept_reference_map cm,
                     concept_reference_term crt,
                     concept_reference_source cs
                   WHERE cn.concept_name_type = 'FULLY_SPECIFIED'
                         AND cn.name = concept_name
                         AND cn.concept_id = cm.concept_id
                         AND crt.code = code
                         AND crt.concept_reference_term_id=cm.concept_reference_term_id
                         AND crt.concept_source_id = cs.concept_source_id
                         AND cs.name='CEIL')
    THEN
      INSERT INTO concept_reference_map (concept_reference_term_id, concept_map_type_id,creator,date_created,concept_id,uuid)
        (SELECT  ct.concept_reference_term_id,1,1,now(),cn.concept_id,uuid()
         FROM  concept_name cn,
           concept_reference_term ct,
           concept_reference_source cs
         WHERE ct.code = code
               AND ct.concept_source_id = cs.concept_source_id
               AND cs.name='CEIL'
               AND cn.name=concept_name
               AND cn.concept_name_type='FULLY_SPECIFIED');
    END IF;
END;
