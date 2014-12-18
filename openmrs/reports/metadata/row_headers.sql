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
            
