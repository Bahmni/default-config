SELECT
  'New patients enrolled in HIV care'        AS 'Anteretroviral Treatment : Status of HIV Care',
  'During'                                   AS 'of this Month',
  ifnull(sum(if(age > 15
                AND gender = 'F', 1, 0)), 0) AS 'Adult - F',
  ifnull(sum(if(age > 15
                AND gender = 'M', 1, 0)), 0) AS 'Adult - M',
  ifnull(sum(if(age > 15
                AND gender NOT IN ('M', 'F'), 1, 0)),
         0)                                  AS 'Adult - TG',
  ifnull(sum(if(age < 1
                AND gender = 'M', 1, 0)),
         0)                                  AS 'Male child - < 1',
  ifnull(sum(if((age BETWEEN 1 AND 5)
                AND gender = 'M', 1, 0)),
         0)                                  AS 'Male child - 1-4',
  ifnull(sum(if((age BETWEEN 5 AND 15)
                AND gender = 'M', 1, 0)),
         0)                                  AS 'Male child - 5-14',
  ifnull(sum(if(age < 1
                AND gender = 'F', 1, 0)),
         0)                                  AS 'Female child - < 1',
  ifnull(sum(if((age BETWEEN 1 AND 5)
                AND gender = 'F', 1, 0)),
         0)                                  AS 'Female child - 1-4',
  ifnull(sum(if((age BETWEEN 5 AND 15)
                AND gender = 'F', 1, 0)),
         0)                                  AS 'Female child - 5-14'
FROM

  (SELECT
     enrolled_obs.person_id,
     datediff(DATE(enrolled_obs.obs_datetime), p.birthdate) / 365 AS age,
     p.gender

   FROM obs enrolled_obs
     JOIN concept_view enrolled_concept
       ON enrolled_concept.concept_id = enrolled_obs.concept_id
          AND enrolled_concept.concept_full_name = 'HIVTC, HIV care enrolled date'
          AND enrolled_obs.voided = 0
          AND DATE (enrolled_obs.obs_datetime) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE)
     LEFT JOIN person p ON p.person_id = enrolled_obs.person_id AND p.voided = 0
  ) AS t2;
