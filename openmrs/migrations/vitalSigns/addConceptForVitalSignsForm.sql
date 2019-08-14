set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Date et Heure enregistrée","Date et Heure enregistrée","Datetime","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Poids","Poids","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Taille","Taille","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Indice de masse corporelle (IMC)","Indice de masse corporelle (IMC)","Numeric","Computed",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Frequence Respiratoire","Frequence Respiratoire","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Temperature","Temperature","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Pouls","Pouls","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Pression Arterielle Systolique (PAS)","Pression Arterielle Systolique (PAS)","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Pression Arterielle Diastolique (PAD)","Pression Arterielle Diastolique (PAD)","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Saturation en Oxygène","Saturation en Oxygène","Numeric","Finding",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Glycémie","Glycémie","Numeric","Test",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SV, Hemocue","Hemocue","Numeric","Test",false);


INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Poids" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"kg",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Taille" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"cm",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Indice de masse corporelle (IMC)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Frequence Respiratoire" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"resp/minute",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Temperature" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"°C",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Pouls" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"bpm",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Pression Arterielle Systolique (PAS)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"mmHg",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Pression Arterielle Diastolique (PAD)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"mmHg",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Saturation en Oxygène" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"%",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Glycémie" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"mg/dl",1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "SV, Hemocue" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"g/dl",1,NULL);


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = 'SV, Indice de masse corporelle (IMC)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'auto-calcuated','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = 'SV, Indice de masse corporelle (IMC)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'auto-calcuated','en',1,now(),NULL,NULL,uuid());
