DROP PROCEDURE IF EXISTS create_bed_management_user;
#
CREATE PROCEDURE create_bed_management_user( user_gender varchar(50),
                                             user_given_name varchar(50),
                                             user_family_name varchar(50),
                                             user_username varchar(50),
                                             user_password varchar(128),
                                             user_salt varchar(128))
  BEGIN
    SET @puuid = uuid();
    INSERT INTO person (gender, creator, date_created, uuid) VALUES (user_gender, 6, now(), @puuid);
    INSERT INTO person_name (person_id, given_name, family_name,creator, date_created, uuid) VALUES ((SELECT person_id FROM person where uuid=@puuid),user_given_name,user_family_name,6, now(), uuid());
    INSERT INTO users (system_id, username, password, salt, creator, date_created, changed_by, person_id,retired,uuid) VALUES (user_username, user_username, user_password, user_salt, 6,now(),6,(SELECT person_id FROM person where uuid=@puuid),0,uuid());
    INSERT INTO user_role VALUES ((SELECT max(user_id) FROM users),"Registration-App"),((SELECT max(user_id) FROM users),"InPatient-App"),((SELECT max(user_id) FROM users),"Clinical-App");
    INSERT INTO provider (person_id, creator, date_created, retired, uuid)VALUES ((SELECT person_id FROM person where uuid=@puuid),6,now(),0,uuid());
  END
#







