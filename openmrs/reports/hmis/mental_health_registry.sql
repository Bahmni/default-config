SELECT ID, `name`, age, gender, vdc, district, diag, 
 recent_visit as `Last visit date`, `New or f/u`, baseline_date, baseline, recent_date, recent,
CONCAT(ROUND((-(recent-baseline)/baseline)*100,0),"%") as `% PHQ Improvement`,
IF(ROUND((-(recent-baseline)/baseline)*100,0)>=50, 'Y', 'N') as `PHQ Change >= 50%`,
if (recent < 5, 'Y', 'N') as `Recent PHQ < 5`, drug, Recommendations, rationale, `patient_hist`, hhv_consent
from (

SELECT reg.ID, reg.age, reg.gender, reg.diag, reg.`name`, reg.vdc, reg.district, recent_visit,
	-- SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT date(ov.obs_datetime),':',ov.value_numeric ORDER BY date(ov.obs_datetime) ASC), ',', 1 ) as xx,
	SUBSTR(SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT date(ov.obs_datetime),':',ov.value_numeric ORDER BY date(ov.obs_datetime) ASC), ':', 1 ), -10) as `baseline_date`,
	SUBSTR(SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT date(ov.obs_datetime),':',ov.value_numeric ORDER BY date(ov.obs_datetime) ASC), ',', 1 ) FROM 12) as `baseline`,
	IF (char_length(group_concat(distinct date(ov.obs_datetime),':',ov.value_numeric)) < 15, NULL, 
		SUBSTR(SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT date(ov.obs_datetime),':',ov.value_numeric ORDER BY date(ov.obs_datetime) ASC), ',', -1 ), 1, 10)) as `recent_date`,
    IF (char_length(group_concat(distinct date(ov.obs_datetime),':',ov.value_numeric)) < 15, NULL, 
		SUBSTR(SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT date(ov.obs_datetime),':',ov.value_numeric ORDER BY date(ov.obs_datetime) ASC), ',', -1 ) FROM 12)) as `recent`,
	GROUP_CONCAT(DISTINCT (SELECT name from drug where drug_id = dord.drug_inventory_id),' ',
		(SELECT name from concept_name where of.concept_id = concept_id and voided = 0 and concept_name_type = 'FULLY_SPECIFIED'),' ',
         dord.duration,' ',(select name from concept_name where dord.duration_units = concept_id and voided = 0 and concept_name_type = 'FULLY_SPECIFIED') SEPARATOR '||') as drug,
	(SELECT GROUP_CONCAT(date(obs_datetime), ':', value_text) from obs where obs_id = ov2.obs_id and voided = 0 order by obs_datetime desc) as `Recommendations`,
	(SELECT GROUP_CONCAT(date(obs_datetime), ':', value_text) from obs where obs_id = ov3.obs_id and voided = 0 order by obs_datetime desc limit 1) as `Rationale`,
    (SELECT GROUP_CONCAT(date(obs_datetime), ':', value_text) from obs where obs_id = ov4.obs_id and voided = 0 order by obs_datetime desc limit 1) as `Patient_Hist`,
	(SELECT GROUP_CONCAT(date(obs_datetime), ':', value_text) from obs where obs_id = ov5.obs_id and voided = 0 order by obs_datetime desc limit 1) as `HHV_Consent`,
    IF (reg.v_cnt >1, 'F/U', 'New') as `New or f/u`


 FROM   
 (SELECT   pi.identifier AS 'ID', p.person_id,
   TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS age,
   p.gender, CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name) as `name`, pa.city_village as VDC, pa.county_district as district,
   GROUP_CONCAT(distinct vcov.value_concept_full_name SEPARATOR ',') as diag,
   MAX(date(v.date_started)) as recent_visit, count(distinct v.visit_id) as v_cnt
  FROM
     person p
    INNER JOIN patient_identifier pi ON p.person_id = pi.patient_id
     AND pi.identifier != 'BAH200052'
	 AND pi.identifier like 'BAH%'
	 AND pi.voided = 0
     AND p.voided = 0
	INNER JOIN
     person_name pn ON pn.person_id = p.person_id
     and pn.voided = 0
	INNER JOIN
     person_address pa ON pa.person_id = p.person_id
     and pa.voided = 0
    INNER JOIN
     valid_coded_obs_view vcov ON vcov.person_id = p.person_id
     AND vcov.concept_full_name =  "Coded Diagnosis "
    INNER JOIN
     concept_children_view ccv ON ccv.child_concept_id = vcov.value_coded
     AND ccv.parent_concept_name = 'Mental Health Related Problems'
    INNER JOIN visit v ON v.patient_id = p.person_id
     AND v.voided = 0
	 AND v.visit_type_id not in (7, 11)
	 AND date(v.date_started) <= '#endDate#'
  GROUP BY ID
     ) reg
  LEFT JOIN obs_view ov ON ov.person_id = reg.person_id and ov.voided = 0 and ov.concept_full_name =  "Depression-PHQ9 Total"
     LEFT JOIN orders ord ON ord.patient_id = reg.person_id and ord.order_type_id = 2 and ord.voided = 0 and (date(ord.auto_expire_date) > CURDATE()  OR date(ord.date_created) = reg.recent_visit) 
     INNER JOIN drug_order dord ON dord.order_id = ord.order_id
     INNER JOIN order_frequency of ON dord.frequency = of.order_frequency_id
     LEFT JOIN obs_view ov2 ON ov2.person_id = reg.person_id and ov2.voided = 0 and ov2.concept_full_name =  "Psychiatrist's Rec, Recommendation"
  LEFT JOIN obs_view ov3 ON ov3.person_id = reg.person_id and ov3.voided = 0 and ov3.concept_full_name =  "Psychiatrist's Rec, Reasoning/rationale"
    LEFT JOIN obs_view ov4 ON ov4.person_id = reg.person_id and ov4.voided = 0 and ov4.concept_full_name =  "Depression-Patient History"
    LEFT JOIN obs_view ov5 ON ov5.person_id = reg.person_id and ov5.voided = 0 and ov5.concept_full_name =  "Depression-Consent for Household Visit"
  WHERE reg.recent_visit between '#startDate#' and '#endDate#'
GROUP BY reg.ID
) x	
