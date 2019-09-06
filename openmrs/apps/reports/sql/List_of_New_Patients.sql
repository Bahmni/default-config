select distinct
(pi.identifier) as "NID",
CONCAT( pn.given_name, " ", COALESCE( pn.middle_name, '' ), " ", COALESCE( pn.family_name, '' ) )as "Nome Completo ",
case
      when
         p.gender = 'M' 
      then
         'Masculino' 
      when
         p.gender = 'F' 
      then
         'Feminino' 
      when
         p.gender = 'O' 
      then
         'Outro' 
   end
   as "Sexo",
   TIMESTAMPDIFF( YEAR, p.birthdate, CURDATE() ) as "Idade",
   personAttributesonRegistration.value as "Contacto",
   paddress.state_province as "Província",
   paddress.city_village AS "Distrito",
   paddress.address1 AS "Localidade/Bairro",
   paddress.address3 AS "Quarteirão",
   paddress.address4 AS "Avenida/Rua",
   paddress.address5 AS "Nº da Casa",
   paddress.postal_code AS "Perto De",
   cast(pt.date_created as date) AS "Data de Registo na US",
   concat(case
      when
         pss.patient_state = 'ABANDONED'
      then
         'Abandono'
      when
         pss.patient_state = 'ACTIVE'
      then
         'Activo'
      when
         pss.patient_state = 'INACTIVE_DEATH'
      then
         'Inactive Óbito'
      when
         pss.patient_state = 'INACTIVE_TRANSFERRED_OUT'
      then
         'Inactivo Transferir para'
      when
         pss.patient_state = 'INACTIVE_SUSPENDED'
      then
         'Inactivo Paciente Suspensão'
   end,' - ',
   case
      when
         pss.patient_status = 'Pre TARV'
      then
         'Pre TARV'
      when
         pss.patient_status = 'TARV'
      then
         'TARV'
      when
         pss.patient_status = 'TARV_ABANDONED'
      then
         'TARV-Abandono'
      when
         pss.patient_status = 'TARV_TREATMENT_SUSPENDED'
      then
         'TARV-Tratamento Suspenso'
      when
         pss.patient_status = 'TARV_RESTART'
      then
         'TARV-Reinício'
   end ) AS "Estado de Permanência",
   cast(erpdrug_order.dispensed_date as date) AS "Data de Inicio TARV"
from
   person p 
   INNER JOIN
      person_name pn 
      on pn.person_id = p.person_id 
      and p.voided = 0 
      and pn.voided = 0 
   INNER JOIN
      patient_identifier pi 
      on pi.patient_id = p.person_id 
      and pi.voided = 0
   INNER JOIN
      patient pt 
      on pt.patient_id = p.person_id
      and pi.voided = 0
      and cast(pt.date_created as date) BETWEEN '#startDate#' and '#endDate#'
   LEFT JOIN
      person_attribute personAttributesonRegistration 
      on personAttributesonRegistration.person_id = p.person_id 
      and personAttributesonRegistration.voided = 0 
   INNER JOIN
      person_attribute_type personAttributeTypeonRegistration 
      on personAttributesonRegistration.person_attribute_type_id = personAttributeTypeonRegistration.person_attribute_type_id 
      and personAttributeTypeonRegistration.name = 'PRIMARY_CONTACT_NUMBER_1' 
   LEFT JOIN
      person_attribute pa 
      on pa.person_id = p.person_id 
      and pa.voided = 0 
   INNER JOIN
      person_attribute_type pat 
      on pa.person_attribute_type_id = pat.person_attribute_type_id 
      and personAttributeTypeonRegistration.name = 'PRIMARY_CONTACT_NUMBER_1' 
   JOIN
      concept_view cv 
      on pa.value = cv.concept_id 
      AND cv.retired = 0 
      and cv.concept_full_name = 'NEW_PATIENT' 
   INNER JOIN
      patient_status_state pss
      on pss.patient_id=pt.patient_id
   LEFT JOIN
      patient_status_state pss2
      on pss.patient_id=pss2.patient_id and pss.id < pss2.id
   LEFT JOIN
      erpdrug_order
      on erpdrug_order.patient_id=pss.patient_id
      and first_arv_dispensed = 1 and arv_dispensed = 1
   LEFT OUTER JOIN
      person_address paddress 
      ON p.person_id = paddress.person_id 
      AND paddress.voided is false
      where pss2.id IS NULL;