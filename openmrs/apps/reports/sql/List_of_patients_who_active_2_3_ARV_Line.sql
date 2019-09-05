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
   as "Sexo", TIMESTAMPDIFF( YEAR, p.birthdate, CURDATE() ) as "Idade",
   personAttributesonRegistration.value as "Contacto",
   paddress.state_province as "Província",
   paddress.city_village AS "Distrito",
   paddress.address1 AS "Localidade/Bairro",
   paddress.address3 AS "Quarteirão",
   paddress.address4 AS "Avenida/Rua",
   paddress.address5 AS "Nº da Casa",
   paddress.postal_code AS "Perto De",
   (select itreatment_line.concept_full_name as "Última Linha de Tratamento"
    from patient ipt 
    inner join orders io
         on ipt.patient_id=io.patient_id
    inner join drug_order_relationship idor
         on idor.drug_order_id=io.order_id
    inner join concept_view  itreatment_line
         on itreatment_line.concept_id = idor.treatment_line_id
    where ipt.patient_id = pt.patient_id
    and (itreatment_line.concept_full_name ='3rd Line' or itreatment_line.concept_full_name ='2nd Line')
    order by io.order_id desc limit 1) as "Última Linha de Tratamento",
    cast(dor.date_created as date) as "Data de Mudança de Linha"
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
    LEFT OUTER JOIN
      person_address paddress 
      ON p.person_id = paddress.person_id 
      AND paddress.voided is false
    INNER JOIN
      obs o
      on p.person_id=o.person_id 
      and o.voided = 0
    inner join
        concept con
        on con.concept_id = o.concept_id
        and con.retired=0
    inner join
        concept_name conname
        on con.concept_id=conname.concept_id
        and conname.name = 'Dispensed' and concept_name_type ='FULLY_SPECIFIED' and locale ='en'
        and conname.voided = 0
    inner join encounter e 
         on o.encounter_id=e.encounter_id
   inner join 
         orders ord
         on ord.patient_id = pt.patient_id
         and o.order_id=ord.order_id
   inner join drug_order
         on drug_order.order_id=ord.order_id
   inner join drug_order_relationship dor
         on drug_order.order_id=dor.drug_order_id
         and cast(dor.date_created as date) BETWEEN '#startDate#' and '#endDate#'  
   inner join concept_view  treatment_category
         on treatment_category.concept_id = dor.category_id
         and treatment_category.concept_full_name ='ARV'
   inner join concept_view  treatment_line
         on treatment_line.concept_id = dor.treatment_line_id
         where  (treatment_line.concept_full_name ='3rd Line' or treatment_line.concept_full_name ='2nd Line')
         group by pt.patient_id;