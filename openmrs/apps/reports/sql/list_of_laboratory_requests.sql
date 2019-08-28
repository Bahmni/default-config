select
   dataquery.test_name as "Exame",
   dataquery.test_count as "Número de exames",
   dataquery.report_flag as "Estado",
   dataquery.hf_name as "Unidade Sanitária" 
from
   (
      select
         test.name as "test_name",
         count(test.name) as "test_count",
         case
            when
               organization.name is NOT NULL 
            then
               organization.name 
            when
               organization.name is NULL 
            then
               'Health Facility' 
         end
         as "hf_name", 'Total Pedidos' as "report_flag" 
      from
         patient 
         inner join
            sample_human 
            on patient.id = sample_human.patient_id 
         inner join
            patient_identity 
            on patient_identity.patient_id = patient.id 
         inner join
            patient_identity_type 
            on (patient_identity.identity_type_id = patient_identity_type.id 
            and patient_identity_type.identity_type = 'ST') 
         inner join
            sample 
            on sample.id = sample_human.samp_id 
            AND date(sample.entered_date) between '#startDate#' and '#endDate#' 
         inner join
            sample_item 
            on sample.id = sample_item.samp_id 
         inner join
            analysis 
            on analysis.sampitem_id = sample_item.id 
         inner join
            test 
            on analysis.test_id = test.id 
         left join
            referral 
            on referral.analysis_id = analysis.id 
         left join
            organization 
            on organization.id = referral.organization_id 
      group by
         test.name, organization.name 
      union all
      select
         test.name as "test_name",
         count(test.name) as "test_count",
         case
            when
               organization.name is NOT NULL 
            then
               organization.name 
            when
               organization.name is NULL 
            then
               'Health Facility' 
         end
         as "hf_name", 'Total de amostras recolhidas' as "report_flag" 
      from
         patient 
         inner join
            sample_human 
            on patient.id = sample_human.patient_id 
         inner join
            patient_identity 
            on patient_identity.patient_id = patient.id 
         inner join
            patient_identity_type 
            on (patient_identity.identity_type_id = patient_identity_type.id 
            and patient_identity_type.identity_type = 'ST') 
         inner join
            sample 
            on sample.id = sample_human.samp_id 
            AND date(sample.lastupdated) between '#startDate#' and '#endDate#' 
            and sample.accession_number IS NOT NULL 
         inner join
            sample_item 
            on sample.id = sample_item.samp_id 
         inner join
            analysis 
            on analysis.sampitem_id = sample_item.id 
         inner join
            test 
            on analysis.test_id = test.id 
         left join
            referral 
            on referral.analysis_id = analysis.id 
         left join
            organization 
            on organization.id = referral.organization_id 
      group by
         test.name, organization.name 
      union all
      select
         test.name as "test_name",
         count(test.name) as "test_count",
         case
            when
               organization.name is NOT NULL 
            then
               organization.name 
            when
               organization.name is NULL 
            then
               'Health Facility' 
         end
         as "hf_name", 'Total com resultados disponíveis' as "report_flag" 
      from
         patient 
         inner join
            sample_human 
            on patient.id = sample_human.patient_id 
         inner join
            patient_identity 
            on patient_identity.patient_id = patient.id 
         inner join
            patient_identity_type 
            on (patient_identity.identity_type_id = patient_identity_type.id 
            and patient_identity_type.identity_type = 'ST') 
         inner join
            sample 
            on sample.id = sample_human.samp_id 
         inner join
            sample_item 
            on sample.id = sample_item.samp_id 
         inner join
            analysis 
            on analysis.sampitem_id = sample_item.id 
         inner join
            test 
            on analysis.test_id = test.id 
         inner join
            result r 
            on analysis.id = r.analysis_id 
            AND date(sample.lastupdated) between '#startDate#' and '#endDate#' 
         left join
            referral 
            on referral.analysis_id = analysis.id 
         left join
            organization 
            on organization.id = referral.organization_id 
      group by
         test.name, organization.name 
   )
   as dataquery ;