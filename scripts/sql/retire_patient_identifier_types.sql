update idgen_identifier_source set retired = true where name != "GAN";

select * from idgen_identifier_source;