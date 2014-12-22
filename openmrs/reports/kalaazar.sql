-- Kala-azar report
-- Parameters
SET @start_date = '2014-11-01';
SET @end_date = '2014-12-30';
-- Query

-- Define concept sets and children : Patient Origin Type : Within District, Outside District, Foreigner

-- Age/Sex, Treatment
SELECT
origin_types.child_concept_name AS 'Patient Type',
SUM(IF(Age < 5 && gender = 'F',1,0)) AS 'Female, < 5 Years',
SUM(IF(Age < 5 && gender = 'M',1,0)) AS 'Male, < 5 Years',
SUM(IF(Age >= 5 && gender = 'F',1,0)) AS 'Female, >= 5 Years',
SUM(IF(Age >= 5 && gender = 'M',1,0)) AS 'Male, >= 5 Years',
SUM(IF(drug_category = 'category1',1,0)) AS 'Treated with - Liposomal Amphotericin B/Miltefosine',
SUM(IF(drug_category = 'category2',1,0)) AS 'Treated with - Other'
FROM
(SELECT DISTINCT 
IF(county_district = 'Achham' && country = 'Nepal', 'Within District', IF(county_district != 'Achham' && country = 'Nepal', 'Outside District', IF(country != 'Nepal', 'Foreigner', null))) AS Origin,
person.person_id, person.gender,
TIMESTAMPDIFF(YEAR, person.birthdate, visit.date_started) AS Age,
IF(concept_view.concept_full_name = 'Amphotericin B' || concept_view.concept_full_name = 'Miltefosine' || concept_view.concept_full_name =  'Liposomal Amphotericine B', 'category1','category2') AS drug_category
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN person_address ON person_address.person_id = person.person_id
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN ('Malaria Kalaazar') 
INNER JOIN coded_obs_view ON coded_obs_view.person_id = person.person_id
	AND coded_obs_view.concept_full_name = 'Coded Diagnosis'
	AND coded_obs_view.value_concept_full_name IN ('Kala‐Azar')
    AND coded_obs_view.obs_datetime BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON coded_obs_view.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
 INNER JOIN orders ON orders.patient_id = person.person_id
 	AND orders.date_activated BETWEEN @start_date AND @end_date
     AND orders.order_action IN ('NEW', 'REVISED')
 INNER JOIN drug_order ON orders.order_id = drug_order.order_id
 INNER JOIN drug ON drug_order.drug_inventory_id = drug.drug_id
 INNER JOIN concept_view ON drug.concept_id = concept_view.concept_id
 AND concept_view.concept_full_name IN ('Amphotericin B', 'Miltefosine', 'Liposomal Amphotericine B', 'Sodium Stibogluconate')
    ) AS entries
RIGHT OUTER JOIN (SELECT child_concept_name FROM concept_children_view WHERE parent_concept_name = 'Patient Origin Type' ) AS origin_types ON entries.Origin = origin_types.child_concept_name
GROUP BY origin_types.child_concept_name;

-- Number of deaths
SELECT
origin_types.child_concept_name AS 'Patient Type',
SUM(IF(gender = 'F',1,0)) AS 'Female - No. of deaths',
SUM(IF(gender = 'M',1,0)) AS 'Male - No. of deaths'
FROM
(SELECT  
IF(county_district = 'Achham' && country = 'Nepal', 'Within District', IF(county_district != 'Achham' && country = 'Nepal', 'Outside District', IF(country != 'Nepal', 'Foreigner', null))) AS Origin,
person.person_id, person.gender
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND visit.date_started BETWEEN @start_date AND @end_date
INNER JOIN person_address ON person_address.person_id = person.person_id
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN ('Malaria Kalaazar, Death Date')
    AND DATE(value_datetime) BETWEEN  @start_date AND @end_date) AS entries
RIGHT OUTER JOIN (SELECT child_concept_name FROM concept_children_view WHERE parent_concept_name = 'Patient Origin Type' ) AS origin_types ON entries.Origin = origin_types.child_concept_name
GROUP BY origin_types.child_concept_name;



