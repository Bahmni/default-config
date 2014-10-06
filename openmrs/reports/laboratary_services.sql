-- Parameters
SET @start_date = '2014-09-01';
SET @end_date = '2014-11-01';

/*SELECT lab_parent.child_concept_name as Department
FROM concept_children_view AS lab_parent
INNER JOIN concept_children_view AS
WHERE lab_parent.parent_concept_name = 'Lab Departments'*/

SELECT lab_parent.child_concept_name as Department
FROM concept_children_view AS lab_parent
LEFT OUTER JOIN concept_children_view AS
WHERE lab_parent.parent_concept_name = 'Lab Departments'