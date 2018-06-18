SELECT DISTINCT
    first_question.dhis_test_name AS dhisname,
    first_question.ehr_test_name AS ehr_2,
    first_concept.department AS department,
    first_concept.test AS ehrname,
    CASE
        WHEN
            first_concept.testid IN (SELECT 
                    first_concept.testid
                FROM
                    clinlims.test_result)
        THEN
            COUNT(first_concept.testid)
        ELSE 0
    END AS total_count,
    CASE
        WHEN
            first_concept.testid IN (SELECT 
                    first_concept.testid
                FROM
                    clinlims.test_result
                WHERE
                    tst_rslt_type = 'D')
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
                WHERE
                    tst_rslt_type = 'D')
        THEN
            COUNT(first_concept.fid)
        ELSE 0
    END AS negative
FROM
    (SELECT DISTINCT
        ehr_test_name, dhis_test_name
    FROM
        clinlims.dhis2_lab_test) first_question
        LEFT JOIN
    (SELECT DISTINCT
        t.name AS test,
            r1.id AS tid,
            r2.id AS fid,
            ts.name AS department,
            t.id AS testid
    FROM
        clinlims.test_section ts
    INNER JOIN clinlims.test t ON ts.id = t.test_section_id
        AND t.is_active = 'Y'
    LEFT OUTER JOIN clinlims.analysis a ON t.id = a.test_id
    LEFT OUTER JOIN clinlims.result r ON a.id = r.analysis_id
        AND CAST(r.lastupdated AS DATE) BETWEEN '#startDate#' AND '#endDate#'
        AND r.value != ''
    LEFT OUTER JOIN clinlims.result r1 ON r1.result_type = 'D' AND r1.value != ''
        AND r.id = r1.id
        AND r1.abnormal = TRUE
    LEFT OUTER JOIN clinlims.result r2 ON r2.result_type = 'D' AND r2.value != ''
        AND r.id = r2.id
        AND r2.abnormal = FALSE
    GROUP BY testid , test , tid , fid , department) first_concept ON first_concept.test = first_question.ehr_test_name
GROUP BY first_question.dhis_test_name , first_concept.department , first_concept.test , first_concept.testid , first_question.ehr_test_name
ORDER BY first_question.dhis_test_name, first_concept.department