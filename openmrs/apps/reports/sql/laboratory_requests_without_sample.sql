select
   pi.identity_data  as "NID",
   CONCAT( p.first_name, ' ', COALESCE( p.middle_name, '' ), ' ', COALESCE( p.last_name, '' ) )as "Nome Completo",
   case
      when
         pt.gender = 'M' 
      then
         'Masculino' 
      when
         pt.gender = 'F' 
      then
         'Feminino' 
      when
         pt.gender = 'O' 
      then
         'Outro' 
   end
   as "Sexo",
   date_part('year',AGE(pt.birth_date)) as "Idade",
   p.Cell_phone AS "Contacto Principal",
   string_agg(DISTINCT(case when ap.part_name = 'level6' then pa.value end), ' ') as "Província",
   string_agg(DISTINCT(case when ap.part_name = 'level2' then pa.value end), ' ') as "Distrito",
   string_agg(DISTINCT(case when ap.part_name = 'level3' then pa.value end), ' ') as "Administrativa",
   string_agg(DISTINCT(case when ap.part_name = 'level1' then pa.value end), ' ') as "Localidade/Bairro",
   string_agg(DISTINCT(case when ap.part_name = 'level4' then pa.value end), ' ') as "Quarteirão" 
   from
         person p
         inner join 
         patient pt
            on p.id=pt.person_id
         inner join
            sample_human sh
            on pt.id = sh.patient_id 
         inner join
            patient_identity pi
            on pi.patient_id = pt.id
        inner join 
            patient_identity_type pit
            on (pi.identity_type_id = pit.id 
            and pit.identity_type = 'ST')
         inner join
            sample s
            on s.id = sh.samp_id 
            and s.accession_number is null
            and cast(s.entered_date as date) BETWEEN '#startDate#' and '#endDate#'
         inner join
            person_address pa
            on p.id = pa.person_id
         inner join
            address_part ap
            on pa.address_part_id=ap.id
            group by p.id,pi.id,pt.id,sh.patient_id;