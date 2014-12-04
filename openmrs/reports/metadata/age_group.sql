-- Meta Data Schema
CREATE TABLE possible_age_group(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
report_group_name VARCHAR(255) NOT NULL,
min_years INT NOT NULL DEFAULT 0,
min_days INT NOT NULL DEFAULT 0,
max_years INT NOT NULL DEFAULT 0,
max_days INT NOT NULL DEFAULT 0,
sort_order INT NOT NULL DEFAULT 0
);

-- Meta Data
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order) 
			VALUES('≤ 28 Days', 'Inpatient Discharge Reports', 0, 0, 0, 28, 1);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('29 Days ‐ 1 Year', 'Inpatient Discharge Reports', 0, 29, 1, -1, 2);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('01 ‐ 04 Years', 'Inpatient Discharge Reports', 1, 0, 5, -1, 3);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('05 ‐ 14 years', 'Inpatient Discharge Reports', 5, 0, 15, -1, 4);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('15 ‐ 19 Years', 'Inpatient Discharge Reports', 15, 0, 20, -1, 5);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('20 ‐ 29 Years', 'Inpatient Discharge Reports', 20, 0, 30, -1, 6);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('30 ‐ 39 Years', 'Inpatient Discharge Reports', 30, 0, 40, -1, 7);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('40 ‐ 49 Years', 'Inpatient Discharge Reports', 40, 0, 50, -1, 8);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('50 ‐ 59 Years', 'Inpatient Discharge Reports', 50, 0, 60, -1, 9);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('≥ 60 Years', 'Inpatient Discharge Reports', 60, 0, 999, 0, 10);
            
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('0 - 09 Years', 'Client Service Reports', 0, 0, 10, -1, 1); 
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('10 - 19 Years', 'Client Service Reports', 10, 0, 20, -1, 2); 
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('20 - 59 Years', 'Client Service Reports', 20, 0, 60, -1, 3); 
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('≥ 60 Years', 'Client Service Reports', 60, 0, 999, 0, 4); 

INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('No. of women < 20 Years', 'Safe Abortion Service', 0, 0, 20, -1, 1); 
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('No. of women ≥ 20 Years', 'Safe Abortion Service', 20, 0, 999, 0, 2);          
            
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('</ 28 days', 'Childhood Illness 2months', 0, 0, 0, 28, 1);     
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('29 - 59 days', 'Childhood Illness 2months', 0, 29, 0, 59, 2);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('2 - 59 months', 'Childhood Illness 59months', 0, 60, 5, -1, 3);
            
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('0 - 4 years', 'Tuberculosis registration', 0, 0, 5, -1, 1);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('5 - 14 years', 'Tuberculosis registration', 5, 0, 15, -1, 2);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('15 - 24 years', 'Tuberculosis registration', 15, 0, 25, -1, 3);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('25 - 34 years', 'Tuberculosis registration', 25, 0, 35, -1, 4);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('35 - 44 years', 'Tuberculosis registration', 35, 0, 45, -1, 5);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('45 - 54 years', 'Tuberculosis registration', 45, 0, 55, -1, 6);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('55 - 64 years', 'Tuberculosis registration', 55, 0, 65, -1, 7);
INSERT INTO possible_age_group(name, report_group_name, min_years, min_days, max_years , max_days, sort_order)
			VALUES('>/65 years', 'Tuberculosis registration', 65, 0, 999, 0, 8);