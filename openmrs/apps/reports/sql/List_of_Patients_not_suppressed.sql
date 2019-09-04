select distinct
(pi.identifier) as "NID",
   CONCAT( pn.given_name, " ", COALESCE( pn.middle_name, '' ), " ", COALESCE( pn.family_name, '' ) )as "Nome Completo",
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
   as "Sexo", TIMESTAMPDIFF( YEAR, p.birthdate, CURDATE() ) as "Idade",
   personAttributesonRegistration.value as "Contacto",
   paddress.state_province as "Província",
   paddress.city_village AS "Distrito",
   paddress.address1 AS "Localidade / Bairro",
   paddress.address3 AS "Quarteirão",
   paddress.address4 AS "Avenida / Rua",
   paddress.address5 AS "Nº da Casa",
   paddress.postal_code AS "Perto De",
   treatment_line.concept_full_name as "Última Linha de Tratamento",
   cast(o.value_numeric as char)as "Valor do Resultado da última Carga Viral",
   cast(o.date_created as date) as "Data do Resultado da Carga Viral"
from
   person p 
   inner join
      person_name pn 
      on pn.person_id = p.person_id 
      and p.voided = 0 
      and pn.voided = 0 
   inner join
      patient_identifier pi 
      on pi.patient_id = p.person_id 
      and pi.voided = 0 
   inner join
      patient pt 
      on pt.patient_id = p.person_id 
      and pi.voided = 0 
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
   Inner Join
      obs o 
      on o.person_id = p.person_id
      and o.voided = 0        
   Inner JOIN
      (
         select
            max(o.obs_id) as obs_id
         from
            person p
            Inner Join
               obs o
               on o.person_id = p.person_id
               and o.voided = 0
            Inner Join
               concept_view cv
               on o.concept_id = cv.concept_id
               and cv.retired = 0
               and cv.concept_full_name = 'LO_ViralLoad'
               and o.value_numeric > 1000
               and cast(o.date_created as date) <= '#endDate#'
         group by
            p.person_id
      )
      as Viralload
      on Viralload.obs_id = o.obs_id
   inner join 
         orders ord
         on ord.patient_id = pt.patient_id
   left join orders ord2
         on ord.patient_id=ord2.patient_id and ord.order_id<ord2.order_id
   inner join drug_order
         on drug_order.order_id=ord.order_id
   inner join drug_order_relationship dor
         on drug_order.order_id=dor.drug_order_id
      and cast(dor.date_created as date) <= '#endDate#'
   Inner join concept_view  treatment_line
      on treatment_line.concept_id = dor.treatment_line_id
   LEFT OUTER JOIN
      person_address paddress 
      ON p.person_id = paddress.person_id 
      AND paddress.voided is false
      where ord2.order_id IS NULL;