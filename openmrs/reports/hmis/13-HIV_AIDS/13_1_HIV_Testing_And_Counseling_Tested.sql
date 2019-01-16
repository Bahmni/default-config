SELECT 
entries .age AS 'HTC Programme-Tested',	
		SUM(entries.`Sex Worker-M`) AS 'Sex Worker-M',
        SUM(entries.`Sex Worker-F`) AS 'Sex Worker-F',		
        SUM(entries.`Sex Worker-TG`) AS 'Sex Worker-TG',
        SUM(entries.`Who Inject Drugs-M`) AS 'Who Inject Drugs-M',
		SUM(entries.`Who Inject Drugs-F`) AS 'Who Inject Drugs-F',		
        SUM(entries.`Who Inject Drugs-TG`) AS 'Who Inject Drugs-TG',		
        SUM(entries.`MSM and Transgenders-M`) AS 'MSM and Transgenders-M',
		SUM(entries.`MSM and Transgenders-F`) AS 'MSM and Transgenders-F',
		SUM(entries.`MSM and Transgenders-TG`) AS 'MSM and Transgenders-TG',
		SUM(entries.`Blood/Organ Recipient-M`) AS 'Blood/Organ Recipient-M',
		SUM(entries.`Blood/Organ Recipient-F`) AS 'Blood/Organ Recipient-F',		
        SUM(entries.`Blood/Organ Recipient-TG`) AS 'Blood/Organ Recipient-TG',
		SUM(entries.`Client of Sex Worker-M`) AS 'Client of Sex Worker-M',
		SUM(entries.`Client of Sex Worker-F`) AS 'Client of Sex Worker-F',		
        SUM(entries.`Client of Sex Worker-O`) AS 'Client of Sex Worker-O',		
        SUM(entries.`Migrant- M`) AS 'Migrant- M',
		SUM(entries.`Migrant- F`) AS 'Migrant- F',
        SUM(entries.`Migrant- TG`) AS 'Migrant- TG',
        SUM(entries.`Spouse of Migrant- M`) AS 'Spouse of Migrant- M',
		SUM(entries.`Spouse of Migrant- F`) AS 'Spouse of Migrant- F',
        SUM(entries.`Spouse of Migrant- TG`) AS 'Spouse of Migrant- TG',
        SUM(entries.`Others-M`) AS 'Others-M',
		SUM(entries.`Others-F`) AS 'Others-F',		        
        SUM(entries.`Others-TG`) AS 'Others-TG'
    
