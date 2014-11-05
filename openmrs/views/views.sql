-- Views
CREATE OR REPLACE VIEW concept_reference_term_map_view AS
SELECT 
concept_reference_map.concept_id,
concept_map_type.name AS concept_map_type_name,
concept_reference_term.code,
concept_reference_term.name AS concept_reference_term_name,
concept_reference_source.name AS concept_reference_source_name
FROM concept_reference_term
JOIN concept_reference_map ON concept_reference_map.concept_reference_term_id = concept_reference_term.concept_reference_term_id
JOIN concept_map_type ON concept_reference_map.concept_map_type_id = concept_map_type.concept_map_type_id
JOIN concept_reference_source ON concept_reference_source.concept_source_id = concept_reference_term.concept_source_id;

CREATE OR REPLACE VIEW concept_view AS
SELECT 
concept.concept_id,
concept_full_name.name AS concept_full_name,
concept_short_name.name AS concept_short_name, 
concept_class.name AS concept_class_name,
concept_datatype.name AS concept_datatype_name,
concept.retired
FROM concept
LEFT OUTER JOIN concept_name AS concept_full_name ON concept_full_name.concept_id = concept.concept_id 
			AND concept_full_name.concept_name_type = 'FULLY_SPECIFIED' 
			AND concept_full_name.locale = 'en'
			AND concept_full_name.voided = 0
LEFT OUTER JOIN concept_name AS concept_short_name ON concept_short_name.concept_id = concept.concept_id 
		    AND concept_short_name.concept_name_type = 'SHORT'
			AND concept_short_name.locale = 'en'
			AND concept_short_name.voided = 0 
LEFT OUTER JOIN concept_class ON concept_class.concept_class_id = concept.class_id
LEFT OUTER JOIN concept_datatype ON concept_datatype.concept_datatype_id = concept.datatype_id;

CREATE OR REPLACE VIEW coded_obs_view AS
SELECT 
obs.obs_id,
obs.concept_id,
obs.person_id,
obs.value_coded,
obs.obs_group_id,
obs.obs_datetime,
obs.encounter_id,
reference_concept.concept_full_name AS concept_full_name, 
value_concept.concept_full_name AS value_concept_full_name, 
obs.voided
FROM obs
JOIN concept_view AS reference_concept ON reference_concept.concept_id = obs.concept_id AND reference_concept.concept_datatype_name = 'Coded'
LEFT OUTER JOIN concept_view AS value_concept ON value_concept.concept_id = obs.value_coded;

CREATE OR REPLACE VIEW valid_coded_obs_view AS
SELECT * FROM coded_obs_view
WHERE coded_obs_view.voided = 0;

CREATE OR REPLACE VIEW encounter_view AS
SELECT 
encounter.encounter_id,
encounter.patient_id,
encounter.visit_id,
encounter.location_id,
location.name as location_name,
visit.visit_type_id,
visit.date_started as visit_date_started,
visit_type.name visit_type_name,
encounter.encounter_type as encounter_type_id,
encounter_type.name as encounter_type_name, 
encounter_datetime
FROM encounter
JOIN encounter_type ON encounter_type.encounter_type_id = encounter.encounter_type
LEFT OUTER JOIN visit ON encounter.visit_id = visit.visit_id
LEFT OUTER JOIN visit_type ON visit.visit_type_id = visit_type.visit_type_id
LEFT OUTER JOIN location ON encounter.location_id = location.location_id;

CREATE OR REPLACE VIEW visit_view AS
SELECT 
visit.*,
visit_type.name visit_type_name
FROM visit
JOIN visit_type ON visit.visit_type_id = visit_type.visit_type_id;


CREATE OR REPLACE VIEW patient_diagnosis_view AS
SELECT distinct 
diagnois_obs.value_coded AS diagnois_concept_id,
diagnois_obs.person_id,
diagnois_obs.value_concept_full_name AS name,
certainity_obs.value_concept_full_name AS certainity,
order_obs.value_concept_full_name AS `order`,
status_obs.value_concept_full_name AS status,
diagnois_obs.obs_datetime,
encounter_view.encounter_id,
encounter_view.visit_id,
encounter_view.visit_type_name,
encounter_view.visit_type_id
FROM valid_coded_obs_view AS diagnois_obs
JOIN obs AS diagnosis_parent_obs ON diagnois_obs.concept_full_name = 'Coded Diagnosis' AND diagnois_obs.obs_group_id = diagnosis_parent_obs.obs_id
JOIN valid_coded_obs_view AS certainity_obs ON certainity_obs.obs_group_id = diagnosis_parent_obs.obs_id AND certainity_obs.concept_full_name = 'Diagnosis Certainty'
JOIN valid_coded_obs_view AS order_obs ON order_obs.obs_group_id = diagnosis_parent_obs.obs_id AND order_obs.concept_full_name = 'Diagnosis Order'
LEFT OUTER JOIN valid_coded_obs_view AS status_obs ON status_obs.obs_group_id = diagnosis_parent_obs.obs_id AND status_obs.concept_full_name = 'Bahmni Diagnosis Status'
LEFT OUTER JOIN encounter_view ON encounter_view.encounter_id = diagnois_obs.encounter_id;

