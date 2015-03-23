SELECT
  'Patients medically eligible for ART but have not started' AS 'Anteretroviral Treatment : Status of HIV Care',
  'End'                                                      AS 'of this Month',
  ifnull(sum(if(age > 15
                AND gender = 'F', 1, 0)), 0)                 AS 'Adult - F',
  ifnull(sum(if(age > 15
                AND gender = 'M', 1, 0)), 0)                 AS 'Adult - M',
  ifnull(sum(if(age > 15
                AND gender NOT IN ('M', 'F'), 1, 0)), 0)     AS 'Adult - TG',
  ifnull(sum(if(age < 1
                AND gender = 'M', 1, 0)), 0)                 AS 'Male child - < 1',
  ifnull(sum(if((age BETWEEN 1 AND 5)
                AND gender = 'M', 1, 0)), 0)                 AS 'Male child - 1-4',
  ifnull(sum(if((age BETWEEN 5 AND 15)
                AND gender = 'M', 1, 0)), 0)                 AS 'Male child - 5-14',
  ifnull(sum(if(age < 1
                AND gender = 'F', 1, 0)), 0)                 AS 'Female child - < 1',
  ifnull(sum(if((age BETWEEN 1 AND 5)
                AND gender = 'F', 1, 0)), 0)                 AS 'Female child - 1-4',
  ifnull(sum(if((age BETWEEN 5 AND 15)
                AND gender = 'F', 1, 0)), 0)                 AS 'Female child - 5-14'
FROM
  (SELECT
     eligible_obs.person_id,
     datediff(eligible_obs.obs_datetime, p.birthdate) / 365 AS 'age',
     p.gender
   FROM obs eligible_obs
     JOIN person p ON eligible_obs.person_id = p.person_id
     JOIN concept_view eligible_concept
       ON eligible_concept.concept_id = eligible_obs.concept_id
          AND eligible_concept.concept_full_name = 'HIVTC, ART eligible date'
          AND eligible_obs.voided = 0
          AND DATE(eligible_obs.value_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
          AND eligible_obs.person_id NOT IN
              (SELECT person_id
               FROM obs start_date_obs
                 JOIN concept_view start_date_concept
                   ON start_date_concept.concept_id = start_date_obs.concept_id
                      AND start_date_concept.concept_full_name = 'HIVTC, ART start date'
                      AND start_date_obs.voided = 0
                      AND start_date_obs.value_datetime IS NOT NULL
                      AND DATE(obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
              )
   GROUP BY eligible_obs.person_id) AS t7