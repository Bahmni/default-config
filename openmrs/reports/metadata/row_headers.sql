CREATE TABLE row_header_name_map(
id INT PRIMARY KEY AUTO_INCREMENT,
name_key VARCHAR(255) NOT NULL,
name_value VARCHAR(255) NOT NULL,
report_group_name VARCHAR(255) NOT NULL,
sort_order INT NOT NULL DEFAULT 0
);



INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('New Patients', 'Total Additions - New cases never registered earlier', 'Leprosy-Total Additions', 1); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Relapse', 'Total Additions - Relapsed cases', 'Leprosy-Total Additions', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Re-starter', 'Total Additions - Retreatment cases', 'Leprosy-Total Additions', 3); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Transfer In','Total Additions - Transferred in cases',  'Leprosy-Total Additions', 4); 

INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Release from Treatment – RFT','Total Deducted - No of patients released from treatment (RFT)',  'Leprosy-Total Deducted', 1); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Transfer Out - TO', 'Total Deducted - No of patients transferred elsewhere', 'Leprosy-Total Deducted', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Defaulter – DF', 'Total Deducted - Defaulters', 'Leprosy-Total Deducted', 3); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Other Deduction - OD','Total Deducted - Other deducted from treatment',  'Leprosy-Total Deducted', 4);
            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('PV - Indigenous', 'Plasmodium Vivax - Indigenous', 'Types of Malaria', 1); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('PV - Imported', 'Plasmodium Vivax - Imported', 'Types of Malaria', 2);  
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('PF - Indigenous', 'Plasmodium Falciparum - Indigenous', 'Types of Malaria', 3);  
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('PF - Imported', 'Plasmodium Falciparum - Imported', 'Types of Malaria', 4);  
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('PM - Indigenous', 'Plasmodium Mixed - Indigenous', 'Types of Malaria', 5);  
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('PM - Imported', 'Plasmodium Mixed - Imported', 'Types of Malaria', 6);  
            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Suspected / Probable', 'No. of Malaria cases - Suspected/Probable', 'Malaria-No of malaria cases', 1);             
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Confirmed Uncomplicated', 'No. of Malaria cases - Confirmed Uncomplicated', 'Malaria-No of malaria cases', 2);             
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Probable Severe', 'No. of Malaria cases - Probable Severe', 'Malaria-No of malaria cases', 3);             
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Confirmed Severe', 'No. of Malaria cases - Confirmed Severe', 'Malaria-No of malaria cases', 4);             

INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Suspected / Probable', 'Treatment of Malaria - Suspected/Probable', 'Malaria-Treatment of Malaria', 1);             
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Confirmed Uncomplicated', 'Treatment of Malaria - Confirmed Uncomplicated', 'Malaria-Treatment of Malaria', 2);             
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Probable Severe', 'Treatment of Malaria - Probable Severe','Malaria-Treatment of Malaria', 3);             
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Confirmed Severe', 'Treatment of Malaria - Confirmed Severe', 'Malaria-Treatment of Malaria', 4);     
            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Pulmonary BC', 'Pulmonary (BC)', 'Tuberculosis-Case Registration', 1);
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Pulmonary CD', 'Pulmonary (CD)', 'Tuberculosis-Case Registration', 2);
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Extra pulmonary', 'Extra Pulmonay (BC or CD)', 'Tuberculosis-Case Registration', 3);

INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('New Diagnosis', 'All New', 'Tuberculosis-Registration', 1);
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Relapse', 'All Relapse', 'Tuberculosis-Registration', 2);
            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Community', 'Referred by Community', 'Tuberculosis-Referral', 1);
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Private Health Facility', 'Referred/Diagnosed by Private HF', 'Tuberculosis-Referral', 2);
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Diagnosed by contact tracing', 'Diagnosed by Contact Tracing', 'Tuberculosis-Referral', 3);

INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('M', 'Male', 'Generic', 1);
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('F', 'Female', 'Generic', 2);
            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('New Diagnosis', 'PBC - New', 'Tuberculosis-PBC Treatment outcome', 1);            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Relapse', 'PBC - Relapse', 'Tuberculosis-PBC Treatment outcome', 2);            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment after failure', 'PBC - Treatment After Failure', 'Tuberculosis-PBC Treatment outcome', 3);            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment after loss to follow-up', 'PBC - Treatment After Lost to Follow-up', 'Tuberculosis-PBC Treatment outcome', 4);            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Other previously treated', 'PBC - Others previously treated', 'Tuberculosis-PBC Treatment outcome', 5);            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Previous treatment history unknown', 'PBC - Previous Treatment History Unknown ', 'Tuberculosis-PBC Treatment outcome', 6);        
            
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('New Diagnosis', 'PCD - New', 'Tuberculosis-PCD Treatment outcome', 1);   
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Relapse', 'PCD - Others', 'Tuberculosis-PCD Treatment outcome', 2);
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment after failure', 'PCD - Others', 'Tuberculosis-PCD Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment after loss to follow-up', 'PCD - Others', 'Tuberculosis-PCD Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Other previously treated', 'PCD - Others', 'Tuberculosis-PCD Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Previous treatment history unknown', 'PCD - Others', 'Tuberculosis-PCD Treatment outcome', 2);             
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Transfer in', 'PCD - Others', 'Tuberculosis-PCD Treatment outcome', 2);             

INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('New Diagnosis', 'EP (BC or CD) - New', 'Tuberculosis-EP Treatment outcome', 1); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Relapse', 'EP (BC or CD) - Others', 'Tuberculosis-EP Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment after failure', 'EP (BC or CD) - Others', 'Tuberculosis-EP Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment after loss to follow-up', 'EP (BC or CD) - Others', 'Tuberculosis-EP Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Other previously treated', 'EP (BC or CD) - Others', 'Tuberculosis-EP Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Previous treatment history unknown', 'EP (BC or CD) - Others', 'Tuberculosis-EP Treatment outcome', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Transfer in', 'EP (BC or CD) - Others', 'Tuberculosis-EP Treatment outcome', 2); 


INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('New Diagnosis', 'New', 'DRTuberculosis-Case Registration', 1); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Relapse', 'Relapse', 'DRTuberculosis-Case Registration', 2); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment after loss to follow-up', 'Treatment after loss to follow-up', 'DRTuberculosis-Case Registration', 3); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment After Failure Category I', 'Treatment After Failure (Cat I)', 'DRTuberculosis-Case Registration', 4); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Treatment After Failure Category II', 'Treatment After Failure (Cat II)', 'DRTuberculosis-Case Registration', 5); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Transfer In', 'Transfer In', 'DRTuberculosis-Case Registration', 5); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Still Under Treatment', 'Others', 'DRTuberculosis-Case Registration', 6); 
INSERT INTO row_header_name_map(name_key, name_value, report_group_name, sort_order)
			VALUES('Others', 'Others', 'DRTuberculosis-Case Registration', 6); 
            
select * from row_header_name_map;