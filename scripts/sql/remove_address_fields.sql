UPDATE openmrs.address_hierarchy_level SET name = 'City' WHERE name = 'Village';
DELETE FROM openmrs.address_hierarchy_level WHERE name NOT IN ('State', 'City', 'House No., Street');
/* adjust the parent level of City and House No., Street*/
/* ************ NOTE: THE IDS BELOW WILL VARY FOR EACH INSTANCE. MANUAL UPDATE NECESSARY *****/
UPDATE openmrs.address_hierarchy_level SET parent_level_id = 3 WHERE name ='City';
UPDATE openmrs.address_hierarchy_level SET parent_level_id = 6 WHERE name ='House No., Street';

SELECT * FROM openmrs.address_hierarchy_level;
