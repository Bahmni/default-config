SELECT
    first_question.id,
    first_question.test_name AS dhisname,
    first_concept.department AS department,
    first_concept.test AS ehrname,
    first_concept.testid as ehr_id,
	COUNT(first_concept.rid),
            
    CASE
        WHEN
            first_concept.testid IN (SELECT 
                    first_concept.testid
                FROM
                    clinlims.test_result
               )
        THEN
            COUNT(first_concept.tid)
        ELSE 0
    END AS positive,
    CASE
        WHEN
            first_concept.testid IN (SELECT 
                    first_concept.testid
                FROM
                    clinlims.test_result
               )
        THEN
            COUNT(first_concept.fid)
        ELSE 0
    END AS negative
FROM
    (SELECT * FROM clinlims.dhis2_test) first_question
        LEFT JOIN clinlims.dhis2_lab_test second_question ON second_question.dhis_test_id = first_question.id
        LEFT JOIN
    (SELECT DISTINCT
        t.name AS test,
            ts.name AS department,
            t.id AS testid,
            count(r.id) AS rid,
	    (CASE WHEN r.value != '' AND r.abnormal = TRUE THEN r.id ELSE NULL END) AS tid,
	(CASE WHEN r.value != '' AND r.abnormal = FALSE THEN r.id ELSE NULL END) AS fid
    FROM
        clinlims.test_section ts
    LEFT JOIN clinlims.test t ON ts.id = t.test_section_id
        AND t.is_active = 'Y'
    LEFT  JOIN clinlims.analysis a ON t.id = a.test_id
	
    inner  JOIN clinlims.result r ON a.id = r.analysis_id
        AND CAST(r.lastupdated AS DATE) BETWEEN '#startDate#' AND '#endDate#'
        AND r.value != ''
    GROUP BY testid , test , tid , fid , department) first_concept ON first_concept.testid = second_question.ehr_test_id
GROUP BY first_question.id ,first_question.test_name , first_concept.department , first_concept.test , first_concept.testid , first_question.test_name,second_question.ehr_test_id
ORDER BY first_question.id ,first_question.test_name , first_concept.department , first_concept.test , first_concept.testid , first_question.test_name
