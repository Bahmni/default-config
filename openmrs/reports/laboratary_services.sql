-- Parameters
SET @start_date = '2014-08-01';
SET @end_date = '2014-11-01';
SET @lab_test_order_type = '3';
-- Query
SELECT test_details.test_department_name AS Department, test_details.test_panel_name AS Panel, test_details.test_name AS Test, test_details.test_concept_id,
COUNT(DISTINCT orders.order_id) AS 'Total',
SUM(CASE WHEN obs.value_text = 'Positive' THEN 1 ELSE 0 END) AS '+ve',
SUM(CASE WHEN obs.value_text = 'Negative' THEN 1 ELSE 0 END) AS '-ve'
FROM 
labtest_panel_department_view AS test_details
LEFT OUTER JOIN orders
ON test_details.test_concept_id = orders.concept_id AND orders.date_activated BETWEEN @start_date AND @end_date AND orders.order_type_id = @lab_test_order_type
LEFT OUTER JOIN obs
ON orders.order_id = obs.order_id AND orders.concept_id = obs.concept_id
GROUP BY Department, Panel, Test;