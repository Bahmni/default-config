SELECT 'New patients enrolled in HIV care' AS 'Anteretroviral Treatment : Status of HIV Care',
       'During' AS 'of this Month',
       ifnull(sum(if(age>15
                     AND gender='F',1,0)),0) AS 'Adult - F',
       ifnull(sum(if(age>15
                     AND gender='M',1,0)),0) AS 'Adult - M',
       ifnull(sum(if(age>15
                     AND gender NOT IN ('M','F'),1,0)),0) AS 'Adult - TG',
       ifnull(sum(if(age<1
                     AND gender='M',1,0)),0) AS 'Male child - < 1',
       ifnull(sum(if((age BETWEEN 1 AND 5)
                     AND gender='M',1,0)),0) AS 'Male child - 1-4',
       ifnull(sum(if((age BETWEEN 5 AND 15)
                     AND gender='M',1,0)),0) AS 'Male child - 5-14',
       ifnull(sum(if(age<1
                     AND gender='F',1,0)),0) AS 'Female child - < 1',
       ifnull(sum(if((age BETWEEN 1 AND 5)
                     AND gender='F',1,0)),0) AS 'Female child - 1-4',
       ifnull(sum(if((age BETWEEN 5 AND 15)
                     AND gender='F',1,0)),0) AS 'Female child - 5-14',
       ifnull(sum(if(person_id IN
                       (SELECT person_id
                        FROM person_ids
                        WHERE concept_full_name = 'HIVTC, Risk Group'
                          AND value_concept_full_name = 'Sex Worker'
                          AND gender='F'
                          AND DATE(obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
                        GROUP BY person_id),1,0)),0) AS 'FSW',
       ifnull(sum(if(person_id IN
                       (SELECT person_id
                        FROM person_ids
                        WHERE concept_full_name = 'HIVTC, Risk Group'
                          AND value_concept_full_name = 'People Who Inject Drugs'
                          AND DATE(obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
                        GROUP BY person_id),1,0)),0) AS 'IDU',
       ifnull(sum(if(person_id IN
                       (SELECT person_id
                        FROM person_ids
                        WHERE concept_full_name = 'HIVTC, Risk Group'
                          AND value_concept_full_name = 'MSM and Transgenders'
                          AND DATE(obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
                        GROUP BY person_id),1,0)),0) AS 'MSM',
       ifnull(sum(if(person_id IN
                       (SELECT person_id
                        FROM person_ids
                        WHERE concept_full_name = 'HIVTC, Risk Group'
                          AND value_concept_full_name = 'Migrant'
                          AND DATE(obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
                        GROUP BY person_id),1,0)),0) AS 'Migrant',
       ifnull(sum(if(person_id IN
                       (SELECT person_id
                        FROM person_ids
                        WHERE concept_full_name = 'HIVTC, Risk Group'
                          AND value_concept_full_name NOT IN ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs')
                          AND DATE(obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
                        GROUP BY person_id),1,0)),0) AS 'Others'
FROM
  (SELECT o.person_id,
          datediff(DATE(o.obs_datetime),DATE(p.birthdate))/365 AS 'age',
          p.gender
   FROM obs_view o
   INNER JOIN person p ON o.person_id = p.person_id AND p.voided = 0
   WHERE o.concept_full_name='HIVTC, HIV care enrolled date' AND o.voided = 0
     AND DATE(o.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
   GROUP BY o.person_id) AS t2