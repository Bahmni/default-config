DROP TABLE IF EXISTS bahmni_report_labels;
CREATE TABLE bahmni_report_labels (
  section_name VARCHAR(255),
  column_name VARCHAR(255),
  key_string VARCHAR(255),
  value_string VARCHAR(255),
  sort_order INTEGER DEFAULT 0
);

INSERT INTO bahmni_report_labels (section_name, column_name, key_string, value_string, sort_order)
VALUES ('ART_treatment_adherence', 'adherence_level', 'Adherence Level A', '< 95% (A)', 1);
INSERT INTO bahmni_report_labels (section_name, column_name, key_string, value_string, sort_order)
VALUES ('ART_treatment_adherence', 'adherence_level', 'Adherence Level B', '80-95% (B)', 2);
INSERT INTO bahmni_report_labels (section_name, column_name, key_string, value_string, sort_order)
VALUES ('ART_treatment_adherence', 'adherence_level', 'Adherence Level C', '< 80% (C)', 3);