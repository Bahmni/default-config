CREATE PROCEDURE add_concept (INOUT new_concept_id INT,
                              INOUT concept_name_short_id INT,
                              INOUT concept_name_full_id INT,
                              name_of_concept VARCHAR(255),
                              concept_short_name VARCHAR(255),
                              data_type_name VARCHAR(255),
                              class_name VARCHAR(255),
                              is_set BOOLEAN)
BEGIN
  DECLARE data_type_id INT;
  DECLARE class_id INT;
  DECLARE is_set_val TINYINT(1);

  CASE
    WHEN is_set = TRUE THEN
       SET is_set_val = '1';
    WHEN is_set = FALSE THEN
       SET is_set_val = '0';
  END CASE;

  SELECT count(distinct concept_id) into @concept_count from concept_name where name = name_of_concept and concept_name_type='FULLY_SPECIFIED';

  IF @concept_count = 0 THEN

    SELECT concept_datatype_id INTO data_type_id FROM concept_datatype WHERE name = data_type_name;
    SELECT concept_class_id INTO class_id FROM concept_class WHERE name = class_name;

    SELECT uuid() into @uuid;
    INSERT INTO concept (datatype_id, class_id, is_set, creator, date_created, changed_by, date_changed, uuid)
      values (data_type_id, class_id, is_set_val, 1, now(), 1, now(), @uuid);
    SELECT MAX(concept_id) INTO new_concept_id FROM concept;

    SELECT uuid() into @uuid;
    INSERT INTO concept_name (concept_id, name, locale, locale_preferred, creator, date_created, concept_name_type, uuid)
      values (new_concept_id, concept_short_name, 'fr', 0, 1, now(), 'SHORT', @uuid);
    SELECT MAX(concept_name_id) INTO concept_name_short_id FROM concept_name;

    SELECT uuid() into @uuid;
    INSERT INTO concept_name (concept_id, name, locale, locale_preferred, creator, date_created, concept_name_type, uuid)
      values (new_concept_id, name_of_concept, 'fr', 1, 1, now(), 'FULLY_SPECIFIED', @uuid);
    SELECT MAX(concept_name_id) INTO concept_name_full_id FROM concept_name;

    SELECT uuid() into @uuid;
    INSERT INTO concept_name (concept_id, name, locale, locale_preferred, creator, date_created, concept_name_type, uuid)
    values (new_concept_id, concept_short_name, 'en', 0, 1, now(), 'SHORT', @uuid);
    SELECT MAX(concept_name_id) INTO concept_name_short_id FROM concept_name;

    SELECT uuid() into @uuid;
    INSERT INTO concept_name (concept_id, name, locale, locale_preferred, creator, date_created, concept_name_type, uuid)
    values (new_concept_id, name_of_concept, 'en', 0, 1, now(), 'FULLY_SPECIFIED', @uuid);
    SELECT MAX(concept_name_id) INTO concept_name_full_id FROM concept_name;

  ELSE

    select concept_id, concept_name_id into new_concept_id, concept_name_full_id
    from concept_name
    where name = name_of_concept
      and concept_name_type = "FULLY_SPECIFIED"
      and locale = "fr";

    select concept_name_id into concept_name_short_id
    from concept_name
    where name = name_of_concept
      and concept_name_type = "SHORT"
      and locale = "fr";

  END IF;

END;
