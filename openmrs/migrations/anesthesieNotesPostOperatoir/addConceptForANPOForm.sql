set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Heure de début d\'anesthésie","Heure de début d\'anesthésie",'Datetime','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Heure de fin d\'anesthésie","Heure de fin d\'anesthésie",'Datetime','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Type d'anesthésie réalisée","Type d'anesthésie réalisée",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Drogues spéciales utilisées pendant la chirurgie","Drogues spéciales utilisées pendant la chirurgie",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Complication de l\'anesthésie","Complication de l\'anesthésie",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Description de la complication","Description de la complication",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Transfuson sanguine","Transfuson sanguine",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Produit sanguin administré en per opératoire","Produit sanguin administré en per opératoire",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Nombre d\'unités administrées","Nombre d\'unités administrées",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Réaction transfusionnelle per operatoire","Réaction transfusionnelle per operatoire",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Commentaires","Commentaires",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Quantité de fluides reçue","Quantité de fluides reçue",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hemoglobine (Hb)","Hemoglobine (Hb)",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Glycémie","Glycémie",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Matériel présent","Matériel présent",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Notes d'anesthésie post opératoire","Notes d'anesthésie post opératoire",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"None","None",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"GAL","GAL",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"RSA","RSA",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"RPX","RPX",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"RTA","RTA",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"RAO","RAO",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"LOA","LOA",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SED","SED",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"INF","INF",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Reaction allergique","Reaction allergique",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Bronchospasm","Bronchospasm",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Dysrythmie cardiaque","Dysrythmie cardiaque",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Lésion dentaire","Lésion dentaire",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hypotension","Hypotension",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hypothermie","Hypothermie",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Lésions positionnelles","Lésions positionnelles",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Aspiration pulmonaire","Aspiration pulmonaire",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Saignement non anticipé","Saignement non anticipé",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Sang Total","Sang Total",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CG","CG",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"PFC","PFC",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Plaquettes","Plaquettes",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Albumine","Albumine",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ABO incompatibility","ABO incompatibility",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Anaphylaxis","Anaphylaxis",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Fever","Fever",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hemolysis","Hemolysis",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Rash","Rash",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Urticaria","Urticaria",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Catheter Foley","Catheter Foley",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Voie veineuse Peripherique","Voie veineuse Peripherique",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"PICC Line","PICC Line",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"VVC","VVC",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Sonde nasogastrique","Sonde nasogastrique",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Transfusion","Transfusion",'N/A','Misc',true);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Intra-operative Labs","Intra-operative Labs",'N/A','Misc',true);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "Nombre d\'unités administrées" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "Quantité de fluides reçue" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"ml",1,1);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "Hemoglobine (Hb)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "Type d\'anesthésie réalisée" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'GAI: GA with intubation; GAO: GA with nothing or facial mask; GAL: GA with laryngeal mask; RSA: Spinal; RPX: Plexus or Trunk block/ Axillary/ Femoral/ Sciatic; RTA: Transverse abdominal plane block; RAO: Other; LOA: Local anaesthesia; SED: Sedation; INF: Infiltration by surgeon','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "Type d\'anesthésie réalisée" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'GAI: GA with intubation; GAO: GA with nothing or facial mask; GAL: GA with laryngeal mask; RSA: Spinal; RPX: Plexus or Trunk block/ Axillary/ Femoral/ Sciatic; RTA: Transverse abdominal plane block; RAO: Other; LOA: Local anaesthesia; SED: Sedation; INF: Infiltration by surgeon','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "Drogues spéciales utilisées pendant la chirurgie" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'ex. Anti-hypertensives','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "Drogues spéciales utilisées pendant la chirurgie" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'ex. Anti-hypertensives','en',1,now(),NULL,NULL,uuid());