CREATE OR REPLACE VIEW confirmed_patient_diagnosis_view AS
SELECT * FROM patient_diagnosis_view 
WHERE (patient_diagnosis_view.status IS NULL OR patient_diagnosis_view.status != 'Ruled Out Diagnosis')
	AND patient_diagnosis_view.certainity = 'Confirmed';

CREATE OR REPLACE VIEW diagnosis_concept_view AS
SELECT 
concept_view.*,
concept_reference_term_map_view.code as icd10_code
FROM concept_view 
LEFT OUTER JOIN concept_reference_term_map_view ON concept_reference_term_map_view.concept_id = concept_view.concept_id 
				AND concept_reference_term_map_view.concept_reference_source_name = 'ICD 10 - WHO'
				AND concept_reference_term_map_view.concept_map_type_name = 'SAME-AS'
WHERE concept_class_name = 'Diagnosis';

create or replace view concept_reference_view as
select
concept_reference_term.concept_reference_term_id as concept_reference_term_id,
concept_reference_term.name as concept_reference_term_name,
concept_reference_term.code as concept_reference_term_code,
concept_reference_source.name as concept_reference_source_name
from concept_reference_term, concept_reference_source
where
concept_reference_term.concept_source_id = concept_reference_source.concept_source_id;

create or replace view concept_children_view as
select
parent.concept_id as parent_concept_id,
parent.concept_class_name as parent_concept_class_name,
parent.concept_full_name as parent_concept_name,
child.concept_id as child_concept_id,
child.concept_class_name as child_concept_class_name,
child.concept_full_name as child_concept_name
from concept_view parent
LEFT OUTER JOIN concept_set ON parent.concept_id = concept_set.concept_set
LEFT OUTER JOIN concept_view child ON child.concept_id = concept_set.concept_id;


create or replace view labtest_panel_department_view as
select
concept_view.concept_full_name as test_concept_name,
concept_view.concept_id as test_concept_id,
panel.parent_concept_name as panel_concept_name,
panel.parent_concept_id as panel_concept_id,
department.parent_concept_name as department_concept_name,
department.parent_concept_id as department_concept_id
from concept_view
left outer join concept_children_view panel
on concept_view.concept_id = panel.child_concept_id AND panel.parent_concept_class_name='Labset'
inner join concept_children_view department
on concept_view.concept_id = department.child_concept_id AND department.parent_concept_class_name='Department'
where concept_view.concept_class_name='Test';


create or replace view concept_answer_view as
select
question_concept_view.concept_id as question_concept_id,
question_concept_view.concept_class_name as question_concept_class_name,
question_concept_view.concept_full_name as question_concept_name,
answer_concept_view.concept_id as answer_concept_id,
answer_concept_view.concept_class_name as answer_concept_class_name,
answer_concept_view.concept_full_name as answer_concept_name
from concept_view question_concept_view, concept_view answer_concept_view, concept_answer
where
question_concept_view.concept_id = concept_answer.concept_id
and answer_concept_view.concept_id = concept_answer.answer_concept;

create or replace view obs_view as
select
concept_view.*,
obs.obs_id as obs_id,
obs.value_text as value_text,
obs.value_datetime as value_datetime,
obs.value_numeric as value_numeric,
obs.value_coded as value_coded,
obs.value_boolean as value_boolean,
obs.obs_group_id as obs_group_id,
obs.person_id as person_id,
obs.encounter_id as encounter_id,
obs.obs_datetime as obs_datetime
from obs, concept_view
where
obs.concept_id = concept_view.concept_id;

create or replace view radiology_view as
select
concept_children_view.child_concept_id as concept_id,
concept_children_view.child_concept_name as name
from concept_children_view
where parent_concept_name = 'Radiology';

create or replace view radiology_result_view as
select
file_obs.person_id as person_id,
radiology_view.name as name,
file_obs.value_text as file_name
from obs_view file_obs, obs_view radiology_obs, radiology_view
where
file_obs.concept_full_name = 'Document' and
file_obs.obs_group_id = radiology_obs.obs_id and
radiology_obs.concept_id = radiology_view.concept_id;