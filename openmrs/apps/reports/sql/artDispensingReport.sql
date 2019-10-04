select pa.value as 'Unique ART Number' , concat(coalesce(given_name, ''), "  ", coalesce(middle_name, ''), '', coalesce(family_name , '') ) as 'Client Name', e2.value as 'Clients Contact' ,
 gender as sex ,floor(datediff(curdate(),p.birthdate) / 365) as 'Age', o.date_created As Date,
GROUP_CONCAT(case when c.uuid = '13382e01-9f18-488b-b2d2-58ab54c82d82' and o.date_created BETWEEN DATE_FORMAT('#startDate#' , '%Y-%m-01 00:00:00')
AND DATE_FORMAT(LAST_DAY('#endDate#'), '%Y-%m-%d 23:59:59') then concat(dr.name," = (" , do.quantity , ") " , " " , cm.name) end) as RegimenNames,
GROUP_CONCAT(case when c.uuid in ('e2acae74-9559-49b7-a5a7-36b633a5427d','9844649e-0411-4011-a1f8-4a0da4155c76','f8c61966-0a8a-425f-858c-93dfabc1c82c') and o.date_created BETWEEN DATE_FORMAT('#startDate#', '%Y-%m-01 00:00:00')
AND DATE_FORMAT(LAST_DAY('#endDate#'), '%Y-%m-%d 23:59:59') then concat(dr.name, " = (" , do.quantity , ") " , " " , cm.name) end) as CTXDapsone,
GROUP_CONCAT(case when c.uuid NOT IN ('13382e01-9f18-488b-b2d2-58ab54c82d82' , 'e2acae74-9559-49b7-a5a7-36b633a5427d', '9844649e-0411-4011-a1f8-4a0da4155c76','f8c61966-0a8a-425f-858c-93dfabc1c82c') and o.date_created BETWEEN DATE_FORMAT('#startDate#' , '%Y-%m-01 00:00:00')
AND DATE_FORMAT(LAST_DAY('#endDate#'), '%Y-%m-%d 23:59:59') then concat(dr.name, " = (" , do.quantity , ") " , " " , cm.name) end) as OtherDrugs
from person_attribute as pa 
INNER JOIN person_attribute_type as pat on pa.person_attribute_type_id = pat.person_attribute_type_id  
INNER JOIN person as p on pa.person_id = p.person_id 
LEFT JOIN person_name as pn on p.person_id = pn.person_id 
LEFT JOIN patient as pt on p.person_id = pt.patient_id
inner join person_attribute e2 on pa.person_id = e2.person_id
inner JOIN orders as o on o.patient_id = pt.patient_id
LEFT JOIN drug_order do on o.order_id = do.order_id
INNER JOIN drug dr on o.concept_id = dr.concept_id
LEFT JOIN concept_name as cm on cm.concept_id = do.quantity_units
left join concept as c on dr.dosage_form = c.concept_id
where pa.person_attribute_type_id = 29  and e2.person_attribute_type_id =32
group by o.patient_id