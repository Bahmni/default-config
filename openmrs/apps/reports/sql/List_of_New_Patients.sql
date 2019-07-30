select distinct(pi.identifier) as "NID",
  CONCAT(
    pn.given_name,
    " ",
    COALESCE(
      pn.middle_name,
      ''
    )," ",
    COALESCE(
      pn.family_name,
      ''
    )
  )as "Complete Name",
  personAttributesNICKNAME.value AS 'Alcunha',
  case when p.gender = 'M' then 'Male' when p.gender = 'F' then 'Female' when p.gender = 'O' then 'Other' end as "Sexo",
  TIMESTAMPDIFF(
    YEAR,
    p.birthdate,
    CURDATE()
  ) as "Idade",

  personAttributesonRegistration.value as "Contacto Principal",

  paddress.state_province AS 'Província', 
  paddress.city_village AS 'Distrito', 
  paddress.address1 AS 'Localidade/Bairro',
  paddress.address3 AS 'Quarteirão',
  paddress.address4 AS 'Avenida/Rua',
  paddress.address5 AS 'Nº da Casa',
  paddress.postal_code AS 'Perto De',
  cast(pt.date_created as date) AS 'Date of Registration at HF'
  
  from person p 
  inner join person_name pn on pn.person_id = p.person_id and p.voided=0 and pn.voided=0
  inner join patient_identifier pi on pi.patient_id=p.person_id and pi.voided=0
  inner join patient pt on pt.patient_id=p.person_id and pi.voided=0
  and cast(pt.date_created as date) BETWEEN '#startDate#' and '#endDate#'

  LEFT JOIN person_attribute personAttributesonRegistration on personAttributesonRegistration.person_id=p.person_id and personAttributesonRegistration.voided=0
  INNER JOIN person_attribute_type personAttributeTypeonRegistration on personAttributesonRegistration.person_attribute_type_id = personAttributeTypeonRegistration.person_attribute_type_id and personAttributeTypeonRegistration.name = 'PRIMARY_CONTACT_NUMBER_1'

  LEFT JOIN person_attribute personAttributesNICKNAME on personAttributesNICKNAME.person_id=p.person_id and personAttributesNICKNAME.voided=0
  and personAttributesNICKNAME.person_attribute_type_id in (select person_attribute_type_id from person_attribute_type where name = 'NICK_NAME')

  LEFT JOIN person_attribute pa on pa.person_id=p.person_id and pa.voided=0
  INNER JOIN person_attribute_type pat on pa.person_attribute_type_id = pat.person_attribute_type_id and personAttributeTypeonRegistration.name = 'PRIMARY_CONTACT_NUMBER_1'
  JOIN concept_view cv on pa.value = cv.concept_id AND cv.retired = 0 and cv.concept_full_name ='NEW_PATIENT'
  LEFT OUTER JOIN person_address paddress ON p.person_id = paddress.person_id AND paddress.voided is false 
   
  ;

