CREATE TABLE possible_weight_group(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
report_group_name VARCHAR(255) NOT NULL,
min_weight DOUBLE NOT NULL DEFAULT 0,
max_weight DOUBLE NOT NULL DEFAULT 0,
sort_order INT NOT NULL DEFAULT 0
);

INSERT INTO possible_weight_group(name, report_group_name, min_weight, max_weight, sort_order)
			VALUES('Very low (< 2)', 'Birth Weight Report', 0, 2000, 3); 
INSERT INTO possible_weight_group(name, report_group_name, min_weight, max_weight, sort_order)
			VALUES('Low (2 to </ 2.5)', 'Birth Weight Report', 2000, 2499, 2); 
INSERT INTO possible_weight_group(name, report_group_name, min_weight, max_weight, sort_order)
			VALUES('Normal (>/2.5)', 'Birth Weight Report', 2500, 99999, 1	); 
		