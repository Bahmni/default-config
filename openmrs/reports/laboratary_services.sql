-- Parameters
SET @start_date = '2014-05-01';
SET @end_date = '2014-06-01';
SET @lab_test_order_type = '3';

-- Query
SELECT test_details.department_concept_name AS Department, test_details.panel_concept_name AS Panel, test_details.test_concept_name AS Test, test_details.test_concept_id,
COUNT(DISTINCT orders.order_id) AS 'Total', 
SUM(CASE WHEN obs.value_text = 'Positive' THEN 1 ELSE 0 END) AS '+ve',
SUM(CASE WHEN obs.value_text = 'Negative' THEN 1 ELSE 0 END) AS '-ve'
FROM 
labtest_panel_department_view AS test_details
LEFT OUTER JOIN orders
ON test_details.test_concept_id = orders.concept_id AND orders.order_type_id = @lab_test_order_type  
LEFT OUTER JOIN obs
ON orders.order_id = obs.order_id AND orders.concept_id = obs.concept_id
WHERE obs.obs_datetime BETWEEN @start_date AND @end_date
GROUP BY Department, Panel, Test;
