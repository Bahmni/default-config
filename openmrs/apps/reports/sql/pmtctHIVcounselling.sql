-- HIV Counseling  and Testing at Maternity

SELECT
  'Mothers delivered in this facility (Total)' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Known positive status at admision into maternity ' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Known positive status at\nadmision into maternity on ART' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Women of Unknown HIV Status at\nadmission into maternity' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Women of unknown status tested for HIV in maternity' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Women of unknown status testing HIV positive at maternity' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'women testing HIV positive in maternity started on ART (new)' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Total of HIV positive women delivered ' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Infants started on Nevirapine Prohylaxis  ' as 'Title',
  count(unkownage) as 'Unknown age',
  count(tenTofourteen) as '10-14 YRS',
  count(fifteenTonineteen) as '15-19 YRS',
  count(twentyTotwentyfour) as '20-24 YRS',
  count(twentyfiveTotwentynine) as '25-29 YRS',
  count(thirtyTothirtyfour) as '30-34 YRS',
  count(thirtyfiveTothirtynine) as '35-39 YRS',
  count(fourtyToFourtyfour) as '40-44 YRS',
  count(fourtyfiveToFourtynine) as '45-49 YRS',
  count(overFifty) as '50+ YRS',
  count(totalAll) as 'Total'

FROM (
  SELECT
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitNumberResult is not null) THEN 1 END unkownage,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 10 and 14 and gender = 'F' and visitNumberResult is not null) THEN 1 END tenTofourteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 15 and 19 and gender = 'F' and visitNumberResult is not null) THEN 1 END fifteenTonineteen,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 20 and 24 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyTotwentyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 25 and 29 and gender = 'F' and visitNumberResult is not null) THEN 1 END twentyfiveTotwentynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 30 and 34 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyTothirtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 35 and 39 and gender = 'F' and visitNumberResult is not null) THEN 1 END thirtyfiveTothirtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 40 and 44 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyToFourtyfour,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 45 and 49 and gender = 'F' and visitNumberResult is not null) THEN 1 END fourtyfiveToFourtynine,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 50 and 100 and gender = 'F'and visitNumberResult is not null) THEN 1 END overFifty,
    CASE WHEN (TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) between 0 and 100 and gender = 'F' and visitNumberResult is not null) THEN 1 END totalAll
   
  FROM visit v
  JOIN person pn on pn.person_id = v.patient_id 
  JOIN person_attribute pa on pa.person_id = pn.person_id and pa.value in (select concept_id from concept_name where name in ("HeiRelationship", "ExistingHeiRelationship" ))
  JOIN person_attribute_type pat on (pat.person_attribute_type_id = pa.person_attribute_type_id and pat.retired = 0 and pat.name = "TypeofPatient")
  LEFT JOIN (SELECT distinct v.patient_id AS 'visitPatientId', o.value_datetime AS 'visitNumberResult' FROM obs o 
  JOIN concept_name cn ON (cn.concept_name_type = "FULLY_SPECIFIED" AND cn.voided is false AND cn.name="Date of ARV Prophylaxis Start" and o.concept_id = cn.concept_id) 
  JOIN encounter enc ON enc.encounter_id = o.encounter_id 
  JOIN visit v ON v.visit_id = enc.visit_id  
  GROUP BY v.patient_id 
  ORDER BY v.visit_id DESC) AS vr ON (vr.visitPatientId = pn.person_id)
) p

UNION ALL

SELECT
  'Infants linked to HEI Care ' as 'Title',
    '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'Not Assesed' as 'Title',
  '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual

UNION ALL

SELECT
  'TB RX' as 'Title',
  '' as 'Unknown age',
  ''as '10-14 YRS',
  '' as '15-19 YRS',
  '' as '20-24 YRS',
  '' as '25-29 YRS',
  '' as '30-34 YRS',
  '' as '35-39 YRS',
  '' as '40-44 YRS',
  '' as '45-49 YRS',
  '' as '50+ YRS',
  '' as 'Total'
from  dual


