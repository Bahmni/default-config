SELECT DISTINCT
    final.ethnicity as caste,
    count(CASE WHEN final.male != 0 then final.male end) AS Male,
    count(CASE WHEN  final.female != 0 then final.female end) AS Female,
    count(CASE WHEN final.others != 0 then final.others end) AS Others
FROM
    (  SELECT
        de.description as ethnicity,
        count(CASE WHEN first.gen = 'M' AND de.description=first.pd THEN first.ppid END) AS male,
        count(CASE WHEN first.gen = 'F' AND de.description=first.pd THEN first.ppid END) AS female,
        count(CASE WHEN first.gen = 'O' AND de.description=first.pd THEN first.ppid END) AS others

    from (SELECT
            DISTINCT t.id AS testid,
            r.id AS rid,
            p.id as ppid,
            per.first_name as fname,
            per.last_name as lname,
            a.completed_date as updated,
            p.gender as gen,
            pi.identity_data as pd,
            pi.Identity_type_id as iti
        FROM
            clinlims.test t
            INNER JOIN clinlims.analysis a ON t.id = a.test_id
            inner join clinlims.sample_item si on si.id = a.sampitem_id
            INNER JOIN clinlims.sample_human sh ON sh.samp_id = si.samp_id
            INNER JOIN clinlims.patient p ON p.id = sh.patient_id
            INNER JOIN clinlims.result r ON a.id = r.analysis_id
            INNER JOIN clinlims.person per ON p.person_id = per.id
            INNER JOIN clinlims.patient_identity pi ON p.id = pi.patient_id
            INNER JOIN clinlims.patient_identity_type pit ON pi.identity_type_id = pit.id and pi.identity_type_id=37
			  AND t.name IN ('HIV (Blood)','HIV (Serum)')
			  AND r.value != ''
                AND r.result_type = 'D'
                AND r.abnormal = TRUE

        where 
        CAST(a.completed_date AS DATE) BETWEEN DATE('#startDate#')
        AND DATE('#endDate#')
        GROUP BY
        testid,
        rid,
        ppid,
        fname,
        lname,
        updated,
        gen,
        pd,
        iti) as first
        RIGHT JOIN clinlims.ethnicity de on 1=1
    group BY
        ethnicity,
        first.gen, first.ppid,testid
    order by ethnicity
      ) final

Group by final.ethnicity
order by final.ethnicity