FROM
(SELECT age,
SUM(IF(report.risk_group = 'Sex Worker'&& report.gender = 'M',1,0)) AS 'Sex Worker-M',
		SUM(IF(report.risk_group = 'Sex Worker'&& report.gender = 'F',1,0)) AS 'Sex Worker-F',		
        SUM(IF(report.risk_group = 'Sex Worker'&& report.gender = 'O',1,0)) AS 'Sex Worker-TG',
        SUM(IF(report.risk_group = 'People Who Inject Drugs'&& report.gender = 'M',1,0)) AS 'Who Inject Drugs-M',
		SUM(IF(report.risk_group = 'People Who Inject Drugs'&& report.gender = 'F',1,0)) AS 'Who Inject Drugs-F',		
        SUM(IF(report.risk_group = 'People Who Inject Drugs'&& report.gender = 'O',1,0)) AS 'Who Inject Drugs-TG',		
        SUM(IF(report.risk_group = 'MSM and Transgenders'&& report.gender = 'M',1,0)) AS 'MSM and Transgenders-M',
		SUM(IF(report.risk_group = 'MSM and Transgenders'&& report.gender = 'F',1,0)) AS 'MSM and Transgenders-F',
		SUM(IF(report.risk_group = 'MSM and Transgenders'&& report.gender = 'O',1,0)) AS 'MSM and Transgenders-TG',
		SUM(IF(report.risk_group = 'Blood or Organ Recipient'&& report.gender = 'M',1,0)) AS 'Blood/Organ Recipient-M',
		SUM(IF(report.risk_group = 'Blood or Organ Recipient'&& report.gender = 'F',1,0)) AS 'Blood/Organ Recipient-F',		
        SUM(IF(report.risk_group = 'Blood or Organ Recipient'&& report.gender = 'O',1,0)) AS 'Blood/Organ Recipient-TG',
		SUM(IF(report.risk_group = 'Client of Sex Worker'&& report.gender = 'M',1,0)) AS 'Client of Sex Worker-M',
		SUM(IF(report.risk_group = 'Client of Sex Worker'&& report.gender = 'F',1,0)) AS 'Client of Sex Worker-F',		
        SUM(IF(report.risk_group = 'Client of Sex Worker'&& report.gender = 'O',1,0)) AS 'Client of Sex Worker-O',		
        SUM(IF(report.risk_group = 'Migrant'&& report.gender = 'M',1,0)) AS 'Migrant- M',
		SUM(IF(report.risk_group = 'Migrant'&& report.gender = 'F',1,0)) AS 'Migrant- F',
        SUM(IF(report.risk_group = 'Migrant'&& report.gender = 'O',1,0)) AS 'Migrant- TG',
        SUM(IF(report.risk_group = 'Spouse/Partner of Migrant'&& report.gender = 'M',1,0)) AS 'Spouse of Migrant- M',
		SUM(IF(report.risk_group = 'Spouse/Partner of Migrant'&& report.gender = 'F',1,0)) AS 'Spouse of Migrant- F',
        SUM(IF(report.risk_group = 'Spouse/Partner of Migrant'&& report.gender = 'O',1,0)) AS 'Spouse of Migrant- TG',
        SUM(IF(report.gender = 'M' && labCheck = 0 ||report .risk_group='Others' ,1,0)) AS 'Others-M',
		SUM(IF(report.gender = 'F' && labCheck = 0 ||report .risk_group = 'Others' ,1,0)) AS 'Others-F',		        
        SUM(IF(report.gender = 'O'&& labCheck = 0 ||report .risk_group = 'Others' ,1,0)) AS 'Others-TG'
FROM
(SELECT 
        patients.pid as ppid,
        tested_now.tid as ttid,
            tested_now.gender,
            patients.risk_group,
            IF(tested_now.tid = patients.pid,1,0) AS labCheck,
            IF(TIMESTAMPDIFF(YEAR, patients.birthdate, tested_now.startdate) <= 14, '≤ 14 Years', '> 15 years') AS age

    FROM
      
   (SELECT 
        person.person_id as tid,
        test_result.value_text AS test_result,
        visit.date_started as startdate,
        person.gender as gender
    FROM
        visit
    JOIN encounter ON visit.visit_id = encounter.visit_id
        AND DATE(visit.date_started) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs AS test_result ON test_result.encounter_id = encounter.encounter_id
        AND test_result.voided = 0
    INNER JOIN concept_view test_concept ON test_result.concept_id = test_concept.concept_id
        AND test_concept.concept_full_name IN ('HIV (Blood)' , 'HIV (Serum)')
    INNER JOIN person ON test_result.person_id = person.person_id) AS tested_now 
     
    LEFT JOIN
      (SELECT 
        person.person_id as pid,
            person.gender,
            person.birthdate,
            risk_group_values.concept_full_name AS risk_group,
            visit.date_started
    FROM
        visit
    JOIN encounter ON visit.visit_id = encounter.visit_id
        AND DATE(visit.date_started) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs AS risk_group ON risk_group.encounter_id = encounter.encounter_id
        AND risk_group.voided = 0
    INNER JOIN concept_view ON risk_group.concept_id = concept_view.concept_id
        AND concept_view.concept_full_name = 'HTC, Risk Group'
    INNER JOIN concept_view AS risk_group_values ON risk_group.value_coded = risk_group_values.concept_id
    INNER JOIN person ON risk_group.person_id = person.person_id) AS patients ON tested_now.tid = patients.pid
    LEFT OUTER JOIN (SELECT 
        person.person_id,
            value_tested.concept_full_name AS previous_test_result
    FROM
        visit
    JOIN encounter ON visit.visit_id = encounter.visit_id
        AND DATE(visit.date_started) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs AS previously_tested ON previously_tested.encounter_id = encounter.encounter_id
        AND previously_tested.voided = 0
    INNER JOIN concept_view AS previously_tested_concept ON previously_tested.concept_id = previously_tested_concept.concept_id
        AND previously_tested_concept.concept_full_name = 'HTC, Result if tested'
    INNER JOIN concept_view AS value_tested ON value_tested.concept_id = previously_tested.value_coded
    INNER JOIN person ON previously_tested.person_id = person.person_id) AS tested_before ON patients.pid = tested_before.person_id
    
    )AS report 
   group by report .age
   UNION ALL SELECT '≤ 14 Years',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
UNION ALL SELECT '> 15 years',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
)entries
Group BY entries .age desc
;
