CREATE TABLE possible_address_group(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
report_group_name VARCHAR(255) NOT NULL,
district_name VARCHAR(255),
country_name VARCHAR(255),
sort_order INT NOT NULL DEFAULT 0
);

INSERT INTO possible_address_group(name, report_group_name, district_name, country_name, sort_order)
			VALUES('Within District', 'Kalaazar Report', 'Achham', 'Nepal', 1); 
INSERT INTO possible_address_group(name, report_group_name, district_name, country_name, sort_order)
			VALUES('Outside District', 'Kalaazar Report', null, 'Nepal', 2); 
INSERT INTO possible_address_group(name, report_group_name, district_name, country_name, sort_order)
			VALUES('Foreigner', 'Kalaazar Report', null, null, 3);
