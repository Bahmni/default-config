SELECT 
    reg.ID, reg.age, reg.gender, reg.diag, reg.first_diag_date, reg.recent_visit,
    group_concat(distinct date(ov.obs_datetime),':',ov.value_numeric) as `PHQ9 Hist`,
    group_concat(distinct (select name from drug where drug_id = dord.drug_inventory_id),' ',
		(select name from concept_name where of.concept_id = concept_id and voided = 0 and concept_name_type = 'FULLY_SPECIFIED'),' ',
        dord.duration,' ',
		(select name from concept_name where dord.duration_units = concept_id and voided = 0 and concept_name_type = 'FULLY_SPECIFIED') SEPARATOR '||') as drug,
	(select group_concat(date(obs_datetime), ':', value_text) from obs where obs_id = ov2.obs_id and voided = 0 order by obs_datetime desc limit 1) as `Latest reco`
	
FROM 
	(SELECT
		pi.identifier AS 'ID', p.person_id,
		TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS age,
		p.gender,
		group_concat(distinct vcov.value_concept_full_name SEPARATOR ',') as diag,
		min(date(vcov.obs_datetime)) as first_diag_date,
        -- (select max(date(date_started)) from visit where patient_id = p.person_id and date(date_started) < max(date(v.date_started)) and voided = 0) as previous_visit,
		max(date(v.date_started)) as recent_visit
	FROM
	   person p
			INNER JOIN patient_identifier pi ON p.person_id = pi.patient_id
				AND pi.identifier != 'BAH200052'
				AND pi.preferred = 1
				AND pi.voided = 0
				AND p.voided = 0
			INNER JOIN
				valid_coded_obs_view vcov ON vcov.person_id = p.person_id
				AND vcov.concept_full_name = "Coded Diagnosis"
			INNER JOIN
				concept_children_view ccv ON ccv.child_concept_id = vcov.value_coded
				AND ccv.parent_concept_name = 'Mental Health Related Problems'
			LEFT JOIN visit v ON v.patient_id = p.person_id
				AND v.voided = 0
                AND v.visit_type_id not in (7, 11)
	GROUP BY ID
    ) reg
	LEFT JOIN obs_view ov ON ov.person_id = reg.person_id and ov.voided = 0 and ov.concept_full_name = "Depression-PHQ9 Total"
    LEFT JOIN orders ord ON ord.patient_id = reg.person_id and ord.order_type_id = 2 and ord.voided = 0 and (date(ord.auto_expire_date) > CURDATE()  OR date(ord.date_created) = reg.recent_visit) 
    INNER JOIN drug_order dord ON dord.order_id = ord.order_id
    INNER JOIN order_frequency of ON dord.frequency = of.order_frequency_id
    LEFT JOIN obs_view ov2 ON ov2.person_id = reg.person_id and ov2.voided = 0 and ov2.concept_full_name = "Psychiatrist's Rec, Recommendation"
WHERE reg.recent_visit between "#startDate#" and "#endDate#"
GROUP BY reg.ID
;