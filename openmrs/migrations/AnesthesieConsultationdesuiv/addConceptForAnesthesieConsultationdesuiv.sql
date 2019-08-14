set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Date la consultation","Date la consultation",'Datetime','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Antécédents médicaux","Antécédents médicaux",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Traitement en cours","Traitement en cours",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Le patient a-t-il des allergies connues a des médicaments ?","Le patient a-t-il des allergies connues a des médicaments ?",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Type de traitement pour les allergies","Type de traitement pour les allergies",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Antécédents anesthésiques","Antécédents anesthésiques",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Mallampati, classe","Mallampati, classe",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Ouverture de la bouche","Ouverture de la bouche",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Score d\'ASA","Score d\'ASA",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Type d'intervention prévue","Type d'intervention prévue",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Type d\'anesthésie prévue","Type d\'anesthésie prévue",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Changement de pansement","Changement de pansement",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Débridement/Excision","Débridement/Excision",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Greffe de peau pleine","Greffe de peau pleine",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Insertion d'un cathéter central périphérique","Insertion d'un cathéter central périphérique",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Insertion / retrait drain ou tube","Insertion / retrait drain ou tube",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Manipulation sous anesthésie","Manipulation sous anesthésie",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Bloc nerveux","Bloc nerveux",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Enlèvement de sutures (pinces, etc.), peau","Enlèvement de sutures (pinces, etc.), peau",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Révision de cicatrice","Révision de cicatrice",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Collecte d'échantillons pour la microbiologie, écouvillon","Collecte d'échantillons pour la microbiologie, écouvillon",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Drainage des plaies","Drainage des plaies",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Débridement d'os","Débridement d'os",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Insertion VVC","Insertion VVC",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Lambeau inguinal","Lambeau inguinal",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Incisions de décharge","Incisions de décharge",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pansement à la sulfadiazine","Pansement à la sulfadiazine",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pansement à l'acétate de mafénide","Pansement à l'acétate de mafénide",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pansement au gel de betadine","Pansement au gel de betadine",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pansement àl'alginate de calcium","Pansement àl'alginate de calcium",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pansement humide à la betadine","Pansement humide à la betadine",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hémostase aux fils de suture","Hémostase aux fils de suture",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hémostase au surgicel","Hémostase au surgicel",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hémostase au cauter","Hémostase au cauter",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Lachage de fils de suture","Lachage de fils de suture",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, J'ai discuté les risques et bénéfices de l'anesthésie et ai répondu à toutes les questions?","J'ai discuté les risques et bénéfices de l'anesthésie et ai répondu à toutes les questions?",'coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ACS, Commentaires","Commentaires",'Text','Misc',false);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "ACS, Ouverture de la bouche" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'fr'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "ACS, Type d\'anesthésie prévue" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'GA with intubation; GA with nothing or facial mask; GA with laryngeal mask; Spinal; Plexic or Troncular: Axillary/Femoral/Sciatic; Transverse Abdominal Plane Bloc; Other Regional Technique; Local Anaesthesia; Sedation; Inflitration by surgeon','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "ACS, Type d\'anesthésie prévue" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'GA with intubation; GA with nothing or facial mask; GA with laryngeal mask; Spinal; Plexic or Troncular: Axillary/Femoral/Sciatic; Transverse Abdominal Plane Bloc; Other Regional Technique; Local Anaesthesia; Sedation; Inflitration by surgeon','en',1,now(),NULL,NULL,uuid());

