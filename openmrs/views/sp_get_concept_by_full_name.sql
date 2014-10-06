-- Example
-- call get_concept_by_full_name('Coded Diagnosis', @coded_diagnosis_concept_id);

DROP PROCEDURE IF EXISTS get_concept_by_full_name;

DELIMITER //
CREATE PROCEDURE get_concept_by_full_name(IN name varchar(255), OUT concept_id int)
BEGIN
	Select concept.concept_id INTO concept_id 
	FROM concept 
	JOIN concept_name ON concept_name.concept_id = concept.concept_id and concept_name.concept_name_type = 'FULLY_SPECIFIED'
	WHERE concept_name.name = name;
END //
DELIMITER ;

