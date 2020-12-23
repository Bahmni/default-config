/* get all locatios uuid */
SELECT uuid FROM location;
/* get LAB VISIT uuid */
SELECT uuid FROM visit_type where name = 'LAB VISIT';
/* get location visit type netity mapping type */
SELECT id FROM entity_mapping_type  where name = 'loginlocation_visittype';

/* NOTE - The uuids will differ for each instance, SO RUN ABOVE QUERIES FIRST */
INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'79689beb-b9a1-11ea-b254-12519016ccff','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'8d6c993e-c2cc-11de-8d13-0010c6dffd0f','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'baf7bd38-d225-11e4-9c67-080027b662ec','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'baf83667-d225-11e4-9c67-080027b662ec','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'bb0e512e-d225-11e4-9c67-080027b662ec','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'bb0eb071-d225-11e4-9c67-080027b662ec','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'c1e42932-3f10-11e4-adec-0800271c1b75','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'c1e4950f-3f10-11e4-adec-0800271c1b75','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'c1ebb8db-3f10-11e4-adec-0800271c1b75','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'c1f25be5-3f10-11e4-adec-0800271c1b75','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'c5854fd7-3f12-11e4-adec-0800271c1b75','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'c58e12ed-3f12-11e4-adec-0800271c1b75','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');

INSERT INTO entity_mapping ( uuid, entity_mapping_type_id , entity1_uuid , entity2_uuid , date_created) VALUES (uuid(),3,'e48fb2b3-d490-11e5-b193-0800270d80ce','bef32e14-3f12-11e4-adec-0800271c1b75','2020-12-23 14:43:56.0');